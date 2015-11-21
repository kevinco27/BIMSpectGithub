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
    var detailSpectItem : spectItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return detailSpectItem.item.count
        //return item.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier( "detailCell" , forIndexPath: indexPath)
        let items = detailSpectItem.item
        cell.textLabel?.text = items[indexPath.row]
        //          cell.textLabel!.text = item[indexPath.row]
        
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

extension DetailViewController : SpecItemSelectionProtocol{
    
    // SpecItemSelectionDelegate
    func specItemSelected(newSpecItem: spectItem) {
        detailSpectItem = newSpecItem
        tableView.reloadData()
    }

}
