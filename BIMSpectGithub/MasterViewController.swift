//
//  MasterViewController.swift
//  BIMSpectGithub
//
//  Created by kai on 2015/11/20.
//  Copyright © 2015年 kai. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var masterSpectItem = [spectItem]()
    required init?(coder aDecoder: NSCoder){
            super.init(coder: aDecoder)
        self.masterSpectItem.append(spectItem(floor: "1F", item: ["1F廁所浴室...", "磁質地磚尺寸...", "磁質地磚..."]))
        self.masterSpectItem.append(spectItem(floor: "2F", item: ["2F廁所浴室...", "磁質地磚尺寸...", "磁質地磚..."]))
        self.masterSpectItem.append(spectItem(floor: "3F", item: ["3F廁所浴室...", "磁質地磚尺寸...", "磁質地磚..."]))
        self.masterSpectItem.append(spectItem(floor: "4F", item: ["4F廁所浴室...", "磁質地磚尺寸...", "磁質地磚..."]))
        self.masterSpectItem.append(spectItem(floor: "5F", item: ["5F廁所浴室...", "磁質地磚尺寸...", "磁質地磚..."]))
        self.masterSpectItem.append(spectItem(floor: "6F", item: ["6F廁所浴室...", "磁質地磚尺寸...", "磁質地磚..."]))
        }
    
    weak var SpecItemSelectionDelegate:SpecItemSelectionProtocol?
    

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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedSpectItem = masterSpectItem[indexPath.row]
        SpecItemSelectionDelegate?.specItemSelected(selectedSpectItem)
        
        if let detailViewController = self.SpecItemSelectionDelegate as? DetailViewController {
            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
    }
    
}
