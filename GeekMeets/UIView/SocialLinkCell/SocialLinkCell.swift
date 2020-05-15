//
//  SocialLinkCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 15/05/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class SocialLinkCell: UITableViewCell {

    @IBOutlet weak var btnTitle: UIButton!
    @IBOutlet weak var txtSocialLink: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
