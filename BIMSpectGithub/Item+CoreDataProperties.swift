//
//  Item+CoreDataProperties.swift
//  BIMSpectGithub
//
//  Created by kai on 2015/12/6.
//  Copyright © 2015年 kai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var categoryId: NSNumber?
    @NSManaged var itemCheck: NSNumber?
    @NSManaged var itemFalseText: String?
    @NSManaged var itemName: String?
    @NSManaged var itemId : NSNumber?

}
