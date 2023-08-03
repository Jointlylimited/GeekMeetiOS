//
//  ProfileInterestCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 20/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class ProfileInterestCell: UITableViewCell {

    typealias ButtonClickEvent = (_ title : String?) -> Void
    var clickOnBtnNext : ButtonClickEvent!
    
    @IBOutlet var lblInterest: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnInterestAction(_ sender: UIButton) {
        self.clickOnBtnNext(lblInterest[sender.tag].text)
    }
    
}
