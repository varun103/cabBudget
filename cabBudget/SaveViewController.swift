//
//  SaveViewController.swift
//  cabBudget
//
//  Created by Varun Ajmera on 10/22/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.
//

import UIKit
import CoreData

class SaveViewController: ViewController {
    
    let container: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func insert(_ ride: Rides) {
        container.performBackgroundTask() { context in
            let rideModel = Ride(context:context)
            _ = try? rideModel.findOrCreate(rides: ride, context: context)
            try? context.save()
        }
    }
    
    override func getRidesCurrentMonth(completion: @escaping([Ride]) -> Void) {
        container.performBackgroundTask() { context in
            let rideModel = Ride(context:context)
            let rides = try? rideModel.fetchRidesFrom(beginning: DateHelperImpl.getBeginningOf(month:10 , year: 2017)!, end: Date(), context: context)
            completion(rides ?? [])
        }
    }

}
