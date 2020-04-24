//
//  ReactEmojiCollectionCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 21/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class ReactEmojiCollectionCell: UICollectionViewCell {

    typealias LikeClickEvent = () -> Void
    var clickOnLikeBtn : LikeClickEvent!
    
    typealias BtnKissClickEvent = () -> Void
       var clickOnbtnKiss : BtnKissClickEvent!
    
    typealias BtnLoveClickEvent = () -> Void
       var clickOnbtnLove : BtnLoveClickEvent!
    
    typealias BtnLoveSmileClickEvent = () -> Void
       var clickOnbtnLoveSmile : BtnLoveSmileClickEvent!
    
    @IBOutlet weak var emojiStackView: UIStackView!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var ReactEmojiView: UIView!
    
    @IBOutlet weak var btnLike: UIButton!
    
    @IBOutlet weak var btnKissValue: UIButton!
    @IBOutlet weak var btnLoveValue: UIButton!
    @IBOutlet weak var btnLoveSmileValue: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func btnLikeAction(_ sender: UIButton) {
        self.clickOnLikeBtn!()
    }
    @IBAction func btnKissAction(_ sender: UIButton) {
        self.clickOnbtnKiss!()
    }
    @IBAction func btnLoveAction(_ sender: UIButton) {
        self.clickOnbtnLove!()
    }
    @IBAction func btnLoveSmileAction(_ sender: UIButton) {
        self.clickOnbtnLoveSmile!()
    }
}
