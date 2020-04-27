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


class BottomBorderTF: UITextField {

var bottomBorder = UIView()
override func awakeFromNib() {

    //MARK: Setup Bottom-Border
    self.translatesAutoresizingMaskIntoConstraints = false
    bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    bottomBorder.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
    bottomBorder.translatesAutoresizingMaskIntoConstraints = false
    addSubview(bottomBorder)
    //Mark: Setup Anchors
    bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    bottomBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    bottomBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
  bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true // Set Border-Strength
   }
}
