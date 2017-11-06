//
//  Util.swift
//  cabBudget
//
//  Created by Varun Ajmera on 9/30/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.
//

import Foundation
import CoreLocation

/// Helper for dates
protocol DateHelper {

    /// Current Month Integer value eg: 10
    var currentMonth: Int? {get}
    
    /// Current Month String value eg: October
    var currentMonthName: String? {get}
    
    /// Current Year Int value  e.g 2017
    var currentYear: Int? {get}
}

extension DateHelper {
    
    /// Date for the 1st minute of the 1st hour of the
    /// 1st day of the month and year provided
    static func getBeginningOf(month:Int, year: Int) -> Date? {
        return Calendar.current.date(from:
            DateComponents(timeZone: TimeZone.current, year: year, month: month, day: 1))
    }
    
    /// Returns String for the date provided
    /// Returned String format will be "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    static func dateString(from date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return df.string(from: date)
    }

    /// Returns a date obj for provided String
    /// String format should be "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    /// else will return null
    static func date(from dateString: String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return df.date(from: dateString)
    }
    
}

class DateHelperImpl : DateHelper {
    
    private let date: Date
    private let dateComponents: DateComponents
    private var calendar: Calendar
    
    init() {
        date = Date()
        calendar = Calendar.current
        dateComponents = self.calendar.dateComponents([.minute,.hour,.day,.month,.year], from: date)
    }
    
    var currentMonth: Int? {
        return self.dateComponents.month
    }
    
    var currentMonthName: String? {
        if let _cm = self.currentMonth {
            return calendar.monthSymbols[_cm - 1]
        }
        return nil
    }
    
    var currentYear: Int? {
        return dateComponents.year
    }
    
}

/// Returns the current time in seconds
public func getCurrentTime() -> Double {
    return Date().timeIntervalSince1970
}

public func timezones(lat: Double, long: Double, completion: @escaping (TimeZone?) -> Void) {
    let location = CLLocation(latitude:lat, longitude: long)
    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(location) { placemark, error in
        completion(placemark?[0].timeZone)
    }
}
