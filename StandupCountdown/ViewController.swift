//
//  ViewController.swift
//  StandupCountdown
//
//  Created by Mike Wellen on 7/16/19.
//  Copyright © 2019 Mike Wellen. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var countdownTextField: NSTextField!
    @IBOutlet weak var timerStackView: NSStackView!
    @IBOutlet weak var gongStackView: NSStackView!
    @IBOutlet weak var hostsStackView: NSStackView!
    
    @IBOutlet weak var hostTextField: NSTextField!
    @IBOutlet weak var scribeTextField: NSTextField!
    @IBOutlet weak var backup1TextField: NSTextField!
    @IBOutlet weak var backup2TextField: NSTextField!
    
    
    private weak var countdownTimer:Timer!
    private var zoomStarted = false
    private var hostsSentToSlack = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hostsStackView.isHidden = true
        initCountdown()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    private func initCountdown() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in
            if #available(OSX 10.12, *) {
                let now = Date()
                let duration = DateInterval(start: now, end: Date.next(hour: PrefsViewController.standupTimeHour, minute: PrefsViewController.standupTimeMinute)).duration
                let totalSeconds = Int(duration.description.split(separator: ".")[0])!
                let seconds = String(totalSeconds % 60)
                let minutes = String(totalSeconds / 60 % 60)
                let hours = String(totalSeconds / 60 / 60)
                
                self.countdownTextField?.stringValue = "\(hours.pad()):\(minutes.pad()):\(seconds.pad())"
                self.gongStackView.isHidden = true
                self.timerStackView.isHidden = false
                
                if let host = HostsService.host?.name, let scribe = HostsService.scribe?.name, let backup1 = HostsService.backup1?.name, let backup2 = HostsService.backup2?.name {
                    self.hostTextField.stringValue = host
                    self.scribeTextField.stringValue = scribe
                    self.backup1TextField.stringValue = backup1
                    self.backup2TextField.stringValue = backup2
                    if (self.hostsStackView.isHidden) { self.hostsStackView.isHidden = false }
                } else {
                    if (!self.hostsStackView.isHidden) { self.hostsStackView.isHidden = true }
                    HostsService.INSTANCE.updateHosts()
                }
                
                //show gong reminder
                if (seconds == "0" && minutes == "0" && hours == "0") {
                    self.countdownTimer.pause(minutes: 10, resume: self.initCountdown)
                    _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.gongReminder), userInfo: nil, repeats: false)
                    self.zoomStarted = false
                    self.hostsSentToSlack = false
                    HostsService.INSTANCE.updateHosts()
                }
                
                if (!self.hostsSentToSlack && seconds == "0" && minutes == "11" && hours == "0" && now.isWeekday()) {
                        self.hostsSentToSlack = true
                        HostsService.INSTANCE.sendHostsToSlack()
                }
                
                if (PrefsViewController.zoomToggle && !self.zoomStarted && seconds == "0" && minutes == "6" && hours == "0") {
                        self.startMeeting()
                }
            }
        })
    }
    
    @objc private func gongReminder() {
        self.gongStackView.isHidden = false
        self.timerStackView.isHidden = true
        
        let synth = NSSpeechSynthesizer()
        synth.setVoice(NSSpeechSynthesizer.availableVoices.randomElement())
        synth.startSpeaking("Hit the gong!")
    }
    
    @objc private func startMeeting() {
        self.zoomStarted = true
         _ = "open /Applications/zoom.us.app".runAsCommand()
         _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: {_ in
            _ = "open \"zoommtg://zoom.us/start?zc=0&confno=\(PrefsViewController.meetingId)\""
                .runAsCommand()
        })
        _ = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: {_ in
            NSApp.activate(ignoringOtherApps: true)
            self.view.window?.makeKeyAndOrderFront(self)
        })
    }
}
