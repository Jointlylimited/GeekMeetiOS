//
//  SelectGenderCell.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 24/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import Foundation
import UIKit
protocol SelectGenderDelegate{
   
    func actionSelectGender(at index:IndexPath)
}

class SelectGenderCell: UICollectionViewCell {

      var delegate:SelectGenderDelegate!
      var indexPath:IndexPath!
  
      @IBOutlet weak var btnSelectGender: UIButton!
      @IBAction func actionSelectGender(_ sender: UIButton) {
          
          self.delegate?.actionSelectGender(at: indexPath)
          
      }
    
}
