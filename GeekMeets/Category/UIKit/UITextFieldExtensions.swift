//
//  UITextFieldExtensions.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 17/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.gray.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
  func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
         let border = CALayer()
         border.backgroundColor = color.cgColor
         border.frame = CGRect(x: 0, y: self.frame.size.height - width,
                               width: self.frame.size.width - 40, height: width)
         self.layer.addSublayer(border)
     }
}
extension UIButton
{
    func applyGradient(colors: [CGColor])
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = 5
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
extension UILabel
{
    func applyGradient(colors: [CGColor])
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = 5
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
