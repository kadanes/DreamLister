//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Parth Tamane on 27/08/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {

    public override func awakeFromInsert() {
        
        super.awakeFromInsert()
        
        self.created = NSDate()
    }
    
}
