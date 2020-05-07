//
//  EditInterestCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 22/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class EditInterestCell: UITableViewCell {

    typealias ChangeInterestAgeClickEvent = () -> Void
    var clickOnChangeInterestAge : ChangeInterestAgeClickEvent!
    
    typealias ChangeInterestGenderClickEvent = () -> Void
    var clickOnChangeInterestGender : ChangeInterestGenderClickEvent!
    
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

    @IBAction func btnChangeInterestAgeAction(_ sender: UIButton) {
        self.clickOnChangeInterestAge!()
    }
    @IBAction func btnChangeInterestGenderAction(_ sender: UIButton) {
        self.clickOnChangeInterestGender!()
    }
}
