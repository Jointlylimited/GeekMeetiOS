//
//  MessageListCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 21/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class MessageListCell: UITableViewCell {

    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var msgText: UILabel!
    @IBOutlet weak var msgCount: GradientLabel!
    @IBOutlet weak var msgTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
