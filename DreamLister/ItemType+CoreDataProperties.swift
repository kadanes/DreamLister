//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Parth Tamane on 27/08/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
