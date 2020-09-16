//
//  SelectCategories.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 24/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import Foundation
import UIKit
protocol SelectCategoriesDelegate{
   
    func actionSelectCategories(at index:IndexPath)
}

class SelectCategoriesCell: UICollectionViewCell {
    
    var delegate:SelectCategoriesDelegate!
    var indexPath:IndexPath!
    
    @IBOutlet weak var btnSelectCategories: UIButton!
    
    @IBAction func actionSelectCategories(_ sender: UIButton) {
        self.delegate?.actionSelectCategories(at: indexPath)
    }
}
