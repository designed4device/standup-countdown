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
    
    static func next(hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date {
        let now = Date()
        let today = DateComponents(
            calendar: Calendar.current,
            year: Calendar.current.component(.year, from: now),
            month: Calendar.current.component(.month, from: now),
            day: Calendar.current.component(.day, from: now),
            hour: hour,
            minute: minute,
            second: second)
            .date!
        
        return ((today > now) ? today : DateComponents(
            calendar: Calendar.current,
            year: Calendar.current.component(.year, from: now.plus(days: 1)),
            month: Calendar.current.component(.month, from: now.plus(days: 1)),
            day: Calendar.current.component(.day, from: now.plus(days: 1)),
            hour: hour,
            minute: minute,
            second: second)
            .date!)
    }
}
