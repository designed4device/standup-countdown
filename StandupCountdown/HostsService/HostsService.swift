//
//  HostsService.swift
//  StandupCountdown
//
//  Created by Mike Wellen on 9/28/19.
//  Copyright © 2019 Mike Wellen. All rights reserved.
//

import Foundation

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
    func update() {
        updateInProgress = true
        guard let url = URL(string: PrefsViewController.xpBotUrl) else {
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
                break
            case .failure(_):
                print("failed to get hosts data")
                break
            }
            self.updateInProgress = false
        }.resume()
    }
}
