//
//  ChatBubbleView.swift
//  xmppchat
//
//  Created by SOTSYS255 on 29/01/20.
//  Copyright © 2020 SOTSYS255. All rights reserved.
//

import Foundation

import UIKit

class ChatBubbleView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        layer.cornerRadius = 10.0
     //   layer.masksToBounds = true
        
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layoutSubviews()
    }
}


