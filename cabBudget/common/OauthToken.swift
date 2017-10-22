//
//  OauthToken.swift
//  cabBudget
//
//  Created by Varun Ajmera on 10/17/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.
//

import Foundation


/// Oauth token for an app 
protocol OAuthToken {
    
    /// Access Token
    var accessToken : String? {get}
    
    /// Refresh Token
    var refreshToken: String? {get}
    
    /// Token Type
    var tokenType   : String? {get}
    
    /// Token expiration
    var expiration  : Int?   {get}
    
    /// Oauth Scope
    var scope       : String? {get}
    
    /// Time (in seconds) when the access token expires
    var expirationTime : Double? {get}
}

protocol UserAuthInfo: OAuthToken {
    
    /// UserId
    var user : String? { get }
    
}
