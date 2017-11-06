//
//  LyftAuthenticationServiceTest.swift
//  cabBudgetTests
//
//  Created by Varun Ajmera on 10/1/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.
//

import XCTest
@testable import cabBudget

class LyftAuthenticationServiceTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAccessTokenExpirationGreater() throws{
        let timePlusthirtySeconds = getCurrentTime() + 30.0
        var lyftKeychainKey = KeychainKey(name: "lyft", oauthToken: LyftOAuthToken(accessToken: "accessToken", refreshToken: "refreshToken", tokenType: "abc", expiration: 20, scope: "xyz", expirationTime: timePlusthirtySeconds))
        try lyftKeychainKey.saveInKeychain()
        try lyftKeychainKey.fetchFromKeychain()
        XCTAssertTrue(MockTest.accessTokenValid(usersAuthInfo: lyftKeychainKey))
        try lyftKeychainKey.removeFromKeychain()
    }
    
    func testAccessTokenExpirationLess() throws{
        let timePlusthirtySeconds = getCurrentTime() - 30.0
        var lyftKeychainKey = KeychainKey(name: "lyft", oauthToken: LyftOAuthToken(accessToken: "accessToken", refreshToken: "refreshToken", tokenType: "abc", expiration: 20, scope: "xyz", expirationTime: timePlusthirtySeconds))
        try lyftKeychainKey.saveInKeychain()
        try lyftKeychainKey.fetchFromKeychain()
        XCTAssertFalse(MockTest.accessTokenValid(usersAuthInfo: lyftKeychainKey))
        try lyftKeychainKey.removeFromKeychain()
    }
    
}

class MockTest: LyftAuthenticationService {
    
    func fetchAccessToken(completion: @escaping (String) -> Void) {
    }
}
