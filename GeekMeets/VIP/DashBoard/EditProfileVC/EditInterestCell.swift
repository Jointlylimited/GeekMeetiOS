//
//  EditInterestCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 22/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class EditInterestCell: UITableViewCell {

    @IBOutlet weak var txtInterestAge: UITextField!
    @IBOutlet weak var txtInterestGender: UITextField!
    @IBOutlet weak var txtLikedSocialPlatform: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
