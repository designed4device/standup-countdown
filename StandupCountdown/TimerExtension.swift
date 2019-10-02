//
//  TimerExtension.swift
//  StandupCountdown
//
//  Created by Mike Wellen on 7/16/19.
//  Copyright © 2019 Mike Wellen. All rights reserved.
//

import Foundation

extension Timer {
    func pause(seconds: Double = 0, minutes: Double = 0, resume:@escaping () -> Void) {
        if (self.isValid) {
            self.invalidate()
            let timer = Timer(timeInterval: (seconds + (minutes * 60)), repeats: false, block: { timer in
                resume()
            })
            RunLoop.current.add(timer, forMode: .default)
        }
    }
}
