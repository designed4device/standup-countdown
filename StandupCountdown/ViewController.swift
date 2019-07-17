//
//  ViewController.swift
//  StandupCountdown
//
//  Created by Mike Wellen on 7/16/19.
//  Copyright © 2019 Mike Wellen. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var timerLabel: NSTextField!
    @IBOutlet weak var timerStackView: NSStackView!
    @IBOutlet weak var gongStackView: NSStackView!
    private weak var timer:Timer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initTimer()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    private func initTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateUI), userInfo: nil, repeats: true)
    }
    
    @objc private func updateUI() {
        let now = Date()
        let eightOhSix = DateComponents(
            calendar: Calendar.current,
            year: Calendar.current.component(.year, from: now),
            month: Calendar.current.component(.month, from: now),
            day: Calendar.current.component(.day, from: now),
            hour: 8,
            minute: 06)
            .date!
        
        if (now < eightOhSix) {
            updateTimerLabel(start: now, end: eightOhSix)
        } else if (now > eightOhSix.plus(seconds: 30)) {
            updateTimerLabel(start: now, end: eightOhSix.plus(days: 1))
        } else {
            timer.pause(seconds: 30, resume: initTimer)
            gongStackView.isHidden = false
            timerStackView.isHidden = true
            NSSpeechSynthesizer().startSpeaking("Hit the gong!")
        }
    }
    
    @objc private func updateTimerLabel(start: Date, end: Date) {
        if #available(OSX 10.12, *) {
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .none
            
            let duration = DateInterval(start: start, end: end).duration
            let totalSeconds = Int(duration.description.split(separator: ".")[0])!
            let seconds = String(totalSeconds % 60)
            let minutes = String(totalSeconds / 60 % 60)
            let hours = String(totalSeconds / 60 / 60)
            
            timerLabel?.stringValue = "\(hours.pad()):\(minutes.pad()):\(seconds.pad())"
            
            gongStackView.isHidden = true
            timerStackView.isHidden = false
        }
    }
}
