//
//  TextInputViewController.swift
//  BIMSpectGithub
//
//  Created by kai on 2016/1/4.
//  Copyright © 2016年 kai. All rights reserved.
//

import UIKit
import CoreData

class TextInputViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var OKButtonBackView: UIView!
    
    //obtain from editActionsForRowAtIndexPath in DetailViewController
    var item : Item!
    var appdelegate : AppDelegate!
    var context : NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        context = appdelegate.managedObjectContext
        
        navigationBar.barTintColor = UIColor(red: 0.78, green: 0.96, blue: 0.39, alpha: 1.0)
        textView.layer.borderWidth = CGFloat(0.8)
        textView.layer.borderColor = UIColor(red: 0.78, green: 0.96, blue: 0.39, alpha: 1.0).CGColor
        
        OKButtonBackView.layer.borderWidth = CGFloat(0.8)
        OKButtonBackView.layer.borderColor = UIColor(red: 0.78, green: 0.96, blue: 0.39, alpha: 1.0).CGColor
        
        // show item text in textview from coredata
        if item.itemFalseText != nil{
            textView.text = item.itemFalseText
        }
    }

    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func OK(sender: AnyObject) {
        
        //assign itemFalseText of item, and save to coredata
        item.itemFalseText = textView.text
        appdelegate.saveContext()
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    

}
