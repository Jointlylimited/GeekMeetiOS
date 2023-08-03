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
        
        var bottomBorder = UIView()
        self.translatesAutoresizingMaskIntoConstraints = false
         bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
         bottomBorder.backgroundColor = #colorLiteral(red: 0.606272161, green: 0.2928337753, blue: 0.8085166812, alpha: 1)
         bottomBorder.translatesAutoresizingMaskIntoConstraints = false
         addSubview(bottomBorder)
         //Mark: Setup Anchors
         bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
         bottomBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
         bottomBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
         bottomBorder.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
//        let bottomLine = CALayer()
//        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 5, width: self.frame.size.width, height: 5)
//        bottomLine.backgroundColor = AppCommonColor.firstGradient.cgColor
//        borderStyle = .none
//        layer.addSublayer(bottomLine)
    }
  func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
//         let border = CALayer()
//         border.backgroundColor = color.cgColor
//         border.frame = CGRect(x: 0, y: self.frame.size.height - width,
//                               width: self.frame.size.width , height: width)
//         self.layer.addSublayer(border)
     }
  func useUnderline() -> Void {
//    let border = CALayer()
//    let borderWidth = CGFloat(1.0) // Border Width
//    border.borderColor = UIColor.lightGray.cgColor
//    border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidth), size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
//    border.borderWidth = borderWidth
//    self.layer.addSublayer(border)
//    self.layer.masksToBounds = true
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
    
    func underlineButton(text: String, font : UIFont, color:UIColor) {
        let titleString = NSMutableAttributedString(string: "")
        let attrs = [
            NSAttributedString.Key.font : font,
        NSAttributedString.Key.foregroundColor : color,
        NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
        
        let buttonTitleStr = NSMutableAttributedString(string:text, attributes:attrs)
        titleString.append(buttonTitleStr)
        self.setAttributedTitle(titleString, for: .normal)
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
extension String {
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [NSStringDrawingOptions.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
