//
//  ImageViwer.swift
//  BIMSpectGithub
//
//  Created by kai on 2016/1/2.
//  Copyright © 2016年 kai. All rights reserved.
//

import UIKit
import CoreData

class ImageViwer: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var item:Item!
    var checkStatus : Bool!
    var context : NSManagedObjectContext!
    var imageData : [[String:AnyObject]]?
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var deleteMark: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor.whiteColor()
        navigationBar.barTintColor = UIColor(red: 0.33, green: 0.38, blue: 0.44, alpha: 1)
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        context = appdelegate.managedObjectContext
        
        
        // load image
        if checkStatus == true {
            
            let request = NSFetchRequest(entityName: "ItemOKImage")
            let filter = item.itemId
            request.predicate = NSPredicate(format: "itemId = %@", filter!)
            
            do{
                let itemImages = try context.executeFetchRequest(request) as? [ItemOKImage]
                
                //put image and selected status into dictionary
                imageData = itemImages?.map({ ["item":$0, "Selected":false]})
            }catch let error as NSError{
                // 錯誤處理
                print(error.description)
            }
            
        }else{
            
            let request = NSFetchRequest(entityName: "ItemNGImage")
            let filter = item.itemId
            request.predicate = NSPredicate(format: "itemId = %@", filter!)
            
            do{
               let itemImages = try context.executeFetchRequest(request) as? [ItemNGImage]
                
                //put image and selected status into dictionary
                imageData = itemImages?.map({ ["item":$0, "Selected":false ]})
            }catch let error as NSError{
                // 錯誤處理
                print(error.description)
            }
        }
        
    }
 
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    //MARK:- collection view
    
    let reuseIdentifier = "collectionCell"
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if imageData != nil {
            return imageData!.count
        }else{
            return 0
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)  as! ImageCollectionViewCell
        
        if checkStatus == true {
            let item = imageData![indexPath.row]["item"] as! ItemOKImage
            cell.imageView.image = UIImage(data: item.okImage!)
            
        }else{
            let item = imageData![indexPath.row]["item"] as! ItemNGImage
            cell.imageView.image = UIImage(data: item.ngImage!)
        }
        
        return cell
    }

    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    
            return CGSize(width: 133, height: 100)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    var selectedItemIndex : [Int] = []
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ImageCollectionViewCell
        
        let selectedStatus = imageData![indexPath.row]["Selected"] as!Bool
        if selectedStatus == false{
            cell.backgroundColor = UIColor(red: 0.22, green: 0.66, blue: 0.98, alpha: 1.0)
            //  Dictionay< index of tapped cell , item in imageData >
            selectedItemIndex.append(indexPath.row)
            imageData![indexPath.row]["Selected"] = true
            print("select! Now \(selectedItemIndex.count) selected!")
        
        }else{
            cell.backgroundColor = UIColor.whiteColor()
            
            for index in 0...selectedItemIndex.count-1{
                if selectedItemIndex[index] == indexPath.row{
                    selectedItemIndex.removeAtIndex(index)
                    break
                }
            }
            imageData![indexPath.row]["Selected"] = false
            print("unselect! Now remains \(selectedItemIndex.count) selected!")
            
        }
    }
    
    @IBAction func deleteImage(sender: AnyObject) {
        
        if selectedItemIndex.count != 0{
            let deleteAlert = UIAlertController(title: "Image Delete", message: " \(selectedItemIndex.count) images will be deleted!", preferredStyle: .Alert)
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            presentViewController(deleteAlert, animated: true, completion: nil)
            deleteAlert.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { (UIAlertAction) -> Void in
                
                for index in self.selectedItemIndex{
                    if self.checkStatus == true{
                        self.context.deleteObject(self.imageData![index]["item"] as! ItemOKImage)
                        //set dictionary at selected index in imageData to ["":"none"], and it will be filter out later. If not do so, it would be runtime-error when doing reloadData
                        self.imageData![index] = ["":"none"]
                    }else{
                        self.context.deleteObject(self.imageData![index]["item"] as! ItemNGImage)
                        //set dictionary at selected index in imageData to ["":"none"], and it will be filter out later. If not do so, it would be runtime-error when doing reloadData
                        self.imageData![index] = ["":"none"]
                    }
                }
                
                try!self.context.save()
                self.imageData = self.imageData!.filter({ (var element) -> Bool in
                    if element[""]as? String == "none"{
                        return false
                    }else{
                       element["Selected"] = false
                        return true
                    }
                })
                self.selectedItemIndex.removeAll()
                self.collectionView.reloadData()
            }))
           
        }
        
    }
    
}



