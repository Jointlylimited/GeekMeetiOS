//
//  SearchListCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 27/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class SearchListCell: UITableViewCell {

    typealias ClickEvent = () -> Void
    var clickOnCloseBtn : ClickEvent!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.clickOnCloseBtn!()
    }
}
