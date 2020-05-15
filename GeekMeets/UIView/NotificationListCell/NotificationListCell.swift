//
//  NotificationListCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 15/05/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class NotificationListCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
