//
//  LyftModelsTests.swift
//  cabBudget
//
//  Created by Varun Ajmera on 9/26/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.
//

import XCTest
@testable import cabBudget

class LyftModelsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAccessToken() {
        
        let jsonString:[String:Any] = ["access_token": "access",
                                       "refresh_token" : "refresh",
                                 "token_type":"token",
                                 "expires_in" : 3212,
                                 "scope" : "scopes"]
        
        let ac:OAuthToken = LyftOAuthToken(json: jsonString)!
        XCTAssertEqual("access", ac.accessToken)
        XCTAssertEqual(3212, ac.expiration)
    }
    
    func testNegativeAccessToken() {
        
        let jsonString:[String:Any] = ["acces_token": "access",
                                       "token_type":"token",
                                       "expires_in" : 3212,
                                       "scope" : "scopes"]
        
        let ac:OAuthToken? = LyftOAuthToken(json: jsonString)
        XCTAssertEqual(nil, ac?.accessToken)
    }
    
    func testRideHistory() {
        let jsonString:[String:Any] = [  "ride_id": "123456789",
                                         "status": "droppedOff",
                                         "ride_type": "lyft",
                                         "passenger": [
                                            "first_name": "Jane",
                                            "phone_number": "+15554445000"],
                                         "driver": [
                                            "first_name": "Joe",
                                            "phone_number": "+15554445000",
                                            "rating": "4.9",
                                            "image_url": "http://example.com/lyft.png"],
                                         "vehicle": [
                                            "make": "Audi",
                                            "model": "A4",
                                            "license_plate": "AAAAAAA",
                                            "color": "black",
                                            "image_url": "http://example.com/lyft.png"],
                                         "origin": [
                                            "lat": 36.9442175,
                                            "lng": -123.8679133,
                                            "address": "123 Main St, Anytown, CA",
                                            "eta_seconds": "null"],
                                         "destination": [
                                            "lat": 36.9442175,
                                            "lng": -123.8679133,
                                            "address": "123 Main St, Anytown, CA",
                                            "eta_seconds": "null"],
                                         "pickup": [
                                            "lat": 36.9442175,
                                            "lng": -123.8679133,
                                            "address": "123 Main St, Anytown, CA",
                                            "time": "2015-09-24T23:27:25+00:00"],
                                         "dropoff": [
                                            "lat": 36.9442175,
                                            "lng": -123.8679133,
                                            "address": "123 Main St, Anytown, CA",
                                            "time": "2015-09-24T23:28:32+00:00"],
                                         "location": [
                                            "lat": 36.9442175,
                                            "lng": -123.8679133,
                                            "address": "123 Main St, Anytown, CA"],
                                         "primetime_percentage": "50%",
                                         "price": [
                                            "amount": 905,
                                            "currency": "USD",
                                            "description": "Total ride price"],
                                         "eta_seconds": 200,
                                         "requested_at": "2017-01-24T23:26:25+00:00"]
        let ac:Rides? = Rides(json: jsonString)
        XCTAssertEqual("lyft", ac?.rideType)
        XCTAssertEqual(36.9442175, ac?.pickup?.lat)
        XCTAssertEqual(-123.8679133, ac?.pickup?.long)

    }
}
