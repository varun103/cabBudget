//
//  AuthContext.swift
//  cabBudget
//
//  Created by Varun Ajmera on 10/12/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.

import Foundation

/// Access the users auth context
/// Intended to have once instance
protocol UserAuthContext {
    
    /// Users Lyft Auth context
    var lyftAuthInfo: UserAuthInfo? { get }
    
    /// Get User's Auth Context
    ///
    /// - Returns: UserAuthContext
    static func get() -> UserAuthContext
    
    /// Saves this Oauth Token in the Keychain
    ///
    /// - Parameters:
    ///   - userId: userId of the calling user
    ///   - oauthToken: oauth token
    func saveUserAuthToken(user: UserProfile, for app: ConnectedApp, oauthToken : OAuthToken)
    
    /// Saves this Oauth Token in the Keychain
    ///
    /// - Parameters:
    ///   - userId: userId of the calling user
    ///   - oauthToken: oauth token
    func saveUserAuthToken(user: UserProfile, oauthToken: OAuthToken)
    
    /// Removes the provided app's Oauth Token from the Keychain
    ///
    /// - Parameter app: The connected App
    func deleteUserAuthToken(for app: ConnectedApp)
    
    /// Removes the access token from the key chain
    func deleteUserAuthToken()
}


/// User's Authorization context
/// Meant to be a singleton
class UserAuthContextImp: UserAuthContext {
    
    private static let authContext: UserAuthContextImp = UserAuthContextImp()
    
    /// Users Lyft Auth context
    var lyftAuthInfo: UserAuthInfo?
    
    /// Singleton
    /// - Returns: an instance of the users authorization context
    static func get() -> UserAuthContext {
        return authContext
    }
    
    /// Reload the oauth tokens
    func refresh() -> Void {
        loadOauthToken()
    }
    
    func saveUserAuthToken(user: UserProfile, for app: ConnectedApp, oauthToken : OAuthToken) {
        let lyftKeyChainKey = KeychainKey(name: app.rawValue, oauthToken: oauthToken, user: user)
        do {
            try lyftKeyChainKey.saveInKeychain()
            print("Saved in keychain")
            loadOauthToken()
        } catch {}
    }
    
    /// Saves the access token
    func saveUserAuthToken(user: UserProfile, oauthToken: OAuthToken) {
        saveUserAuthToken(user: user, for: ConnectedApp.lyft, oauthToken: oauthToken)
    }
    
    func deleteUserAuthToken(for app: ConnectedApp) {
        var key = KeychainKey(name: app.rawValue, oauthToken: LyftOAuthToken())
        do { try key = key.fetchFromKeychain() } catch{ }
    }
    
    /// Removes the access token from the key chain
    func deleteUserAuthToken() {
        deleteUserAuthToken(for: .lyft)
    }
    
    private init() {
        loadOauthToken()
    }
    
    private func loadOauthToken() {
        var key = KeychainKey(name: ConnectedApp.lyft.rawValue, oauthToken: LyftOAuthToken())
        do {
            try key = key.fetchFromKeychain()
            self.lyftAuthInfo = key
        } catch {
            self.lyftAuthInfo = nil
        }
    }
}
