//
//  DetailViewController.swift
//  BIMSpectGithub
//
//  Created by kai on 2015/11/21.
//  Copyright © 2015年 kai. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {

    
    @IBOutlet weak var tableVIew: UITableView!
    var detailSpectItem : SpectItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //receive the notification when specItem is changed
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "specItemSelection:", name: "specItemChanged" , object: nil)
    }
    
    func specItemSelection(noti : NSNotification){
        detailSpectItem = noti.object as! SpectItem
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return detailSpectItem.item.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier( "detailCell" , forIndexPath: indexPath)
        let items = detailSpectItem.item
        cell.textLabel?.text = items[indexPath.row]
        
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


