//
//  SelectTextTypeCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 27/05/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class SelectTextTypeCell: UICollectionViewCell {
    
    typealias TextClickEvent = () -> Void
    var clickOnText : TextClickEvent!
    
    @IBOutlet weak var btnText: UIButton!
    
    
    @IBAction func btnTextClick(_ sender: UIButton) {
        self.clickOnText!()
    }
}
