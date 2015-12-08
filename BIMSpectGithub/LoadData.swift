//
//  LoadData.swift
//  BIMSpectGithub
//
//  Created by kai on 2015/12/5.
//  Copyright © 2015年 kai. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class LoadData:NSObject {
    
    let request:NSFetchRequest!
    let predicate:NSPredicate?
    
    init(request:NSFetchRequest, predicate:NSPredicate? = nil)
    {
        self.request = request
        self.predicate = predicate
    }
    
    func find() -> NSArray
    {
        
        var data = []
        // 取得 Context
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        if predicate != nil
        {
            request.predicate = predicate
        }
        
        // 執行查詢
        do
        {
            // 將查詢結果 存入 data source
            data = try context.executeFetchRequest(request)
        }
        catch let error as NSError
        {
            // 錯誤處理
            print(error.description)
        }
        
        return data
    }
    
}
