//
//  ViewController.swift
//  cabBudget
//
//  Created by Varun Ajmera on 9/12/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.
//

import UIKit
import Foundation

/// <#Description#>
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(saveOauthToken), name: Notification.Name("AUTH_CODE"), object: nil)
        let lyftAuth = LyftAuthenticationServiceImpl()
        lyftAuth.fetchAccessToken { ac in
            print("Access token found: " + ac)
        }
        //timezone()
    }
    
    @IBAction func login(_ sender: Any) {
        UserAuthContextImp.get().deleteUserAuthToken()
    }
    
    @IBAction func getRides(_ sender: Any) {
        let lyftAuth = LyftAuthenticationServiceImpl()
        let lyftApi = LyftAPIImpl()
        
        lyftAuth.fetchAccessToken { accessToken in
            lyftApi.rideHistory(accessToken: accessToken) { rides, error in
                
                if let _rides = rides {
                    for ride in _rides {
                        print(ride.price)
                    }
                }
            }
        }
        
        lyftAuth.fetchAccessToken { accessToken in
            lyftApi.userProfile(accessToken: accessToken) { profile, error in
                print(profile ?? "Not found")
            }
        }
    }
    
    @objc func saveOauthToken() {
        let lyftApi = LyftAPIImpl()
        
        lyftApi.getAccessTokenFromAuthorizationCode(authorizationCode: LyftOAuthConfig.authCode) { oauthToken, st in
            if let _a = oauthToken {
                lyftApi.userProfile(accessToken: _a.accessToken!) { profile, error in
                    if (error != nil) {}
                    else {
                        UserAuthContextImp.get().saveUserAuthToken(userId: profile?.id ?? "", oauthToken: _a )
                    }
                }
            }
        }
    }
    
    func test(){
        print(LyftOAuthConfig.authCode)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

