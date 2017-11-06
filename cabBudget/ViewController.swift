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
    var helper = DateHelperImpl()
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var totalCost: UILabel!
    
    @IBAction func login(_ sender: Any) {
        UserAuthContextImp.get().deleteUserAuthToken()
    }
    
    @IBAction func getRides(_ sender: Any) {
        let lyftAuth = LyftAuthenticationServiceImpl()
        let lyftApi = LyftAPIImpl()
        
//        lyftAuth.fetchAccessToken { accessToken in
//            let date = DateHelperImpl.getBeginningOf(month: 10, year: 2017)
//            lyftApi.rideHistory(startTime: DateHelperImpl.dateString(from: date!),accessToken: accessToken) {[weak self] rides, error in
//                let _total = 0
//                if let _rides = rides {
//                    for ride in _rides {
//                        print(ride.requestedTime)
//                        print(ride.origin.address)
//                        print(ride.destination.address)
//                        print(ride.price.amount)
//                    }
//                }
//                DispatchQueue.main.async {
//                    self?.totalCost.text = String(_total/100)
//                }
//            }
//        }
        
        getRidesCurrentMonth() { [weak self] rides  in
            var _total = 0
            for ride in rides {
                print(ride.price)
                _total = _total + Int(ride.price)
            }
            DispatchQueue.main.async {
                self?.monthLabel.text = (self?.helper.currentMonthName!)! + " " + String(describing: self?.helper.currentYear!)
                 self?.totalCost.text = String(_total/100)
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
                        UserAuthContextImp.get().saveUserAuthToken(user: profile!, oauthToken: _a )
                    }
                }
            }
        }
    }
    
    func insert(_ ride:Rides) {
    }
    
    func getRidesCurrentMonth(completion: @escaping([Ride]) -> Void) {
        
    }
    
    func test(){
        print(LyftOAuthConfig.authCode)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

