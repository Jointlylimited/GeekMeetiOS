
//
//  GradientView.swift
//
//  Created by SOTSYS038 on 21/09/18.
//  Copyright © 2018 SOTSYS203. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable

class GradientView: UIView {
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
        let layer = self.layer as! CAGradientLayer
        layer.cornerRadius = 3
        layer.colors = [firstColor, thirdColor].map {$0.cgColor}
        layer.startPoint = isHorizontal ? CGPoint(x: 0, y: 0.5) : CGPoint(x: 0.5, y: 0)
        layer.endPoint = isHorizontal ? CGPoint (x: 1, y: 0.5) : CGPoint (x: 0.5, y: 0.85)
    }
    
}

