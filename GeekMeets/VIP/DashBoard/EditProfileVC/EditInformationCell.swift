//
//  EditInformationCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 22/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class EditInformationCell: UITableViewCell {

    @IBOutlet weak var txtAbout: UITextField!
    @IBOutlet weak var txtDoB: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtCompanyDetail: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
