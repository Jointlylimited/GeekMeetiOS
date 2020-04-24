//
//  File.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 24/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import Foundation
import UIKit
protocol SelectAgeDelegate{
   
    func actionSelectAge(at index:IndexPath)
}

class SelectAgeCell: UICollectionViewCell {

      var delegate:SelectAgeDelegate!
      var indexPath:IndexPath!
  
      @IBOutlet weak var btnSelectAge: UIButton!
      @IBAction func actionSelectAge(_ sender: UIButton) {
          
          self.delegate?.actionSelectAge(at: indexPath)
          
      }
    
}

