//
//  ProfileSocialCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 20/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class ProfileSocialCell: UITableViewCell {
    
    typealias SocialButtonClickEvent = (_ index : Int?) -> Void
    var clickOnBtn : SocialButtonClickEvent!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnSocialIconAction(_ sender: UIButton) {
        self.clickOnBtn(sender.tag)
    }
    
}
