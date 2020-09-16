//
//  SelectSocialMediaCell.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 24/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import Foundation
import UIKit
protocol SelectSocialMediaDelegate{
   
    func actionSelectSocialMedia(at index:IndexPath)
}

class SelectSocialMediaCell: UICollectionViewCell {
    
    var delegate:SelectSocialMediaDelegate!
    var indexPath:IndexPath!
    
    @IBOutlet weak var btnSelectSocialMedia: UIButton!
    
    @IBAction func actionSelectSocialMedia(_ sender: UIButton) {
        self.delegate?.actionSelectSocialMedia(at: indexPath)
    }
}
