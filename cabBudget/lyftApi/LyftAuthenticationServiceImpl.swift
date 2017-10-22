//
//  LyftAuthenticationService.swift
//  cabBudget
//
//  Created by Varun Ajmera on 9/29/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.
//

import UIKit

let ACCOUNT_NAME = "lyft"

/// Deals with Authentication with Lyft
protocol LyftAuthenticationService {
    
    /// Fetch the access token
    /// It looks up ac in the keychain. If present ensures that its valid and returns it.
    /// If not present uses the refresh token to get a new access token
    /// If none of the above asks the user to re-authorize the app
    /// - Parameter completion:
    func fetchAccessToken(completion: @escaping(String) -> Void)

}

extension LyftAuthenticationService {
    
    /// Checks if the access token in the key chain key is valid.
    ///
    /// - Parameter lyftKeychainKey:
    /// - Returns: true if valid/ false otherwise
    static func accessTokenValid(usersAuthInfo: UserAuthInfo) -> Bool {
        let accessTokenExpirationTime = usersAuthInfo.expirationTime ?? 0
        return getCurrentTime() < Double(accessTokenExpirationTime)
    }

    
    /// Redirects the user to get their authorization.
    /// Once authenticated
    static func redirectUserForAuthorization() {
        var parameters:[String:String] = [:]
        let authorizationRequest = "https://api.lyft.com/oauth/authorize"
        
        parameters["client_id"] = LyftOAuthConfig.clientId
        parameters["scope"] = "profile rides.read offline"
        parameters["state"] = "temp"
        parameters["response_type"] = "code"
        
        let urlString = addQueryParams(url: authorizationRequest, parameters: parameters)
        let url = URL(string: urlString)
        
        UIApplication.shared.open(url!)
    }
}

/// Handles authentication with Lyft
class LyftAuthenticationServiceImpl: LyftAuthenticationService {
    
    private var lyftApi:LyftAPIImpl
    
    init() {
        self.lyftApi = LyftAPIImpl()
    }
    
    /// Get the user's access token
    func fetchAccessToken(completion: @escaping(String) -> Void) {
        let oauthToken : UserAuthInfo? = UserAuthContextImp.get().lyftAuthInfo 
        if let key = oauthToken {
             // Check if access token is still valid
             // If valid then return access token else get refresh token
            if (LyftAuthenticationServiceImpl.accessTokenValid(usersAuthInfo: key)) {
                    completion(key.accessToken!)
                }
            else {
                self.lyftApi.getAccessTokenFromRefreshToken(refreshToken: key.refreshToken!) { lyftToken, error in
                    if let _token = lyftToken {
                        UserAuthContextImp.get().saveUserAuthToken(userId:key.user ?? "", oauthToken: _token)
                        print("Access token obtained using refresh token")
                        completion(_token.accessToken!)
                    } else {
                        print("Access token obtained using user's authorization")
                        DispatchQueue.main.async {
                            LyftAuthenticationServiceImpl.redirectUserForAuthorization()
                        }
                    }
                }
            }
        } else {
            print("Access token obtained using users AuthorizaTION")
            LyftAuthenticationServiceImpl.redirectUserForAuthorization()
        }
    }
    
}
