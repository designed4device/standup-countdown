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
    
    func isWeekday() -> Bool {
        let day = Calendar.current.component(.weekday, from: self)
        return (day != 1 && day != 7)
    }
    
    static func next(after: Date, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date {
        var i: Double = 0
        while true {
            let next = DateComponents(
                calendar: Calendar.current,
                year: Calendar.current.component(.year, from: after.plus(days: i)),
                month: Calendar.current.component(.month, from: after.plus(days: i)),
                day: Calendar.current.component(.day, from: after.plus(days: i)),
                hour: hour,
                minute: minute,
                second: second)
                .date!
            if (next > after && next.isWeekday()) { return next }
            i += 1
        }
    }
}
