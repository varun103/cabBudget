//
//  File.swift
//  cabBudget
//
//  Created by Varun Ajmera on 10/7/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    
    let latitude : Double
    let longitude : Double
    let location : CLLocation
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.location = CLLocation(latitude:self.latitude, longitude: self.longitude)
    }
    
    /// Time zone of the location
    func timeZone(completion: @escaping (TimeZone?, Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(self.location) { clPlacemarks, errors in
            if let _placeMarks = clPlacemarks {
                if let _timeZone = _placeMarks[0].timeZone {
                    completion(_timeZone, nil)
                } else {
                    completion(nil, TimeZoneError.notFound)
                }
            } else {
                completion(nil,TimeZoneError.notFound)
            }
        }
    }
}
