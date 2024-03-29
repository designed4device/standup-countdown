import XCTest
@testable import StandupCountdown

class DateExtensionTests: XCTestCase {
    
    func isWeekdayTest() {
        let saturday = DateComponents(calendar: Calendar.current, year: 2019, month: 10, day: 5).date!
        let sunday = DateComponents(calendar: Calendar.current, year: 2019, month: 10, day: 6).date!
        let monday = DateComponents(calendar: Calendar.current, year: 2019, month: 10, day: 7).date!
        let tuesday = DateComponents(calendar: Calendar.current, year: 2019, month: 10, day: 8).date!
        let wednesday = DateComponents(calendar: Calendar.current, year: 2019, month: 10, day: 9).date!
        let thursday = DateComponents(calendar: Calendar.current, year: 2019, month: 10, day: 10).date!
        let friday = DateComponents(calendar: Calendar.current, year: 2019, month: 10, day: 11).date!
        
        XCTAssertFalse(saturday.isWeekday())
        XCTAssertFalse(sunday.isWeekday())
        XCTAssertTrue(monday.isWeekday())
        XCTAssertTrue(tuesday.isWeekday())
        XCTAssertTrue(wednesday.isWeekday())
        XCTAssertTrue(thursday.isWeekday())
        XCTAssertTrue(friday.isWeekday())
    }
    
    func nextTest() {
        let friday = DateComponents(calendar: Calendar.current, year: 2019, month: 10, day: 4, hour: 9).date!
        let saturday = DateComponents(calendar: Calendar.current, year: 2019, month: 10, day: 5, hour: 9).date!
        let sunday = DateComponents(calendar: Calendar.current, year: 2019, month: 10, day: 6, hour: 9).date!
        
        XCTAssertTrue(Calendar.current.component(.day, from: Date.next(after: friday, hour: 10)) == 4)
        XCTAssertTrue(Calendar.current.component(.day, from: Date.next(after: friday, hour: 8)) == 7)
        XCTAssertTrue(Calendar.current.component(.day, from: Date.next(after: saturday, hour: 8)) == 7)
        XCTAssertTrue(Calendar.current.component(.day, from: Date.next(after: sunday, hour: 8)) == 7)
    }
}
