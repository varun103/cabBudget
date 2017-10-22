//
//  LyftKey.swift
//  cabBudget
//
//  Created by Varun Ajmera on 9/28/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.
//

import Foundation

/// IOS Keychain Key holds the users oauth token
struct LyftKeychainKey: KeychainGenericPasswordType, UserAuthInfo {
    
    let accountName: String
    let token: OAuthToken
    let userId: String
    
    var data = [String: Any]()
    
    var dataToStore: [String: Any] {
        var _data:[String:String] = [:]
        _data["accessToken"] = token.accessToken
        _data["refreshToken"] = token.refreshToken
        _data["expiration"] = String(token.expiration!)
        _data["expirationTime"] = String(token.expirationTime!)
        _data["scope"] = token.scope
        _data["tokenType"] = token.tokenType
        _data["userId"] = self.userId
        return _data
    }
    
    var expirationTime: Double? {
        let _expirationTime = data["expirationTime"] as? String
        if let x = _expirationTime {
            return Double(x)
        } else {return nil}
    }
    
    var refreshToken:String? {
        return data["refreshToken"] as? String
    }
    
    var accessToken: String? {
        return data["accessToken"] as? String
    }
    
    var user: String? {
        return data["userId"] as? String
    }
    
    var scope: String? {
        return data["scope"] as? String
    }
    
    var tokenType: String? {
        return data["tokenType"] as? String
    }
    
    var expiration: Int? {
        let _expiration = data["expiration"] as? String
        if let x = _expiration {
            return Int(x)
        } else {return nil}
    }
    
    public init(name: String, oauthToken: OAuthToken) {
        self.init(name:name, oauthToken:oauthToken, userId:"")
    }
    
    init(name: String, oauthToken: OAuthToken, userId: String) {
        self.accountName = name
        self.token = oauthToken
        self.userId = userId
    }
}
