//
//  Item+CoreDataClass.swift
//  SpenTrack
//
//  Created by Kendrew Chan on 13/3/18.
//  Copyright © 2018 KCStudios. All rights reserved.
//
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let currentDate = Date()
        
        let convertedDateString = dateFormatter.string(from: currentDate)
        
        self.edited = convertedDateString //assigning current data to the 'created' attribute within 'item' enitity in core data
        
    }
}
