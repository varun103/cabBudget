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
        super.insert(ride)
        let context: NSManagedObjectContext = container.viewContext
        let rideModel = Ride(context:context)
        let savedRide = try? rideModel.findOrCreate(rides: ride, context: context)
        try? context.save()
        //print(savedRide)
    }

}
