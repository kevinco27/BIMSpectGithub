//
//  PhotoPopoverViewController.swift
//  BIMSpectGithub
//
//  Created by kai on 2015/12/23.
//  Copyright © 2015年 kai. All rights reserved.
//

import UIKit
import CoreData

class PhotoPopoverViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var item:Item!
    var checkStatus:Bool!
    let imagePicker:UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        imagePicker.delegate = self
        
        let nc = NSNotificationCenter.defaultCenter()
        
        nc.addObserver(self, selector: "receiveSomethingFromDetailView:", name: "item", object: nil)
        nc.addObserver(self, selector: "receiveSomethingFromDetailView:", name: "checkStatus", object: nil)
        
    }
    
    func receiveSomethingFromDetailView(noti:NSNotification){
        
        if noti.name == "item"{
            item = noti.object as? Item
        }else if noti.name == "checkStatus"{
            checkStatus = noti.object as? Bool
        }
        
    }
    
    //MARK:- tableView
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        switch indexPath.row{
        //camera
        case 0 :
        
            imagePicker.modalPresentationStyle = .OverFullScreen
            imagePicker.sourceType = .Camera
            presentViewController(imagePicker, animated: true, completion: nil)
            
            let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appdelegate.managedObjectContext
            
            //////////////////// 測試,之後可刪//////////////////////////
            let test :[ItemNGImage] =  try!context.executeFetchRequest(NSFetchRequest(entityName: "ItemNGImage")) as! [ItemNGImage]
            print("ItemNGImage has \(test.count)")
            print(test.map({ (ItemNGImage) -> (Int,Int) in
                let imageId = ItemNGImage.itemNGImageId
                let id      = ItemNGImage.itemId
                return (Int(id!), Int(imageId!))
            }))
            //////////////////////////////////////////////////////////
            
        
        //photo library
        case 1 :
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viwer = storyboard.instantiateViewControllerWithIdentifier("imageViwer") as!ImageViwer
            viwer.item = self.item
            viwer.checkStatus = self.checkStatus
            viwer.preferredContentSize = CGSize(width: 600, height: 600)
            viwer.modalPresentationStyle = .FormSheet
            presentViewController(viwer, animated: true, completion: nil)
            
            
        default:break
        
        }
    
    }
    
    
    //MARK:- imagePickerController
    var pickedImage:UIImage?
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage]as?UIImage{
           
           // processing the image saving in background
           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
               {self.saveImage(image)})
            
        }else{ print("fail")}
    
        self.dismissViewControllerAnimated(false, completion:{ self.presentViewController( self.imagePicker, animated: false, completion: nil)})
    }
    
    func saveImage(image:UIImage){
        
            let image : NSData = UIImagePNGRepresentation(image)!
            
            let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appdelegate.managedObjectContext
            
            if self.checkStatus!{
                
                //creat ItemOKImage object
                let item = ItemOKImage(entity: NSEntityDescription.entityForName("ItemOKImage", inManagedObjectContext: context)!, insertIntoManagedObjectContext: context)
                
                // assign "itemId" "okImage" "itemOKImageId" "createDateTime"
                item.itemId = self.item.itemId
                
                item.okImage = image
                
                item.itemOKImageId = { ()-> NSNumber in
                    
                    let fetchRequest = NSFetchRequest(entityName: "ItemOKImage")
                    fetchRequest.fetchLimit = 1
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "itemOKImageId", ascending: false)]
                    
                    let data:ItemOKImage!
                    do
                    {
                        // 將查詢結果 存入 data
                        data = try context.executeFetchRequest(fetchRequest).first as? ItemOKImage
                    }
                    catch
                    {
                        return NSNumber(integer: 0)
                    }
                    
                    let id = Int(data.itemOKImageId!) + 1
                    return  NSNumber(integer: id)
                    }()
                
                item.createDateTime = NSDate()
                print(item.createDateTime)
                
                do{
                    try context.save()
                    
                }catch{
                    print("fail saving item")
                    
                }
                
            }else{
                
                //creat ItemNGImage object
                let item = ItemNGImage(entity: NSEntityDescription.entityForName("ItemNGImage", inManagedObjectContext: context)!, insertIntoManagedObjectContext: context)
                
                // assign "itemId" "ngImage" "itemNGImageId" "createDateTime"
                item.itemId = self.item.itemId
                item.ngImage = image
                
                item.itemNGImageId = { ()-> NSNumber in
                    
                    let fetchRequest = NSFetchRequest(entityName: "ItemNGImage")
                    fetchRequest.fetchLimit = 1
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "itemNGImageId", ascending: false)]
                    
                    let data:ItemNGImage!
                    do
                    {
                        // 將查詢結果 存入 data
                        data = try context.executeFetchRequest(fetchRequest).first as? ItemNGImage
                    }
                    catch
                    {
                        return NSNumber(integer: 0)
                    }
                    
                    let id = Int(data.itemNGImageId!) + 1
                    return  NSNumber(integer: id)
                    }()
                
                item.createDateTime = NSDate()
                print(item.createDateTime)
                
                do{
                    try context.save()
                    
                }catch{
                    print("fail saving item")
                }
        }
        
    }
}