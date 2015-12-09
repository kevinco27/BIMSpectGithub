//
//  ItemOKImage+CoreDataProperties.swift
//  BIMSpectGithub
//
//  Created by kai on 2015/12/9.
//  Copyright © 2015年 kai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ItemOKImage {

    @NSManaged var createDateTime: NSDate?
    @NSManaged var itemId: NSNumber?
    @NSManaged var itemOKImageId: NSNumber?
    @NSManaged var okImage: NSData?

}
