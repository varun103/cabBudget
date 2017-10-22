//
//  LyftModels.swift
//  cabBudget
//
//  Created by Varun Ajmera on 9/26/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.
//
import Foundation

/// Oauth Token Model
struct LyftOAuthToken : OAuthToken {
    let accessToken : String?
    let refreshToken: String?
    let tokenType   : String?
    let expiration  : Int?
    let scope       : String?
    
    /// Time (in seconds) when the access token expires
    let expirationTime : Double?
}

extension LyftOAuthToken {
    
    init?(json:[String:Any]) {
        guard let accessToken = json["access_token"] as? String,
            let refreshToken = json["refresh_token"] as? String,
            let tokenType = json["token_type"] as? String,
            let expiration = json["expires_in"] as? Int,
            let scope = json["scope"] as? String
            else {
                return nil
        }
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expiration = expiration
        self.scope = scope
        self.refreshToken = refreshToken
        self.expirationTime = getCurrentTime() + Double(expiration)
    }
    
    init?(json:[String:Any], refreshToken:String) {
        
        guard let accessToken = json["access_token"] as? String,
            let tokenType = json["token_type"] as? String,
            let expiration = json["expires_in"] as? Int,
            let scope = json["scope"] as? String
            else {
                return nil
        }
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expiration = expiration
        self.scope = scope
        self.refreshToken = refreshToken
        self.expirationTime = getCurrentTime() + Double(expiration)
    }
    
    init() {
        self.accessToken=""
        self.refreshToken=""
        self.expiration=0
        self.scope=""
        self.tokenType=""
        self.expirationTime=0
    }
}

enum RideStatus: String {
    case PENDING = "pending"
    case ACCEPTED = "accepted"
    case ARRIVED = "arrived"
    case PICKEDUP = "pickedUp"
    case DROPPEDOFF = "droppedOff"
    case CANCELED = "canceled"
    case UNKNOWN = "unknown"
}

/// Type of lyft ride
enum RideType: String {
    case LYFT = "lyft"
    case LYFTLINE = "lyft_line"
    case LYFTPLUS = "lyft_plus"
}

struct Price {
    let amount: Int
    let currency: String
    let description: String
}

extension Price {
    init?(json:[String:Any]) {
        guard let amount = json["amount"] as? Int,
            let currency = json["currency"] as? String,
            let description = json["description"] as? String
            else {
                return nil
        }
        self.amount = amount
        self.currency = currency
        self.description = description
    }
}

struct Pickup {
    let lat: Double
    let long: Double
    let address: String
    let time : String
}

extension Pickup {
    init?(json:[String:Any]) {
        guard let lat = json["lat"] as? Double,
            let long = json["lng"] as? Double,
            let address = json["address"] as? String,
            let time = json["time"] as? String
            else {
                return nil
        }
        self.lat = lat
        self.long = long
        self.address = address
        self.time = time
    }
}


struct Dropoff {
    let lat: Double
    let long: Double
    let address: String
    let time : String
}

extension Dropoff {
    init?(json:[String:Any]) {
        guard let lat = json["lat"] as? Double,
            let long = json["lng"] as? Double,
            let address = json["address"] as? String,
            let time = json["time"] as? String
            else {
                return nil
        }
        self.lat = lat
        self.long = long
        self.address = address
        self.time = time
    }
}

struct Address {
    let lat: Double
    let lng: Double
    let address: String?
}

extension Address {
    init?(json:[String:Any]) {
        guard let lat = json["lat"] as? Double,
            let long = json["lng"] as? Double
            else {
                return nil
        }
       
        self.lat = lat
        self.lng = long
        
        // Address can be null
        self.address = json["address"] as? String ?? nil
    }
}


/// Ride History
struct Rides {
    
    let rideId: String
    let status: String
    let rideType: String
    let price: Price
    let pickup: Pickup?
    let dropoff: Dropoff?
    let origin: Address
    let destination: Address
    let requestedTime: String
}

extension Rides {
    
    init?(json:[String:Any]) {
        guard let rideId = json["ride_id"] as? String,
            let status = json["status"] as? String,
            let rideType = json["ride_type"] as? String,
            let price = Price(json: (json["price"] as? [String:Any])!),
            let origin = Address(json:(json["origin"] as? [String:Any])!),
            let destination = Address(json:(json["destination"] as? [String:Any])!),
            let requestedTime = json["requested_at"] as? String
            else {
                return nil
        }
        // Cancelled rides do not have a pickup
        var pickup: Pickup?
        if let _pickup = json["pickup"] as? [String:Any] {
            pickup = Pickup(json: _pickup)
        }
        // Cancelled rides do not have a drop-off
        var dropoff: Dropoff?
        if let _dropoff = json["dropoff"] as? [String:Any] {
            dropoff = Dropoff(json: _dropoff)
        }
        self.rideId = rideId
        self.status = status
        self.rideType = rideType
        self.price = price
        self.pickup = pickup
        self.dropoff = dropoff
        self.origin = origin
        self.destination = destination
        self.requestedTime = requestedTime
    }
}


struct Profile : UserProfile {
    var id: String?
    var firstName: String?
    var lastName: String?
    let hasRidden: Bool?
}

extension Profile {
    init?(json:[String:Any]) {
        guard let id = json["id"] as? String,
            let firstName = json["first_name"] as? String,
            let lastName = json["last_name"] as? String,
            let hasRidden = json["has_taken_a_ride"] as? Bool
            else {
                return nil
    }
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.hasRidden = hasRidden
    }
    
    init(id:String, firstName: String, lastName:String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.hasRidden = false
    }
}
