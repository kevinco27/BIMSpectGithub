//
//  MasterViewController.swift
//  BIMSpectGithub
//
//  Created by kai on 2015/11/20.
//  Copyright © 2015年 kai. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController , ProjectSelectionViewControllerDelegate{
    
    var pickedSpCheck : SpotCheck!
    var pickedCategories : [Category]!


    override func viewDidLoad() {
        super.viewDidLoad()
    
        let appDelegate = UIApplication.sharedApplication().delegate as!AppDelegate
        appDelegate.projecDelegate = self
        
    }
    
     override func viewWillAppear(animated: Bool) {
        pickedCategories = loadCategoryData(pickedSpCheck)
        self.tableView.reloadData()
    }
    
    
    //MARK:- ProjectSelectionViewControllerDelegate
    func passingSpCheck(pickedSpCheck: SpotCheck) {
        self.pickedSpCheck = pickedSpCheck
    }
    
    
    //MARK:- load category data
    func loadCategoryData(pickedSpCheck:SpotCheck) -> [Category]?{
        
        let requestForCategory = NSFetchRequest(entityName: "Category")
        let filter = pickedSpCheck.spotCheckId
        let predicate = NSPredicate(format: "spotCheckId = %@", filter!)
        let load = LoadData(request: requestForCategory, predicate: predicate)
        
        if let categoryPick = load.find() as? [Category]{
            return categoryPick // successful fetch category
        }else{
            return nil // fetch nothing
        }
    }
    
   


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if pickedCategories != nil{
            return pickedCategories.count
        }else{
            return 0
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("masterCell", forIndexPath: indexPath)
        let items = pickedCategories[indexPath.row]
        cell.textLabel?.text = items.categoryName
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCategory = pickedCategories[indexPath.row]
        
        //send out notification with selectedCategory object
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName( "categoryChanged", object: selectedCategory)
       
    }
    
    //MARK: - Return button
    @IBAction func back(sender: AnyObject) {
        
        //go back to the to the project view
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.loggedIn = false
        appdelegate.setupRootViewController(true, toLoginOrProjectView: "projectView")

    }
    
}

