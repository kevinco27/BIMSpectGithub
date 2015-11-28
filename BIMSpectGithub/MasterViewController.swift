//
//  MasterViewController.swift
//  BIMSpectGithub
//
//  Created by kai on 2015/11/20.
//  Copyright © 2015年 kai. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var masterSpectItem = [SpectItem]()
    required init?(coder aDecoder: NSCoder){
            super.init(coder: aDecoder)
        self.masterSpectItem.append(SpectItem(floor: "1F", item: ["1F廁所浴室...", "磁質地磚尺寸...", "磁質地磚..."]))
        self.masterSpectItem.append(SpectItem(floor: "2F", item: ["2F廁所浴室...", "磁質地磚尺寸...", "磁質地磚..."]))
        self.masterSpectItem.append(SpectItem(floor: "3F", item: ["3F廁所浴室...", "磁質地磚尺寸...", "磁質地磚..."]))
        self.masterSpectItem.append(SpectItem(floor: "4F", item: ["4F廁所浴室...", "磁質地磚尺寸...", "磁質地磚..."]))
        self.masterSpectItem.append(SpectItem(floor: "5F", item: ["5F廁所浴室...", "磁質地磚尺寸...", "磁質地磚..."]))
        self.masterSpectItem.append(SpectItem(floor: "6F", item: ["6F廁所浴室...", "磁質地磚尺寸...", "磁質地磚..."]))
        }

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
        return masterSpectItem.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("masterCell", forIndexPath: indexPath)
        let items = masterSpectItem[indexPath.row]
        cell.textLabel?.text = items.floor
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedSpectItem = masterSpectItem[indexPath.row]
        
        //send out notification with selectedSpectItem object
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName( "specItemChanged", object: selectedSpectItem)
       
    }
    
    //MARK: - Return button
    @IBAction func back(sender: AnyObject) {
        
        //go back to the to the project view
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.loggedIn = false
        appdelegate.setupRootViewController(true, toLoginOrProjectView: "projectView")

    }
    
}
