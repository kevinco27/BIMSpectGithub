//
//  LoginViewController.swift
//  BIMSpectGithub
//
//  Created by kai on 2015/11/21.
//  Copyright © 2015年 kai. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    
    @IBOutlet weak var backgroundView: UIImageView!
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var signInButtonBackView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.image = UIImage(named: "loginBackground")
        signInButtonBackView.layer.borderWidth = CGFloat(0.8)
        signInButtonBackView.layer.borderColor = UIColor(red: 0.13, green: 0.57, blue: 0.98, alpha: 1.0).CGColor
    }
    

    
    @IBAction func submit(sender: AnyObject) {
        
        performSegueWithIdentifier( "toProject", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
}
