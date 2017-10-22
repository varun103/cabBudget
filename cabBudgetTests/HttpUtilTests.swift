//
//  HttpUtilTests.swift
//  cabBudget
//
//  Created by Varun Ajmera on 9/19/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.
//

import XCTest
@testable import cabBudget

class HttpUtilTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let paramString = "code=03q53QHXXh0vf799&state=temp"
        let params = extractParams(paramString: paramString)
        
        XCTAssertEqual(2, params.count)
        //XCTAssertEqual(["count","state"], params.keys.forEach(){k in [].append(k)})
    }
    
}
