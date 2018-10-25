//
//  Item+CoreDataProperties.swift
//  SpenTrack
//
//  Created by Kendrew Chan on 13/3/18.
//  Copyright © 2018 KCStudios. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var dailySpending: Double
    @NSManaged public var edited: String?
    @NSManaged public var monthlySpending: Double
    @NSManaged public var spentText: String?

}
