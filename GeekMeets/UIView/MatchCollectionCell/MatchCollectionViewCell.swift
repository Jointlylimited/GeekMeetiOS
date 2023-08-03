//
//  MatchCollectionViewCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 25/09/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class MatchCollectionViewCell: UICollectionViewCell {

    typealias UnMatchEvent = () -> Void
    var clickOnUnMatchButton : UnMatchEvent!
    
    typealias ChatEvent = () -> Void
    var clickOnChat : ChatEvent!
    
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnUnMatch: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func btnUnMatchAction(_ sender: UIButton) {
        self.clickOnUnMatchButton!()
    }
    
    @IBAction func btnSendMsgAction(_ sender: UIButton) {
        self.clickOnChat!()
    }
}
