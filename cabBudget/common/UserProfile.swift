//
//  User.swift
//  cabBudget
//
//  Created by Varun Ajmera on 10/21/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.
//

import Foundation


/// User Information
protocol UserProfile {
    
    /// userId
    var id: String? {get}
    
    /// users first name
    var firstName: String? {get}
    
    /// users last name
    var lastName: String? {get}
}
