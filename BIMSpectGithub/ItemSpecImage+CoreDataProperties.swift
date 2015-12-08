//
//  ItemSpecImage+CoreDataProperties.swift
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

extension ItemSpecImage {

    @NSManaged var itemId: NSNumber?
    @NSManaged var specImage: NSData?

}
