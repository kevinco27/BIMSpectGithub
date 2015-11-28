//
//  ProjectSelectionTableViewController.swift
//  BIMSpectGithub
//
//  Created by kai on 2015/11/21.
//  Copyright © 2015年 kai. All rights reserved.
//

import UIKit

class ProjectSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var projects = [Project]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //假資料///////////
        self.projects.append(Project(Name: "Research Building", ID: 1))
        //////////////////
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return projects.count
    }

    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("projectSelectionCell", forIndexPath: indexPath)
        let project = projects[indexPath.row]
        cell.textLabel?.text = project.Name

        return cell
    }
    
    var selectedProject: Project?
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
         selectedProject = projects[indexPath.row]
    }
    
    @IBAction func toSpecItem(sender: AnyObject) {
        
        if selectedProject != nil {
        
        //jump to the splitViewController
            let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appdelegate.loggedIn = true
            appdelegate.setupRootViewController(true)
        }
        
    }
    
    
    
    

    

   
   

    

}
