//
//  AppDelegate.swift
//  BIMSpectGithub
//
//  Created by kai on 2015/11/17.   aaaaa
//  Copyright © 2015年 kai. All rights reserved.
//
//abc
import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var loggedIn = false
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        setupRootViewController(false)
        
        //Initiate demo data
        deleteAllExistingData()
        createBIMSpectData()
        
        return true
    }
    
    // MARK: --InitialDemoData
    func deleteAllExistingData() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let coord = appDelegate.persistentStoreCoordinator
        
        var fetchRequest = NSFetchRequest(entityName: "Project")
        var deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try coord.executeRequest(deleteRequest, withContext: context)
        } catch let error as NSError {
            debugPrint(error)
        }
        
        fetchRequest = NSFetchRequest(entityName: "SpotCheck")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try coord.executeRequest(deleteRequest, withContext: context)
        } catch let error as NSError {
            debugPrint(error)
        }
        
        fetchRequest = NSFetchRequest(entityName: "Category")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try coord.executeRequest(deleteRequest, withContext: context)
        } catch let error as NSError {
            debugPrint(error)
        }
        
        fetchRequest = NSFetchRequest(entityName: "Item")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try coord.executeRequest(deleteRequest, withContext: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    func createBIMSpectData()
    {
        //取得Context
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        //建立Entity
        let project = NSEntityDescription.insertNewObjectForEntityForName("Project", inManagedObjectContext: context) as! Project
        let spotCheck = NSEntityDescription.insertNewObjectForEntityForName("SpotCheck", inManagedObjectContext: context) as! SpotCheck
        
        project.projectId = 0
        project.projectName = "Research Building for NTU Civil Engineering"
        
        spotCheck.spotCheckId = 0
        spotCheck.projectId = 0
        spotCheck.spotCheckName = "Door"
        
        appDelegate.saveContext()
        
        for i in 0...5 {
            createCategories(i, appDelegate: appDelegate, context: context)
        }
        
        for i in 0...5 {
            for j in 0...5{
                createItems(i, j: j, appDelegate: appDelegate, context: context)
            }
        }
        
        
    }
    
    func createCategories(i:Int, appDelegate:AppDelegate, context:NSManagedObjectContext)
    {
        //建立Entity
        let category = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: context) as! Category
        
        category.categoryId=i
        category.spotCheckId = 0
        category.categoryName = "\(i+1)F"
        
        appDelegate.saveContext()
    }
    
    func createItems(i:Int, j:Int, appDelegate:AppDelegate, context:NSManagedObjectContext)
    {
        var items:[String] = []
        items.append("廁所浴室門檢查是否符合施工安裝法規。")
        items.append("磁質地磚尺寸、顏色、型號是否正確。")
        items.append("磁質地磚：以水平尺校正磚面齊平，磚縫整齊平直不大於10mm")
        items.append("廁所粉刷打底需防水粉刷。")
        items.append("陽台粉刷打底需防水粉刷。")
        items.append("磁磚表面以海綿沾肥皂水清洗。")
        
        //建立Entity
        let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: context) as! Item
        
        item.categoryId = i
        item.itemId = i*6 + j
        let index = Int(arc4random_uniform(6))
        item.itemName = items[index]
        
        appDelegate.saveContext()
        
    }

    // MARK: --
    
    func setupRootViewController(animated: Bool , toLoginOrProjectView:String = "loginView")
    {
        
        if let window = self.window
        {
            
            var newRootViewController: UIViewController? = nil
            var transition: UIViewAnimationOptions   //create and setup appropriate rootViewController
            
            if !loggedIn && toLoginOrProjectView == "loginView"
            {
                 let loginViewController = window.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
                 newRootViewController = loginViewController
                 transition = .TransitionFlipFromLeft
    
            }
            else if !loggedIn && toLoginOrProjectView == "projectView"
            {
                let projectSelectionViewController = window.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("projectView") as! ProjectSelectionViewController
                newRootViewController = projectSelectionViewController
                transition = .TransitionFlipFromLeft
            }
            else
            {
            
              let splitViewController = window.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier( "splitView" ) as! UISplitViewController
              let leftNavController = splitViewController.viewControllers.first as! UINavigationController
              let masterViewController = leftNavController.topViewController as! MasterViewController
              let detailViewController = splitViewController.viewControllers.last as! DetailViewController
              let firstSpectItem = masterViewController.masterSpectItem.first
              detailViewController.detailSpectItem = firstSpectItem
              transition = .TransitionFlipFromRight
              newRootViewController = splitViewController
            
            
            }
            // update app's rootViewController
            if let rootVC = newRootViewController {
             if animated {
              UIView.transitionWithView(window, duration: 0.5, options: transition , animations: {
                    () ->Void in window.rootViewController = rootVC }, completion: nil)
             }
             else{
                window.rootViewController = rootVC
                }
            }
        }
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
       // self.saveContext()
    }


    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "KaiHsiang.BIMSpectGithub" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("BIMSpectGithub", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}
