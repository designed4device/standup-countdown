//
//  PrefsViewController.swift
//  StandupCountdown
//
//  Created by Mike Wellen on 9/25/19.
//  Copyright © 2019 Mike Wellen. All rights reserved.
//

import Cocoa

class PrefsViewController: NSViewController {
    
    @IBOutlet weak var zoomToggleButtonCell: NSButtonCell!
    @IBOutlet weak var meetingIdTextField: NSTextField!
    @IBOutlet weak var standupTimeDatePicker: NSDatePicker!
    @IBOutlet weak var xpBotUrlTextField: NSTextField!
    @IBOutlet weak var xpBotAuthenticationTextField: NSSecureTextField!
    
    private static let ZOOM_TOGGLE_KEY = "ZoomToggle"
    private static let MEETING_ID_KEY = "MeetingId"
    private static let STANDUP_TIME_HOUR_KEY = "StandupTimeHour"
    private static let STANDUP_TIME_MINUTE_KEY = "StandupTimeMinute"
    private static let XP_BOT_URL_KEY = "XpBotUrl"
    private static let XP_BOT_AUTHENTICATION_KEY = "dev.wellen.keys.xpbot"
    
    public static var zoomToggle: Bool {
        get {
            if (UserDefaults.standard.integer(forKey: PrefsViewController.ZOOM_TOGGLE_KEY) == 1) {
                return true
            }
            return false
        }
    }
    
    public static var meetingId: String {
        get {
            return UserDefaults.standard.string(forKey: PrefsViewController.MEETING_ID_KEY) ?? ""
        }
    }
    
    public static var standupTimeHour: Int {
        get {
            if (UserDefaults.standard.dictionaryRepresentation().keys.contains(PrefsViewController.STANDUP_TIME_HOUR_KEY)) {
                return UserDefaults.standard.integer(forKey: PrefsViewController.STANDUP_TIME_HOUR_KEY)
            } else {
                return 8
            }
        }
    }
    
    public static var standupTimeMinute: Int {
        get {
            if (UserDefaults.standard.dictionaryRepresentation().keys.contains(PrefsViewController.STANDUP_TIME_MINUTE_KEY)) {
                return UserDefaults.standard.integer(forKey: PrefsViewController.STANDUP_TIME_MINUTE_KEY)
            } else {
                return 6
            }
        }
    }
    
    public static var xpBotUrl: String {
        get {
            return UserDefaults.standard.string(forKey: PrefsViewController.XP_BOT_URL_KEY) ?? ""
        }
    }
    
    private static var xpBotAuthenticationValue: String? = nil
    public static var xpBotAuthentication: String {
        get {
            if let value: String = xpBotAuthenticationValue {
                return value
            } else {
                let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                            kSecAttrAccount as String: PrefsViewController.XP_BOT_AUTHENTICATION_KEY,
                                            kSecMatchLimit as String: kSecMatchLimitOne,
                                            kSecReturnData as String: kCFBooleanTrue!]
            
                var retrivedData: AnyObject? = nil
                let _ = SecItemCopyMatching(query as CFDictionary, &retrivedData)
                guard let data = retrivedData as? Data else { return "" }
                
                let value = String(data: data, encoding: String.Encoding.utf8)!
                xpBotAuthenticationValue = value
                return value
            }
        }
        
        set {
            xpBotAuthenticationValue = newValue
            let password = newValue.data(using: String.Encoding.utf8)!
            let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                           kSecAttrAccount as String: PrefsViewController.XP_BOT_AUTHENTICATION_KEY,
                                           kSecValueData as String: password]
            let status = SecItemAdd(query as CFDictionary, nil)
            guard status == errSecSuccess else { return print("save error") }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        zoomToggleButtonCell.integerValue = PrefsViewController.zoomToggle ? 1 : 0
        meetingIdTextField.stringValue = PrefsViewController.meetingId
        standupTimeDatePicker.dateValue = DateComponents.init(
            calendar: Calendar.current,
            hour: PrefsViewController.standupTimeHour,
            minute: PrefsViewController.standupTimeMinute)
            .date!
        xpBotUrlTextField.stringValue = PrefsViewController.xpBotUrl
        xpBotAuthenticationTextField.stringValue = PrefsViewController.xpBotAuthentication
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func zoomToggleValueChanged(_ sender: NSButtonCell) {
        UserDefaults.standard.set(sender.integerValue, forKey: PrefsViewController.ZOOM_TOGGLE_KEY)
    }
    
    @IBAction func meetingIdValueChanged(_ sender: NSTextField) {
        UserDefaults.standard.set(sender.stringValue, forKey: PrefsViewController.MEETING_ID_KEY)
    }
    
    @IBAction func standupTimeChanged(_ sender: NSDatePicker) {
        UserDefaults.standard.set(Calendar.current.component(.hour, from: sender.dateValue), forKey: PrefsViewController.STANDUP_TIME_HOUR_KEY)
        UserDefaults.standard.set(Calendar.current.component(.minute, from: sender.dateValue), forKey: PrefsViewController.STANDUP_TIME_MINUTE_KEY)
    }
    
    @IBAction func xpBotUrlChanged(_ sender: NSTextField) {
        UserDefaults.standard.set(sender.stringValue, forKey: PrefsViewController.XP_BOT_URL_KEY)
    }
    
    @IBAction func xpBotAuthenticationChanged(_ sender: NSSecureTextField) {
        PrefsViewController.xpBotAuthentication = sender.stringValue
    }
   
}
