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
            let popOverViewSize = CGSize(width: 100, height: 58)
            self.popOver( popOverViewSize, selectedIndexPath: indexPath, theOrderInRawActions: 2, popOverViewIdentifier: "photoPopOver", presentationStyle: .Popover)
            
            //pass the "item" to the pop over view
            let item = self.pickedSpectItems[indexPath.row]
            let checkstatus = self.checkStatus[indexPath.row]
            
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName("item", object: item)
            nc.postNotificationName("checkStatus", object: checkstatus)
            
            
        })
       
        
        let recordAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "          ", handler:{
            ( action : UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            //show pop over view
            let popOverViewSize = CGSize(width: 200, height: 130)
            self.popOver( popOverViewSize, selectedIndexPath: indexPath, theOrderInRawActions: 3, popOverViewIdentifier: "recorderView", presentationStyle: .FormSheet)
            //pass the "item" to the pop over view
            let item = self.pickedSpectItems[indexPath.row]
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName("item", object: item)
            
            }
        )
        let issueNoteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "          ", handler:{
             ( action : UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let textInput = storyboard.instantiateViewControllerWithIdentifier("textInput") as!TextInputViewController
            textInput.preferredContentSize = CGSize(width: 600, height: 600)
            textInput.modalPresentationStyle = .FormSheet
            let item = self.pickedSpectItems[indexPath.row]
            textInput.item = item
            self.presentViewController(textInput, animated: true, completion: nil)
            })
        
        
            // set background image of raw actions
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
    
    func popOver(popOverViewSize:CGSize, selectedIndexPath:NSIndexPath, theOrderInRawActions:Int ,popOverViewIdentifier:String, presentationStyle: UIModalPresentationStyle){
        
        
        
        cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: selectedIndexPath)
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let popoverViewController = storyboard.instantiateViewControllerWithIdentifier(popOverViewIdentifier)
        popoverViewController.modalPresentationStyle = presentationStyle
        popoverViewController.preferredContentSize = popOverViewSize
        
        //set the reletive parameters of viewcontroller according to the presentationStyle
        switch presentationStyle{
        case .Popover:
            let popover = popoverViewController.popoverPresentationController
            popover?.delegate = self
            popover?.permittedArrowDirections = .Any
            popover?.sourceView = cell.contentView
            let XPositionOfRawAction = cell.contentView.frame.maxX + CGFloat(37.5) + CGFloat(75*(theOrderInRawActions-1))
            popover?.sourceRect = CGRect(x: XPositionOfRawAction , y: cell.contentView.frame.midY, width: 1, height: 1)
        
        default:break
        }
        
        self.presentViewController(popoverViewController, animated: true, completion: nil)
    }
    
    
}


