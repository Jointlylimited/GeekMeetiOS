//
//  EditSocialLinkCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 22/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class EditSocialLinkCell: UITableViewCell {

    @IBOutlet weak var txtInstagramLink: UITextField!
    @IBOutlet weak var txtSnapchatLink: UITextField!
    @IBOutlet weak var txtFacebookLink: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
