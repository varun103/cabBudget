//
//  AuthContext.swift
//  cabBudget
//
//  Created by Varun Ajmera on 10/12/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.

import Foundation

/// Access the users auth context
protocol UserAuthContext {
    
    /// Users Lyft Auth context
    var lyftAuthInfo: UserAuthInfo? { get }
    
    /// Get User's Auth Context
    ///
    /// - Returns: UserAuthContext
    static func get() -> UserAuthContext
    
    /// Saves this Oauth Token in the Key Chain
    ///
    /// - Parameters:
    ///   - userId: userId of the calling user
    ///   - oauthToken: oauth token
    func saveUserAuthToken(user: UserProfile, oauthToken: OAuthToken)
    
    /// Removes the access token from the key chain
    func deleteUserAuthToken()
}


/// User's Authorization context
class UserAuthContextImp: UserAuthContext {
    
    private static let authContext: UserAuthContextImp = UserAuthContextImp()
    
    /// Users Lyft Auth context
    var lyftAuthInfo: UserAuthInfo?
    
    /// Singleton
    ///
    /// - Returns: an instance of the users authorization context
    static func get() -> UserAuthContext {
        return authContext
    }
    
    /// Reload the oauth tokens
    func refresh() -> Void {
        loadOauthToken()
    }
    
    /// Saves the access token
    func saveUserAuthToken(user: UserProfile, oauthToken: OAuthToken) {
        let lyftKeyChainKey = LyftKeychainKey(name: ACCOUNT_NAME, oauthToken: oauthToken, user: user)
        do {
            try lyftKeyChainKey.saveInKeychain()
            print("Saved in keychain")
            loadOauthToken()
        } catch {}
    }
    
    /// Removes the access token from the key chain
    func deleteUserAuthToken() {
        var key = LyftKeychainKey(name: ACCOUNT_NAME, oauthToken: LyftOAuthToken())
        do {
            try key.fetchFromKeychain()
        }catch{}
    }
    
    private init() {
        loadOauthToken()
    }
    
    private func loadOauthToken() {
        var key = LyftKeychainKey(name: ACCOUNT_NAME, oauthToken: LyftOAuthToken())
        do {
            try key.fetchFromKeychain()
            self.lyftAuthInfo = key
        } catch {
            self.lyftAuthInfo = nil
        }
    }
}
