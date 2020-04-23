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
    
    @IBOutlet weak var emojiStackView: UIStackView!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var ReactEmojiView: UIView!
    
    @IBOutlet weak var btnLike: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func btnLikeAction(_ sender: UIButton) {
        self.clickOnLikeBtn!()
    }
}
