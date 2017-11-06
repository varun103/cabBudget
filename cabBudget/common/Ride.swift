//
//  RideHistory.swift
//  cabBudget
//
//  Created by Varun Ajmera on 10/21/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.
//

import UIKit
import CoreData

protocol RideEntity {
    
    /// Fetch ride for the given time period
    ///
    /// - Parameters:
    ///   - beginning: beginning time
    ///   - end: end time
    func fetchRidesFrom(beginning:Date, end:Date, context:NSManagedObjectContext) throws -> [Ride]
    
    /// Fetch Rides with the filter applied
    /// - Parameters:
    ///   - filter: Filter applied
    func fetchRides(filter:NSPredicate, context: NSManagedObjectContext) throws -> [Ride]
    
    /// If this ride exists then returns that ride else, creates a new one
    ///
    /// - Parameters:
    ///   - rides: Rides object
    ///   - context: NS Managed Object
    func findOrCreate(rides:Rides, context:NSManagedObjectContext) throws -> Ride
    
}

class Ride: NSManagedObject, RideEntity {
    
    func fetchRidesFrom(beginning:Date, end:Date, context:NSManagedObjectContext) throws -> [Ride] {
        let request: NSFetchRequest<Ride> = Ride.fetchRequest()
        request.predicate = NSPredicate(format: "requestedTime > %@ AND requestedTime < %@", beginning as NSDate, end as NSDate)
        do {
            let resultSet: [Ride] = try context.fetch(request)
            return resultSet
        } catch {
            throw DBError.couldNotSave
        }
    }
    
    func fetchRides(filter:NSPredicate, context: NSManagedObjectContext) throws -> [Ride] {
        let request: NSFetchRequest<Ride> = Ride.fetchRequest()
        request.predicate = filter
        do {
            let resultSet: [Ride] = try context.fetch(request)
            return resultSet
        } catch {
            throw DBError.couldNotSave
        }
    }
    
    func findOrCreate(rides:Rides, context:NSManagedObjectContext) throws -> Ride {
        
        let request: NSFetchRequest<Ride> = Ride.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", rides.rideId)
        do {
            let resultSet: [Ride] = try context.fetch(request)
            if resultSet.count > 1 {
                throw DBError.inconsistencyError
            } else if resultSet.count == 1 {
                return resultSet[0]
            }
        } catch {
            throw DBError.couldNotSave
        }
        let ride: Ride = Ride(context: context)
        ride.id = rides.rideId
        ride.currency = rides.price.currency
        ride.price = Int32(rides.price.amount)
        ride.status = rides.status
        ride.rideType = rides.rideType
        ride.requestedTime = DateHelperImpl.date(from: rides.requestedTime)
        
        // Origin
        ride.originLat = rides.origin.lat
        ride.originLng = rides.origin.lng
        ride.originAdd = rides.origin.address ?? ""
        
        // Destination
        ride.destLat = rides.destination.lat
        ride.destLng = rides.destination.lng
        ride.destAdd = rides.destination.address
        
        // Pickup
        if let pickup = rides.pickup {
            ride.pickupAdd = pickup.address
            ride.pickupLat = pickup.lat
            ride.pickupLng = pickup.long
            ride.pickupTime = DateHelperImpl.date(from: pickup.time)
        }
        
        // Dropoff
        if let dropoff = rides.dropoff {
            ride.dropoffLat = dropoff.lat
            ride.dropoffLng = dropoff.long
            ride.dropoffAdd = dropoff.address
            ride.dropoffTime = DateHelperImpl.date(from: dropoff.time)
        }
        return ride
    }
}
