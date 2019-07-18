//
//  AppDelegate.swift
//  StandupCountdown
//
//  Created by Mike Wellen on 7/16/19.
//  Copyright © 2019 Mike Wellen. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var application: NSApplication!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        //hide the application after standup starts
        let hideTimer = Timer(
            fire: Date.next(hour: 8, minute: 6, second: 10),
            interval: 60 * 60 * 24,
            repeats: true,
            block: {_ in
                self.application.hide(self)
            }
        )
        
        //unhide the application after standup ends
        let unhideTimer = Timer(
            fire: Date.next(hour: 8, minute: 16),
            interval: 60 * 60 * 24,
            repeats: true,
            block: {_ in
                self.application.unhide(self)
                self.application.activate(ignoringOtherApps: true)
            }
        )

        //bring application to front before standup starts
        let activateTimer = Timer(
            fire: Date.next(hour: 8),
            interval: 60 * 60 * 24,
            repeats: true,
            block: {_ in
                self.application.activate(ignoringOtherApps: true)
            }
        )
        
        RunLoop.current.add(hideTimer, forMode: .default)
        RunLoop.current.add(unhideTimer, forMode: .default)
        RunLoop.current.add(activateTimer, forMode: .default)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
