//
//  ProjectSelectionTableViewController.swift
//  BIMSpectGithub
//
//  Created by kai on 2015/11/21.
//  Copyright © 2015年 kai. All rights reserved.
//

import UIKit
import CoreData

class ProjectSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var signOutButtonBackView: UIView!
    
    var projectData:[Project]?
    var spotCheckData:[[SpotCheck]]? = []
    override func viewDidLoad() {
        super.viewDidLoad()
       
        signOutButtonBackView.layer.borderWidth = CGFloat(0.8)
        signOutButtonBackView.layer.borderColor = UIColor(red: 0.13, green: 0.57, blue: 0.98, alpha: 1.0).CGColor
        
        tableView.dataSource = self
        tableView.delegate = self
        
        projectData = loadProjectData()//load all the projects
        spotCheckData = loadSpotCheckData(projectData)//load spotCheck according to the project which been selected
        tableView.reloadData()
        
    }
    
    //MARK:- load data
    
    func loadProjectData() -> [Project]?{
        
        let dataSource:[Project]?
        
        let requestForPorject = NSFetchRequest(entityName: "Project")

        let load = LoadData(request: requestForPorject)
        dataSource = load.find() as? [Project]
        
        if dataSource != nil{
        return dataSource
        }else{
            return nil
        }

    }
    
    func loadSpotCheckData(projData:[Project]?)->[[SpotCheck]]?{
        
        var dataSource:[[SpotCheck]] = []
       
        let requestForSpotCheck = NSFetchRequest(entityName: "SpotCheck")
        
        for project in projData!
        {
            var data : [SpotCheck]
            let filter = project.projectId
            let predicate = NSPredicate(format: "projectId = %@", filter!)
            let load = LoadData(request: requestForSpotCheck, predicate: predicate)
            data = load.find() as! [SpotCheck]
            dataSource.append(data)
        }
        
        if dataSource.count != 0{
            return dataSource
        }else{
            return nil
        }
    }
    
    // MARK: - Table view data source and delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return projectData!.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }

    //one section in the table view has two cells
    let cellIdentifer = ["projectNameCell", "pickerCell"]
    var counter = 0
    var downloadButton : UIButton!
    var currentProj : Project!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        let  currentCell = cellIdentifer[indexPath.row]
       
        // each section has two cells
        switch currentCell{
        case "projectNameCell":
            cell = tableView.dequeueReusableCellWithIdentifier(currentCell, forIndexPath: indexPath) as  UITableViewCell
            currentProj = projectData![counter]
            cell.textLabel?.text = currentProj.projectName

        
        case "pickerCell":
            cell = tableView.dequeueReusableCellWithIdentifier(currentCell, forIndexPath: indexPath) as  UITableViewCell
            let contentView = cell.contentView
            
            //creat a picker view in the second raw of a section for user to choose spot
            let PickerView = UIPickerView()
            PickerView.dataSource = self
            PickerView.delegate = self
            PickerView.tag = counter
            ++counter
            contentView.addSubview(PickerView)
            
            //autoLayout for picker view
            
             //set this property to "false" to active autolayout, otherwise autolayout won't work
            PickerView.translatesAutoresizingMaskIntoConstraints = false
            
            let HZConsOfPickerView = NSLayoutConstraint(item: PickerView, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1, constant: 0)//Horizontal center to super view
            
            let VRConsOfPickerView = NSLayoutConstraint(item: PickerView, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0) //Vertical center to super view
            
            let HeightConsOfPickerView = NSLayoutConstraint(item: PickerView, attribute: .Height, relatedBy: .Equal, toItem: contentView, attribute: .Height, multiplier: 2, constant: 0) //double height of super view
            
            let WidthConsOfPickerView = NSLayoutConstraint(item: PickerView, attribute: .Width, relatedBy: .Equal, toItem: contentView, attribute: .Width, multiplier: 0.1, constant: 0)//half width of super view
            
            // active all constrains of the picker view and the button
            NSLayoutConstraint.activateConstraints([
                HZConsOfPickerView,
                VRConsOfPickerView,
                HeightConsOfPickerView,
                WidthConsOfPickerView,])
            
            //creat a button 
            downloadButton = UIButton()
            downloadButton.addTarget(self, action: "projectDownload:", forControlEvents: .TouchUpInside)
            downloadButton.layer.backgroundColor = UIColor(red: 0.94, green: 0.45, blue: 0.26, alpha: 1.0).CGColor
            downloadButton.setTitle("Download", forState: .Normal)
            downloadButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            contentView.addSubview(downloadButton)
            //autolayout for button 
            let distanceToPiclerView = PickerView.frame.width/2 + 50
            let HZConsOfButton = NSLayoutConstraint(item: downloadButton, attribute: .CenterX, relatedBy: .Equal, toItem: PickerView, attribute: .CenterX, multiplier: 1.0, constant: distanceToPiclerView )
            let VRConsOfButton = NSLayoutConstraint(item: downloadButton, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
            let HeightConsOfButton = NSLayoutConstraint(item: downloadButton, attribute: .Height, relatedBy: .Equal, toItem: contentView, attribute: .Height, multiplier: 0.5, constant: 0)
            downloadButton.frame.size.width = 80
            downloadButton.translatesAutoresizingMaskIntoConstraints = false
            
            // active all constrains of the button
            NSLayoutConstraint.activateConstraints([
                HZConsOfButton,
                VRConsOfButton,
                HeightConsOfButton,])
            
            //make the picker view cell invisible when the cell been creating
            cell.hidden = true
            
        default:break
        }
        return cell
    }
    
    var pickedSpCheck : SpotCheck!
    // called when tap the download button
    func projectDownload(sender:UIButton!){
    
        if pickedSpCheck != nil{
        
        let appDelegate = UIApplication.sharedApplication().delegate as!AppDelegate
        
        appDelegate.temp_pickedSpCheck = pickedSpCheck //passing pickedSpCheck to AppDelegate then to MasterViewController by AppDelegate to tell which spot is selected
        
        //jump to split view while changing the root view to splitViewController
        appDelegate.loggedIn = true
        appDelegate.setupRootViewController(true)
            
        }
    
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 44
        }else{
            return 70
        }
    }
    
    var selectedProjectNameCellIndexPath : NSIndexPath?
    var pickerCellIndexPath : NSIndexPath?
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            if selectedProjectNameCellIndexPath == nil{ //first time tapped
                selectedProjectNameCellIndexPath = indexPath
                pickerCellIndexPath = NSIndexPath(
                    forRow: indexPath.row+1,
                    inSection: indexPath.section)
                
                // make picker cell visible when the project cell been tapped
                tableView.cellForRowAtIndexPath(pickerCellIndexPath!)?.hidden = false
                
            }else{ //the tapped event after first time tapping
            
            let previousPickerCellIndexPath = NSIndexPath(
                forRow: selectedProjectNameCellIndexPath!.row+1,
                inSection: selectedProjectNameCellIndexPath!.section)
        
                if indexPath == selectedProjectNameCellIndexPath{ // tap the same cell
            
                    if (tableView.cellForRowAtIndexPath(previousPickerCellIndexPath)?.hidden)!{
                    tableView.cellForRowAtIndexPath(previousPickerCellIndexPath)?.hidden = false
                    }else{
                    tableView.cellForRowAtIndexPath(previousPickerCellIndexPath)?.hidden = true
                    }
                }else{
                selectedProjectNameCellIndexPath = indexPath
                pickerCellIndexPath = NSIndexPath(
                    forRow: indexPath.row+1,
                    inSection: indexPath.section)
                tableView.cellForRowAtIndexPath(pickerCellIndexPath!)?.hidden = false
                tableView.cellForRowAtIndexPath(previousPickerCellIndexPath)?.hidden = true
             
                }
            }
        }
    
    }
    
    //MARK:- picker view delegate
    var currentSpCheck : [SpotCheck]!
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        let tagOfPicker = pickerView.tag
        
        return spotCheckData![tagOfPicker].count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        var pickerLabel = view as! UILabel!
        if view == nil {
            pickerLabel = UILabel() //if no label there yet
        }
        
        let tagOfPicker = pickerView.tag
        currentSpCheck = spotCheckData![tagOfPicker]
        
        let titleData:String!
        titleData = currentSpCheck![row].spotCheckName
        
        //set the style of  label
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Arial", size: 15.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel!.attributedText = myTitle
        pickerLabel!.textAlignment = .Center
        return pickerLabel
        
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickedSpCheck = currentSpCheck[row]
        
        
    }
    
    
    @IBAction func signOut(sender: AnyObject) {
        //go back to the to the login view
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.loggedIn = false
        appdelegate.setupRootViewController(true, toLoginOrProjectView: "loginView")
        
    }
    


}



