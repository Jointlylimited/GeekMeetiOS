//
//  GradientButton.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 22/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable

class GradientButton: UIButton {
    
    @IBInspectable var firstColor: UIColor = AppCommonColor.firstGradient {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var thirdColor: UIColor = AppCommonColor.secondGradient {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView()
    {
//        secondColor = firstColor.withAlphaComponent(0.7)
        let layer = self.layer as! CAGradientLayer
        // set the corner radius
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        layer.colors = [firstColor, thirdColor].map {$0.cgColor}
        layer.startPoint = isHorizontal ? CGPoint(x: 0, y: 1) /*CGPoint(x: 0, y: 0.5)*/ : CGPoint(x: 0.5, y: 0)
        layer.endPoint = isHorizontal ? CGPoint (x: 1, y: 1) /*CGPoint (x: 1, y: 0.5)*/ : CGPoint (x: 0.5, y: 0.85)
        
        // set the shadow properties
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 1
        layer.shadowRadius = 4.0
    }
    
}

