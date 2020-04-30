//
//  ColorCollCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 30/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class ColorCollCell: UICollectionViewCell {

    typealias ColorClickEvent = () -> Void
    var clickOnColorBtn : ColorClickEvent!
    
    @IBOutlet weak var btnViewColor: UIButton!
    @IBOutlet weak var viewBorder: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.btnViewColor.cornerRadius = self.frame.width/2
//        self.viewBorder.cornerRadius = (self.frame.width + 2)/2
        // Initialization code
    }
    @IBAction func btnSelectColor(_ sender: UIButton) {
        self.clickOnColorBtn!()
    }
}
