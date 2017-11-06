//
//  AppErrors.swift
//  cabBudget
//
//  Created by Varun Ajmera on 10/7/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.
//

import Foundation

enum TimeZoneError: Error {
    case notFound 
}

enum DBError: Error {
    case couldNotSave
    
    case inconsistencyError
    
    case errorInReadingFromDb
}
