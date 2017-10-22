//
//  RideHistory.swift
//  cabBudget
//
//  Created by Varun Ajmera on 10/21/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.
//

import UIKit
import CoreData

class Ride: NSManagedObject {

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - rides: <#rides description#>
    ///   - context: <#context description#>
    /// - Returns: <#return value description#>
    /// - Throws: <#throws value description#>
    func findOrCreate(rides:Rides, context:NSManagedObjectContext) throws -> Ride  {
        
        let request: NSFetchRequest<Ride> = Ride.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", rides.rideId)
        do {
            let resultSet: [Ride] = try context.fetch(request)
            if resultSet.count > 1 {
                
            } else if resultSet.count == 1 {
                print ("Ride FOUND")
                return resultSet[0]
            }
        } catch {
            throw DBError.couldNotSave
        }
        print("Ride Not Found")
        let ride: Ride = Ride(context: context)
        ride.id = rides.rideId
        ride.currency = rides.price.currency
        ride.price = Int32(rides.price.amount)
        ride.status = rides.status
        ride.rideType = rides.rideType
        ride.requestedTime = DateHelperImpl.date(from: rides.requestedTime)
        
        //origin
        ride.originLat = rides.origin.lat
        ride.originLng = rides.origin.lng
        ride.originAdd = rides.origin.address ?? ""
        
        //destination
        ride.destLat = rides.destination.lat
        ride.destLng = rides.destination.lng
        ride.destAdd = rides.destination.address
        
        //pickup
        if let pickup = rides.pickup {
            ride.pickupAdd = pickup.address
            ride.pickupLat = pickup.lat
            ride.pickupLng = pickup.long
            ride.pickupTime = DateHelperImpl.date(from: pickup.time)
        }
        
        //dropoff
        if let dropoff = rides.dropoff {
            ride.dropoffLat = dropoff.lat
            ride.dropoffLng = dropoff.long
            ride.dropoffAdd = dropoff.address
            ride.dropoffTime = DateHelperImpl.date(from: dropoff.time)
        }
        
        return ride
    }
}
