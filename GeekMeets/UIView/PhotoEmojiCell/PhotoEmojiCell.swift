//
//  PhotoEmojiCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 20/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class PhotoEmojiCell: UICollectionViewCell {

    typealias ImageClickEvent = () -> Void
    var clickOnImageButton : ImageClickEvent!
    
    typealias RemoveClickEvent = () -> Void
    var clickOnRemovePhoto : RemoveClickEvent!
    
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var emojiStackView: UIStackView!
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var btnKiss: UIButton!
    @IBOutlet weak var btnLove: UIButton!
    @IBOutlet weak var btnLoveSmile: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setImageInsets()
        // Initialization code
    }
    
    func setImageInsets(){
        if DeviceType.iPhone5orSE {
            self.btnKiss.imageEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
            self.btnLove.imageEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
            self.btnLoveSmile.imageEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
            
            self.btnKiss.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            self.btnLove.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            self.btnLoveSmile.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        } else {
            self.btnKiss.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            self.btnLove.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            self.btnLoveSmile.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            
            self.btnKiss.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
            self.btnLove.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
            self.btnLoveSmile.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        }
    }
    
    @IBAction func btnChooseImageAction(_ sender: UIButton) {
        self.clickOnImageButton!()
    }
    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.clickOnRemovePhoto!()
    }
}
