//
//  CustomTextView.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 30/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class CustomTextView : UIView {
    
    var text : String = ""
    var color : UIColor = .clear
    var viewSize : CGSize = CGSize(width: 0, height: 0)
    var attributeDict : NSDictionary = [:]
    var attributedString : NSAttributedString = NSAttributedString(string: "")
    var fontSize : CGFloat = 0
    var font : UIFont!
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
    }
    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func initwithFrame(frame : CGRect, text : String, color : UIColor, size : CGSize, fontSize : CGFloat, font : UIFont){
        self.frame = frame
        self.text = text
        self.color = color
        self.viewSize = size
        self.font = font
    }
    
    func initwithView(view1 : CustomTextView) -> CustomTextView{
        var view = self
        view.attributedString = view1.attributedString
        view.attributeDict = view1.attributeDict
        view.text = view1.text
        view.color = view1.color
        view.viewSize = view1.viewSize
        view.fontSize = view1.fontSize
        view.font = view1.font
        view = view1
        return view
    }
}
