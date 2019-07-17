//
//  DateExtension.swift
//  StandupCountdown
//
//  Created by Mike Wellen on 7/16/19.
//  Copyright © 2019 Mike Wellen. All rights reserved.
//

import Foundation

extension Date {
    func plus(seconds: Double = 0, days: Double = 0) -> Date {
        return self.addingTimeInterval(
            seconds
            + (days * 24 * 60 * 60)
        )
    }
}
