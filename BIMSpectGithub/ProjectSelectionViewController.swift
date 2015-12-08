//
//  ProjectSelectionTableViewController.swift
//  BIMSpectGithub
//
//  Created by kai on 2015/11/21.
//  Copyright © 2015年 kai. All rights reserved.
//

import UIKit
import CoreData

class ProjectSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //假資料///////////
    var projects = [Project2]()
    //////////////////
    
    var projectData:[Project]?
    var spotCheckData:[[SpotCheck]]?
    var categoryData : [[Category]]?
    var sections: [[String]]?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //假資料///////////
        self.projects.append(Project2(Name: "Research Building", ID: 1))
        //////////////////
       
        
        tableView.dataSource = self
        tableView.delegate = self
        
        loadProjectData()
        loadSpotCheckData(projectData)
        tableView.reloadData()
        
    }
    
    func loadProjectData(){

        let requestForPorject = NSFetchRequest(entityName: "Project")

        let load = LoadData(request: requestForPorject)
        projectData = load.find() as? [Project]
    }
    
    func loadSpotCheckData(projData:[Project]?){
       
        let requestForSpotCheck = NSFetchRequest(entityName: "SpotCheck")
        
        for data in projData!
        {
            var dataSource = []
            let filter = data.projectId
            let predicate = NSPredicate(format: "projectId = %@", filter!)
            let load = LoadData(request: requestForSpotCheck, predicate: predicate)
            dataSource = load.find()
            spotCheckData?.append(dataSource as! [SpotCheck])
        }
    }
    
    func loadCategoryData(spotcheckData:[[SpotCheck]]?){
        
    }
    
    func grouped(projData:[Project]?, spotCheckData:[[SpotCheck]]?, cateData: [[Category]]?){
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return sections!.count
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var index : Int
//        for index = 0 ; index < section ; ++index {
//         
//            sections![index]
//            
//        }
        
    }

    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        //let project = projects[indexPath.row]
        let project = projectData![indexPath.row]
        //cell.textLabel?.text = project.Name
        
        cell.textLabel?.text = project.projectName

        return cell
    }
    
//    var selectedProject: Project2?
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//         selectedProject = projects[indexPath.row]
//    }
//    
//    @IBAction func toSpecItem(sender: AnyObject) {
//        
//        if selectedProject != nil {
//        
//        //jump to the splitViewController
//            let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//            appdelegate.loggedIn = true
//            appdelegate.setupRootViewController(true)
//        }
//        
//    }
    
    
    
    

    

   
   

    

}
