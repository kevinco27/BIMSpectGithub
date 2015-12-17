//
//  DetailViewController.swift
//  BIMSpectGithub
//
//  Created by kai on 2015/11/21.
//  Copyright © 2015年 kai. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UITableViewController{

    @IBOutlet weak var tableVIew: UITableView!
    var pickedSpectItems : [Item]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //receive the notification when specItem is changed
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "categorySelection:", name: "categoryChanged" , object: nil)
    }
    
    func categorySelection(noti : NSNotification){
        let selectedCategory = noti.object as! Category
        pickedSpectItems = loadItemData(selectedCategory)
        tableView.reloadData()
    }
    
    //MARK:- load item data
    func loadItemData(pickedCategory:Category)->[Item]?{
        
        let itemsPick : [Item]?
        let requestForItem = NSFetchRequest(entityName: "Item")
        let filter = pickedCategory.categoryId
        let predicate = NSPredicate(format: "categoryId = %@", filter!)
        let load = LoadData(request: requestForItem, predicate: predicate)
        itemsPick = load.find() as? [Item]
        
        if itemsPick != nil{
            return itemsPick // successful fetch items
        }else{
            return nil // fetch nothing
        }
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if pickedSpectItems != nil{
            return pickedSpectItems.count
        }else{
            return 0
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier( "detailCell" , forIndexPath: indexPath)
        let item = pickedSpectItems[indexPath.row]
        cell.textLabel?.text = item.itemName
        
        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?{
        let takePhotoAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "          ", handler:{
            (action : UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
        })
        let recordAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "          ", handler:{
            ( action : UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            }
        )
        let issueNoteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "          ", handler:{
             ( action : UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                     }
         )
        let checkOKAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "          ", handler:{
             ( action : UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                     }
        )
            takePhotoAction.backgroundColor = UIColor(patternImage: UIImage(named: "takePhotoImage")!)
            recordAction.backgroundColor = UIColor(patternImage: UIImage(named: "recordImage")!)
            issueNoteAction.backgroundColor = UIColor(patternImage: UIImage(named: "issueNoteImage")!)
            checkOKAction.backgroundColor = UIColor(patternImage: UIImage(named: "checkOKImage")!)

        
             return [ checkOKAction, issueNoteAction, recordAction, takePhotoAction ]


        
    }
    
}


