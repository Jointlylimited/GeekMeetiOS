//
//  RangeSlider.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 30/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

protocol TextSizeSelectDelegate {
    func selectTextSize(size : CGFloat)
}

class RangeSlider : UIControl {
    
    var slider = UIImageView()
    var Thumb = UIImageView()
    var sliderView = UISlider()
    var delegate : TextSizeSelectDelegate!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        slider = UIImageView(image: UIImage(named: "icn_indicator"))
        slider.frame = self.bounds
        self.addSubview(slider)
        
        sliderView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        sliderView.frame = slider.bounds
        sliderView.maximumTrackTintColor = .clear
        sliderView.minimumTrackTintColor = .clear
        sliderView.minimumValue = 0
        sliderView.maximumValue = 20
        sliderView.addTarget(self, action: #selector(changeVlaue(_:)), for: .valueChanged)
        self.addSubview(sliderView)
        
        sliderView.setThumbImage(#imageLiteral(resourceName: "icn_circle"), for: .normal)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func changeVlaue(_ sender: UISlider) {
        let textSize = CGFloat(sender.value + 18)
        print("value is" ,textSize)
        self.delegate.selectTextSize(size: textSize)
    }
}
