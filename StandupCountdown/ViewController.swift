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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initCountdown()
        initGongReminder()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    private func initCountdown() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in
            if #available(OSX 10.12, *) {
                let duration = DateInterval(start: Date(), end: Date.next(hour: 8, minute: 6)).duration
                let totalSeconds = Int(duration.description.split(separator: ".")[0])!
                let seconds = String(totalSeconds % 60)
                let minutes = String(totalSeconds / 60 % 60)
                let hours = String(totalSeconds / 60 / 60)
                
                self.countdownTextField?.stringValue = "\(hours.pad()):\(minutes.pad()):\(seconds.pad())"
                
                self.gongStackView.isHidden = true
                self.timerStackView.isHidden = false
            }
        })
    }
    
    private func initGongReminder() {
        let timer = Timer.init(fire: Date.next(hour: 8, minute: 6),
                       interval: 60 * 60 * 24,
                       repeats: true,
                       block: {_ in
                        self.countdownTimer.pause(seconds: 15, resume: self.initCountdown)
                        self.gongStackView.isHidden = false
                        self.timerStackView.isHidden = true
                        NSSpeechSynthesizer().startSpeaking("Hit the gong!")
        })
        RunLoop.current.add(timer, forMode: .default)
    }
}
