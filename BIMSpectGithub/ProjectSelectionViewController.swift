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
    
    
    var projectData:[Project]?
    var spotCheckData:[[SpotCheck]]? = []
    var categoryData : [[[Category]]]? = []
    var sections: [[AnyObject]]?
    var currentProj : Project!
    var currentSpCheck : [SpotCheck]!
    var currentCategory : [[Category]]!
    var pickedCategory : [Category]?
    var numbersOfCategoryPicked : Int?
    let cellIdentifer = ["projectNameCell", "pickerCell"]
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.dataSource = self
        tableView.delegate = self
        
        loadProjectData()
        loadSpotCheckData(projectData)
        loadCategoryData(spotCheckData)
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
            var dataSource : [SpotCheck]
            let filter = data.projectId
            let predicate = NSPredicate(format: "projectId = %@", filter!)
            let load = LoadData(request: requestForSpotCheck, predicate: predicate)
            dataSource = load.find() as! [SpotCheck]
            spotCheckData?.append(dataSource)
        }
        print("spotCheckData:\(spotCheckData!.count)")
    }
    
    func loadCategoryData(spotcheckData:[[SpotCheck]]?){
        let requestForCategory = NSFetchRequest(entityName: "Category")
        
        for spCheckArray in spotcheckData!
        {
            var temp : [[Category]]! = []
            for spCheck in spCheckArray
            {
                var dataSource = []
                let filter = spCheck.spotCheckId
                let predicate = NSPredicate(format: "spotCheckId = %@", filter!)
                let load = LoadData(request: requestForCategory, predicate: predicate)
                dataSource = load.find()
                temp.append(dataSource as! [Category])
            }
            categoryData?.append(temp)

        }
        
    }
    
//    func grouped(projData:[Project]?, spotCheckData:[[SpotCheck]]?, cateData: [[Category]]?){
//        
//        for var i = 0 ; i < projData!.count ; ++i
//        {
//            var group:[AnyObject]!
//            
//            let projName = projData![i].projectName
//            group.append(projName!)
//            
//            let spcheck = spotCheckData![i]
//            group.append(spcheck)
//            
//            var category : [[Category]]! = nil
//            for element in spcheck
//            {
//                let id = element.spotCheckId as! Int
//                category.append(cateData![id])
//            }
//            group.append(category)
//            
//        }
//        
//    }


    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return projectData!.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }

    
     var counter = 0
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        let  currentCell = cellIdentifer[indexPath.row]
       
        // each section has two cell
        switch currentCell{
        case "projectNameCell":
            cell = tableView.dequeueReusableCellWithIdentifier(currentCell, forIndexPath: indexPath) as  UITableViewCell
            currentProj = projectData![counter]
            cell.textLabel?.text = currentProj.projectName
        
        
        case "pickerCell":
            cell = tableView.dequeueReusableCellWithIdentifier(currentCell, forIndexPath: indexPath) as  UITableViewCell
            let contentView = cell.contentView
        
            //creat a picker view in the second raw of a section for user to choose spot and category
            let PickerView = UIPickerView()
            PickerView.dataSource = self
            PickerView.delegate = self
            PickerView.tag = counter

            ++counter
            
            contentView.addSubview(PickerView)
            //autoLayout - picker view
            let HZCons = NSLayoutConstraint(item: PickerView, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1, constant: 0)//Horizontal center to super view
            
            let VRCons = NSLayoutConstraint(item: PickerView, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0) //Vertical center to super view
            
            let HeightCons = NSLayoutConstraint(item: PickerView, attribute: .Height, relatedBy: .Equal, toItem: contentView, attribute: .Height, multiplier: 2, constant: 0) //equal height of super view
            
            let WidthCons = NSLayoutConstraint(item: PickerView, attribute: .Width, relatedBy: .Equal, toItem: contentView, attribute: .Width, multiplier: 0.5, constant: 0)//half width of super view
            
            PickerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activateConstraints([HZCons,VRCons,HeightCons,WidthCons])
            cell.hidden = true
            
        default:break
        }
        return cell
    }
    
    
    var selectedProjectNameCellIndexPath : NSIndexPath?
    var pickerCellIndexPath : NSIndexPath?
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0{
            //let previousIndexPath = selectedProjectNameCellIndexPath
            if selectedProjectNameCellIndexPath == nil{
                selectedProjectNameCellIndexPath = indexPath
                pickerCellIndexPath = NSIndexPath(
                    forRow: indexPath.row+1,
                    inSection: indexPath.section)
                tableView.cellForRowAtIndexPath(pickerCellIndexPath!)?.hidden = false
                
            }else{
            
            let previousPickerCellIndexPath = NSIndexPath(
                forRow: selectedProjectNameCellIndexPath!.row+1,
                inSection: selectedProjectNameCellIndexPath!.section)
           
            if indexPath == selectedProjectNameCellIndexPath{
                
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

}


// extense the ProjectSelectionViewController to perform the picker view delegate
 extension ProjectSelectionViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let tagOfPicker = pickerView.tag
        if component == 0 {
            
            return spotCheckData![tagOfPicker].count
        } else {
            
            if numbersOfCategoryPicked != nil{
                return numbersOfCategoryPicked!
            }else{
                return 1
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
        }
        
        if component == 0{
            let titleData:String!
            let tagOfPicker = pickerView.tag
            currentSpCheck = spotCheckData![tagOfPicker]
            currentCategory = categoryData![tagOfPicker]
            
            titleData = currentSpCheck![row].spotCheckName
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Arial", size: 15.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
            pickerLabel!.attributedText = myTitle
            pickerLabel!.textAlignment = .Center
            return pickerLabel
            
        }else{
            let titleData :String!
            if let picked = pickedCategory {
                titleData = picked[row].categoryName
            }else{
                titleData =  "none"
            }
            
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Arial", size: 15.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
            pickerLabel!.attributedText = myTitle
            pickerLabel!.textAlignment = .Center
            return pickerLabel
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        if component == 0 {
            pickedCategory = currentCategory[row]
            numbersOfCategoryPicked = pickedCategory?.count
            pickerView.reloadComponent(1)
        }else{
            
        }
    }
    
    
    
}






