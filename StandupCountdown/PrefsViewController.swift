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
    
    private static let ZOOM_TOGGLE_KEY = "ZoomToggle"
    private static let MEETING_ID_KEY = "MeetingId"
    
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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        zoomToggleButtonCell.integerValue = PrefsViewController.zoomToggle ? 1 : 0
        meetingIdTextField.stringValue = PrefsViewController.meetingId
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
   
}
