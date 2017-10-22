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
    
    func timeZoneforLocation(lat:Double, lng:Double) -> TimeZone

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

public func convertUTCToTimezone(dateUTC: Date, timeZone: TimeZone) -> Date {
    
    return Date()
}

public func dateFromString(dateString: String) -> Date {
    let df = DateFormatter()
    //df.locale = Locale(identifier: "en_US_POSIX")
    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
//    df.timeZone = TimeZone(secondsFromGMT: 0)
    df.timeZone = TimeZone(abbreviation: "EST")
    var date = df.date(from: dateString)
   // df.timeZone = TimeZone.current
    var calender = Calendar.current
    calender.timeZone = TimeZone(abbreviation: "EST")!
    print("date ",  calender.component(.hour, from: date!))
    return date!
}


public func date() {
    var calendar = Calendar.current
    
   // calendar.component([], from: Date)
}

