//
//  spectItem.swift
//  BIMSpectGithub
//
//  Created by kai on 2015/11/20.
//  Copyright © 2015年 kai. All rights reserved.
//

import Foundation
import CoreData

class SpectItem {

    let floor : String
    let item : [String]
    
    
    init(floor:String, item:[String]){
        self.floor = floor
        self.item  = item
    }
}
