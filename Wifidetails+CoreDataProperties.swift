//
//  Wifidetails+CoreDataProperties.swift
//  FuelSecuer
//
//  Created by VASP on 5/27/16.
//  Copyright © 2016 VASP. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Wifidetails {

    @NSManaged var hoseID: String?
    @NSManaged var hoseNumber: String?
    @NSManaged var siteAddress: String?
    @NSManaged var siteID: String?
    @NSManaged var siteName: String?
    @NSManaged var siteno: String?
    @NSManaged var wifiSSID: String?
    @NSManaged var userName: String?
    @NSManaged var password: String?

}
