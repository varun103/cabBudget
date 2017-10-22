//
//  UtilTest.swift
//  cabBudgetTests
//
//  Created by Varun Ajmera on 9/30/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.
//

import XCTest
@testable import cabBudget

class UtilTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDate() {
        let dateString = "2015-09-24T23:27:25+00:00"
        let date = dateFromString(dateString: dateString)
        XCTAssertNotNil(date)
    }
    
    func testExample() {
        let x = expectation(description: "test")
        timezones(lat:20.5937, long:78.9629) { timezone in
            
            print(timezone?.abbreviation() ?? "Not Found")
            
        }
    }
}
