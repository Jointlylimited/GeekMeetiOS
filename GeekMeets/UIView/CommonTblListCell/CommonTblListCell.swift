//
//  CommonTblListCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 23/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class CommonTblListCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
