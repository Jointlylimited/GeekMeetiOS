//
//  PhotoEmojiCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 20/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class PhotoEmojiCell: UICollectionViewCell {

    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var emojiStackView: UIStackView!
    @IBOutlet weak var btnClose: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func btnCloseAction(_ sender: UIButton) {
    }
}
