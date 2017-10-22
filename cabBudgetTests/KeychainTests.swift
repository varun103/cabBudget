//
//  KeychainTests.swift
//  cabBudget
//
//  Created by Varun Ajmera on 9/28/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.
//

import XCTest
@testable import cabBudget

class KeychainTests: XCTestCase {
    
    let oauth = LyftOAuthToken(accessToken: "ccess", refreshToken: "refresh", tokenType: "test", expiration: 20, scope: "scope", expirationTime:200)
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSave() throws {
        let key = LyftKeychainKey(name:"test", oauthToken: oauth, userId:"abc")
        try key.saveInKeychain()

        var getKey = LyftKeychainKey(name:"test", oauthToken: LyftOAuthToken())
        try getKey.fetchFromKeychain()
        XCTAssertEqual("refresh", getKey.refreshToken)
        XCTAssertEqual("ccess", getKey.accessToken)
        XCTAssertEqual("abc", getKey.user)
        try getKey.removeFromKeychain()
    }
}
