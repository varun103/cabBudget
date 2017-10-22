//
//  LocationTimeZone.swift
//  cabBudget
//
//  Created by Varun Ajmera on 10/7/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.
//

import Foundation
import CoreLocation

///Time information for a location
class LocationTime {
    
    let latitude : Double
    let longitude : Double
    let location : CLLocation
    let clGeocoder : CLGeocoder
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.location = CLLocation(latitude: self.latitude, longitude: self.longitude)
        self.clGeocoder = CLGeocoder()
    }
    
    /// Returns time zone of the location
    ///
    /// - Parameter completion: completion handler
    func timeZone(completion: @escaping (TimeZone) -> Void) {
        self.clGeocoder.reverseGeocodeLocation(self.location) { clPlacemarks, error in
            if let _placemarks = clPlacemarks {
                completion(_placemarks[0].timeZone!)
            } else {
                completion(TimeZone.current)
            }
        }
    }
}
