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
    let _userId: String
    let _userFirstName: String
    let _userLastName: String
    
    var data = [String: Any]()
    
    var dataToStore: [String: Any] {
        var _data:[String:String] = [:]
        _data["accessToken"] = token.accessToken
        _data["refreshToken"] = token.refreshToken
        _data["expiration"] = String(token.expiration!)
        _data["expirationTime"] = String(token.expirationTime!)
        _data["scope"] = token.scope
        _data["tokenType"] = token.tokenType
        _data["userId"] = self._userId
        _data["userFirstName"] = self._userFirstName
        _data["userLastName"] = self._userLastName
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
    
    var userId: String? {
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
    
    var userFirstName: String? {
        return data["userFirstName"] as? String
    }
    
    var userLastName: String? {
        return data["userLastName"] as? String
    }
    
    public init(name: String, oauthToken: OAuthToken) {
        self.init(name:name, oauthToken:oauthToken, user: sampleUserProfile())
    }
    
    init(name: String, oauthToken: OAuthToken, user: UserProfile) {
        self.accountName = name
        self.token = oauthToken
        self._userId = user.id ?? ""
        self._userFirstName = user.firstName ?? ""
        self._userLastName = user.lastName ?? ""
    }
    
    private struct sampleUserProfile: UserProfile {
        var id: String? = "id"
        var firstName: String? = "name"
        var lastName: String? = "last"
    }
}
