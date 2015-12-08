//
//  ProjectCategoryCell.swift
//  BIMSpectGithub
//
//  Created by kai on 2015/12/5.
//  Copyright © 2015年 kai. All rights reserved.
//

import UIKit

class ProjectCategoryCell: UITableViewCell {
    @IBOutlet weak var labelName: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var buttonBackground: UIView!
    
    @IBOutlet weak var buttonAppear: UIButton!
    
    @IBAction func buttonAction(sender: AnyObject) {
        
        
    }
    
 
    
    
    
    

}
