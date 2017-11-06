//
//  LyftApi.swift
//  cabBudget
//
//  Created by Varun Ajmera on 9/20/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.
//

import Foundation

/// Wrapper around lyft's Rest API
protocol LyftAPI {
    
    /// GET a new access token using the refresh token provided
    func getAccessTokenFromRefreshToken(refreshToken:String, completion: @escaping (LyftOAuthToken?, HttpError?) -> Void)
    
    /// GET a new access token using the authorization code
    func getAccessTokenFromAuthorizationCode(authorizationCode:String, completion: @escaping (LyftOAuthToken?, String) -> Void)
    
    /// GET the access token
    func getAccessToken(grant: Grant, code:String, completion: @escaping (HttpResponse?, HttpError?) -> Void)
    
    /// Get the ride history for the authorized user for the specified time period
    func rideHistory(startTime: String, accessToken: String, completion: @escaping ([Rides]?, HttpError?) -> Void)
    
    /// Get the ride history for the authorized user starting from
    func rideHistory(startTime: String, endTime:String?, accessToken: String, completion: @escaping ([Rides]?, HttpError?) -> Void)
    
    /// GET the ride history for the authorized user
    func rideHistory(accessToken: String, completion: @escaping ([Rides]?, HttpError?) -> Void)
    
    /// GET the user's profile
    func userProfile(accessToken: String, completion: @escaping (Profile?,HttpError?) -> Void)
}

/// Grant type needed for access token
struct Grant {
    let type: String
    let code: String
    
    static let AuthorizationCode = Grant(type:"authorization_code", code:"code")
    static let RefreshToken = Grant(type:"refresh_token", code:"refresh_token")
    
    private init(type: String, code: String) {
        self.type = type
        self.code = code
    }
}

/// Lyft Api
class LyftAPIImpl: LyftAPI {
    
    var httpClient: HttpClient
    
    init() {
        self.httpClient = HttpClientImpl()
    }
    
    /// Get the access token using the refrest token
    func getAccessTokenFromRefreshToken(refreshToken:String, completion: @escaping (LyftOAuthToken?, HttpError?) -> Void) {
        self.getAccessToken(grant: Grant.RefreshToken, code: refreshToken) { httpResponse, error in
            if (error != nil) {
                completion(nil, error)
            } else {
                let ac = LyftOAuthToken(json: (httpResponse?.responseBody!)!, refreshToken: refreshToken)
                completion(ac, nil)
            }
        }
    }
    
    /// Get Access Token using the authorization code
    func getAccessTokenFromAuthorizationCode(authorizationCode:String, completion: @escaping (LyftOAuthToken?, String) -> Void) {
        self.getAccessToken(grant: Grant.AuthorizationCode, code: authorizationCode) {httpResponse, error in
            if (error != nil){
                completion(nil,"")
            } else {
                let ac = LyftOAuthToken(json: (httpResponse?.responseBody!)!)
                completion(ac, "")
                
            }
        }
    }
    
    /// Request for the access token for the user
    func getAccessToken(grant: Grant, code:String, completion: @escaping (HttpResponse?, HttpError?) -> Void) {
        let url = "https://api.lyft.com/oauth/token"
        
        var headers:[String:String] = [:]
        headers["Content-Type"] = "application/json"
        headers["Authorization"] = basicAuthHeader(username: LyftOAuthConfig.clientId, password: LyftOAuthConfig.clientSecret)
        
        var authCode:[String:String] = [:]
        authCode["grant_type"] = grant.type
        authCode[grant.code] = code
        
        let data = try! JSONSerialization.data(withJSONObject: authCode, options: [])
        
        self.httpClient.post(url: url, headers: headers, body: data) {  httpResponse,error in
            completion(httpResponse, error)
        }
    }
    
    func rideHistory(startTime: String, endTime: String?, accessToken: String, completion: @escaping ([Rides]?, HttpError?) -> Void) {
        var endTimeParam = ""
        if let _endTime = endTime {
            endTimeParam = "&end_time=" + _endTime
        }
        
        let url = "https://api.lyft.com/v1/rides?start_time=" + startTime + endTimeParam
        self.httpClient.get(url: url, headers: basicHttpHeaders(accessToken)) { httpResponse, httpError in
            var rides: [Rides] = []
            
            if (httpError != nil) {
                completion(nil, httpError)
            }
            
            if let _responseBody = httpResponse?.responseBody?["ride_history"]  {
                let rideHistory = _responseBody as AnyObject
                if (rideHistory.count == 0) {
                    completion([], nil)
                } else {
                    for index in 0...(rideHistory).count - 1 {
                        let individualRide = Rides(json: rideHistory[index] as! [String:Any])
                        rides.append(individualRide!)
                    }
                    completion(rides, nil)
                }
            }
        }
    }
    
    func rideHistory(startTime: String, accessToken: String, completion: @escaping ([Rides]?, HttpError?) -> Void) {
        rideHistory(startTime: startTime, endTime:nil, accessToken: accessToken) { rides, httpError in
            completion(rides, httpError)
        }
    }
    
    func rideHistory(accessToken:String, completion:@escaping ([Rides]?, HttpError?) -> Void) {
        rideHistory(startTime: "2015-12-01T21:04:22Z", accessToken: accessToken) { rides, httpError in
            completion(rides, httpError)
        }
    }
    
    func userProfile(accessToken: String, completion: @escaping (Profile?, HttpError?) -> Void) {
        let url = "https://api.lyft.com/v1/profile"
        
        self.httpClient.get(url: url, headers: basicHttpHeaders(accessToken)) { httpResponse, httpError in
            
            if (httpError != nil) {
                completion(nil, httpError)
            } else {
                if let _profile = httpResponse?.responseBody {
                    let profile = Profile(json: _profile)
                    completion(profile, nil)
                }
            }
        }
    }
    
    private func basicHttpHeaders(_ accessToken: String) -> [String: String] {
        var headers:[String:String] = [:]
        headers["Content-Type"] = "application/json"
        headers["Authorization"] = "Bearer " + accessToken
        return headers
    }
    
}

