//
//  EditProfilePrivacyCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 22/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class EditProfilePrivacyCell: UITableViewCell {

    typealias SwitchClickEvent = (_ index : Int?) -> Void
    var clickOnBtnSwitch : SwitchClickEvent!
    
    @IBOutlet var btnSwichMode : [UIButton]!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnSwitchAction(_ sender: UIButton) {
        self.clickOnBtnSwitch(sender.tag)
    }
    
}
