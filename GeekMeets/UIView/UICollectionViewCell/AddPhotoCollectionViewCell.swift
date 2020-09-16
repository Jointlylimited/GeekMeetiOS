//
//  AddPhotoCell.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 21/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import Foundation
import UIKit

protocol OptionButtonsDelegate{
    func closeFriendsTapped(at index:IndexPath)
    func actionRemoveIMG(at index:IndexPath)
}

class AddPhotoCollectionViewCell: UICollectionViewCell {
    
    var delegate:OptionButtonsDelegate!
    @IBOutlet weak var closeFriendsBtn: UIButton!
    var indexPath:IndexPath!
    @IBAction func actionAddImg(_ sender: UIButton) {
        self.delegate?.closeFriendsTapped(at: indexPath)
    }
    
    @IBAction func actionRemoveImg(_ sender: UIButton) {
        self.delegate?.actionRemoveIMG(at: indexPath)
    }
    
    @IBOutlet weak var btnAddImg: UIButton!
    @IBOutlet weak var btnRemoveImg: UIButton!
    @IBOutlet weak var imgPhotos: UIImageView!
}
