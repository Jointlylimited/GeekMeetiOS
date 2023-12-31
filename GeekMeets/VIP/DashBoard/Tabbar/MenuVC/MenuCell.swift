//
//  MenuCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 20/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    typealias ButtonClickEvent = () -> Void
    var clickOnSwitchBtn : ButtonClickEvent!
    
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnRight: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnRightAction(_ sender: UIButton) {
        self.clickOnSwitchBtn!()
    }
    
}
