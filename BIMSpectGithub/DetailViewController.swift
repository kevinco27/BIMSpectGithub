//
//  DetailViewController.swift
//  BIMSpectGithub
//
//  Created by kai on 2015/11/21.
//  Copyright © 2015年 kai. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UITableViewController, UIPopoverPresentationControllerDelegate{

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
    
    var cell : UITableViewCell!
    var checkStatus : [Bool]! = []
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.cell = tableView.dequeueReusableCellWithIdentifier( "detailCell" , forIndexPath: indexPath)
        let item = pickedSpectItems[indexPath.row]
        
        cell.textLabel?.text = item.itemName
        checkStatus.append(false)
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?{
        
        let checkOKAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "          ", handler:{
            ( action : UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
            
            if self.checkStatus[indexPath.row] == false{
                self.cell.accessoryType = .Checkmark
                self.checkStatus[indexPath.row] = true
            }else{
                self.cell.accessoryType = .None
                self.checkStatus[indexPath.row] = false
            }

            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            })
        
        let takePhotoAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "          ", handler:{
            (action : UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            
            //show pop over view
            self.popOver(indexPath, theOrderOfRawActions: 2, popOverViewIdentifier: "photoPopOver")
            
            let item = self.pickedSpectItems[indexPath.row]
            let checkstatus = self.checkStatus[indexPath.row]
            
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName("item", object: item)
            nc.postNotificationName("checkStatus", object: checkstatus)
            
            
        })
       
        
        let recordAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "          ", handler:{
            ( action : UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            }
        )
        let issueNoteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "          ", handler:{
             ( action : UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                     }
         )
        
        
            takePhotoAction.backgroundColor = UIColor(patternImage: UIImage(named: "takePhotoImage")!)
            recordAction.backgroundColor = UIColor(patternImage: UIImage(named: "recordImage")!)
            issueNoteAction.backgroundColor = UIColor(patternImage: UIImage(named: "issueNoteImage")!)
            checkOKAction.backgroundColor = UIColor(patternImage: UIImage(named: "checkOKImage")!)

        
             return [ issueNoteAction, recordAction, takePhotoAction, checkOKAction ]


        
    }
    
    //MARK:- Pop Over
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }
    
    func popOver(selectedIndexPath:NSIndexPath, theOrderOfRawActions:Int ,popOverViewIdentifier:String){
        
        
        
        cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: selectedIndexPath)
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let popoverViewController = storyboard.instantiateViewControllerWithIdentifier(popOverViewIdentifier)
        popoverViewController.modalPresentationStyle = .Popover
        popoverViewController.preferredContentSize = CGSizeMake(100, 58)
        
        let popover = popoverViewController.popoverPresentationController
        popover?.delegate = self
        popover?.permittedArrowDirections = .Any
        popover?.sourceView = cell.contentView
        let XPositionOfRawAction = cell.contentView.frame.maxX + CGFloat(37.5) + CGFloat(75*(theOrderOfRawActions-1))
        popover?.sourceRect = CGRect(x: XPositionOfRawAction , y: cell.contentView.frame.midY, width: 1, height: 1)
        self.presentViewController(popoverViewController, animated: true, completion: nil)
    }
    
    
}


