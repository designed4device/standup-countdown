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
    
    private weak var countdownTimer:Timer!
    private var zoomStarted = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
                let duration = DateInterval(start: Date(), end: Date.next(hour: PrefsViewController.standupTimeHour, minute: PrefsViewController.standupTimeMinute)).duration
                let totalSeconds = Int(duration.description.split(separator: ".")[0])!
                let seconds = String(totalSeconds % 60)
                let minutes = String(totalSeconds / 60 % 60)
                let hours = String(totalSeconds / 60 / 60)
                
                self.countdownTextField?.stringValue = "\(hours.pad()):\(minutes.pad()):\(seconds.pad())"
                self.gongStackView.isHidden = true
                self.timerStackView.isHidden = false
                
                if (seconds == "0" && minutes == "0" && hours == "0") {
                    self.countdownTimer.pause(seconds: 10, resume: self.initCountdown)
                    _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.gongReminder), userInfo: nil, repeats: false)
                    self.zoomStarted = false
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
            _ = "open \"zoommtg://zoom.us/join?action=join&confno=\(PrefsViewController.meetingId)\""
                .runAsCommand()
        })
        _ = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: {_ in
            NSApp.activate(ignoringOtherApps: true)
            self.view.window?.makeKeyAndOrderFront(self)
        })
    }
}
