//
//  MyCustomTextField.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 23/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import Foundation
import UIKit

class MyCustomTextField: UITextField
{
  override init(frame: CGRect) {
       super.init(frame: frame)

   }
   required init?(coder aDecoder: NSCoder)
   {
       super.init(coder: aDecoder)
    
           self.Initialize()

       
  }
  
  
  func Initialize()
  {
    
      var bottomLine = CALayer()
      bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
      bottomLine.backgroundColor = UIColor.white.cgColor
      self.borderStyle = UITextField.BorderStyle.none
      self.layer.addSublayer(bottomLine)
    
  }
  
  
  
}
