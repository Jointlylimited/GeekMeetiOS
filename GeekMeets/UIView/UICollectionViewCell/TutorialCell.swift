//
//  File.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 14/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import Foundation
import UIKit

class TutorialCell: UICollectionViewCell
{
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblDescription : UILabel!
    @IBOutlet var imgView : UIImageView!
    
    var tutorialData : TutorialData?{
        didSet{
            self.lblTitle.text = tutorialData?.pageTitle
            self.lblDescription.text = tutorialData?.pageDescription
            self.imgView.image = tutorialData?.pageImage
        }
    }
}
