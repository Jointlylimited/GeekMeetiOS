//
//  Cell_ChatList.swift
//  xmppchat
//
//  Created by SOTSYS255 on 07/01/20.
//  Copyright © 2020 SOTSYS255. All rights reserved.
//

import UIKit

class Cell_ChatList: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblLastMsg: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
