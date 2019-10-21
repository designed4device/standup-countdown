//
//  HostsService.swift
//  StandupCountdown
//
//  Created by Mike Wellen on 9/28/19.
//  Copyright © 2019 Mike Wellen. All rights reserved.
//

import Foundation
import AppKit

class HostsService {
    private let session = URLSession.shared
    private let defaults = UserDefaults.standard
    private let decoder = JSONDecoder.init()
    private let encoder = JSONEncoder.init()
    
    private var hostValue: Host?
    private var scribeValue: Host?
    private var backup1Value: Host?
    private var backup2Value: Host?
    
    static let INSTANCE = HostsService()
    
    private static let HOST_KEY = "Host"
    static var host: Host? {
        get {
            if let value = INSTANCE.hostValue {
                return value
            } else {
                return getHost(forKey: HOST_KEY)
            }
        }
    }
    
    private static let SCRIBE_KEY = "Scribe"
    static var scribe: Host? {
        get {
            if let value = INSTANCE.scribeValue {
                return value
            } else {
                return getHost(forKey: SCRIBE_KEY)
            }
        }
    }
    
    private static let BACKUP1_KEY = "Backup1"
    static var backup1: Host? {
        get {
            if let value = INSTANCE.backup1Value {
                return value
            } else {
                return getHost(forKey: BACKUP1_KEY)
            }
        }
    }
    
    private static let BACKUP2_KEY = "Backup2"
    static var backup2: Host? {
        get {
            if let value = INSTANCE.backup2Value {
                return value
            } else {
                return getHost(forKey: BACKUP2_KEY)
            }
        }
    }
    
    static func getHost(forKey: String) -> Host? {
        guard let data = INSTANCE.defaults.data(forKey: forKey) else {
            return nil
        }
        do {
            return try INSTANCE.decoder.decode(Host.self, from: data)
        } catch {
            return nil
        }
    }
    
    private var updateInProgress = false
    private var updateRetryCount = 0
    func updateHosts() {
        updateInProgress = true
        guard let url = url(withPath: "/hosts") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(PrefsViewController.xpBotAuthentication, forHTTPHeaderField: "Authorization")
        
        _ = session.dataTask(with: request) { (result) in
            switch result {
            case .success(_, let data):
                do {
                    let hosts = try JSONDecoder.init().decode([Host].self, from: data)
                    self.hostValue = hosts[0]
                    self.scribeValue = hosts[1]
                    self.backup1Value = hosts[2]
                    self.backup2Value = hosts[3]
                    try! self.defaults.setValue(self.encoder.encode(self.hostValue), forKey: HostsService.HOST_KEY)
                    try! self.defaults.setValue(self.encoder.encode(self.scribeValue), forKey: HostsService.SCRIBE_KEY)
                    try! self.defaults.setValue(self.encoder.encode(self.backup1Value), forKey: HostsService.BACKUP1_KEY)
                    try! self.defaults.setValue(self.encoder.encode(self.backup2Value), forKey: HostsService.BACKUP2_KEY)
                } catch {
                    print("failed to decode and save hosts data")
                }
                self.updateRetryCount = 0
                break
            case .failure(_):
                print("failed to get hosts data")
                if (self.updateRetryCount < 20) {
                    sleep(UInt32(self.updateRetryCount))
                    self.updateHosts()
                    self.updateRetryCount += 1
                } else {
                    print("too tired to retry anymore")
                    self.updateRetryCount = 0
                }
                break
            }
            self.updateInProgress = false
        }.resume()
    }
    
    private var sendRetryCount = 0
    func sendHostsToSlack() {
        guard let url = url(withPath: "/sendMessageAsBot") else {
            return
        }
        
        guard let message = slackHostsMessage() else {
            return
        }
        
        guard let body = try? encoder.encode(SlackMessage(channel: PrefsViewController.xpBotChannel, message: message)) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(PrefsViewController.xpBotAuthentication, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        request.httpMethod = "POST"
        
        _ = session.dataTask(with: request) { (result) in
            switch result {
            case .success(_,_):
                print("sent message to slack")
                self.sendRetryCount = 0
                break
            case .failure(_):
                print("failed to send message to slack")
                if (self.sendRetryCount < 20) {
                    sleep(UInt32(self.sendRetryCount))
                    self.sendHostsToSlack()
                    self.sendRetryCount += 1
                } else {
                    print("too tired to retry anymore")
                    self.sendRetryCount = 0
                }
                break
            }
        }.resume()
        
    }
    
    private func slackHostsMessage() -> String? {
        guard let host = HostsService.host?.id, let scribe = HostsService.scribe?.id, let backup1 = HostsService.backup1?.name, let backup2 = HostsService.backup2?.name else {
            return nil
        }
        
        return "<!here> It's stand up time! \n"
            + "Host: <@\(host)>\n"
            + "Scribe: <@\(scribe)>\n"
            + "Backup: \(backup1), \(backup2)\n"
            + "https://zoom.us/j/\(PrefsViewController.meetingId)"
    }
    
    private func url(withPath: String) -> URL? {
        return URL(string: PrefsViewController.xpBotUrl + withPath)
    }
}
