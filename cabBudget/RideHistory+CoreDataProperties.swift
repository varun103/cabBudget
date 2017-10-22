//
//  RideHistory+CoreDataProperties.swift
//  
//
//  Created by Varun Ajmera on 10/9/17.
//
//

import Foundation
import CoreData


extension RideHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RideHistory> {
        return NSFetchRequest<RideHistory>(entityName: "RideHistory")
    }

    @NSManaged public var price: Int32
    @NSManaged public var currency: String?
    @NSManaged public var pickupTime: NSDate?
    @NSManaged public var dropoff: String?
    @NSManaged public var id: UUID?
    @NSManaged public var pickupLat: Double
    @NSManaged public var status: String?
    @NSManaged public var userId: String?
    @NSManaged public var rideType: String?
    @NSManaged public var pickupLng: Double
    @NSManaged public var pickupAdd: String?
    @NSManaged public var dropoffLat: Double
    @NSManaged public var dropoffLng: Double
    @NSManaged public var dropoffAdd: String?
    @NSManaged public var dropoffTime: NSDate?
    @NSManaged public var timeZone: String?

}
