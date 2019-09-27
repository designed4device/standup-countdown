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
    
    private static let ZOOM_TOGGLE_KEY = "ZoomToggle"
    private static let MEETING_ID_KEY = "MeetingId"
    private static let STANDUP_TIME_HOUR_KEY = "StandupTimeHour"
    private static let STANDUP_TIME_MINUTE_KEY = "StandupTimeMinute"
    
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
   
}
