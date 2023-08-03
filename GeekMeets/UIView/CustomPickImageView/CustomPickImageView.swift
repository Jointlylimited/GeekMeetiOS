//
//  CustomPickImageView.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 28/05/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

protocol PickImageViewDelegate: NSObjectProtocol {
    func CameraButtonAction()
    func GifButtonAction()
    func LocationButtonAction()
}

class CustomPickImageView: UIView {

    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnGif: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var viewGif: UIView!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var BtnStackView: UIStackView!
    
    weak var delegate: PickImageViewDelegate?
    
    init(){
      super.init(frame: .zero)
      self.commonInit()
    }
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      self.commonInit()
    }
    
    func commonInit(){
      self.frame = self.bounds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let view = touches.first?.view {
            //            self.removeFromSuperview()
        }
    }
    
    class func initAlertView() -> CustomPickImageView {
        let view = Bundle.main.loadNibNamed("CustomPickImageView", owner: nil, options: nil)?.first as! CustomPickImageView

        view.layoutIfNeeded()
        return view
    }
}

extension CustomPickImageView {
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    @IBAction func btnCameraAction(_ sender: UIButton) {
        delegate?.CameraButtonAction()
    }
    @IBAction func btnGifAction(_ sender: UIButton) {
        delegate?.GifButtonAction()
    }
    @IBAction func btnLocationAction(_ sender: UIButton) {
        delegate?.LocationButtonAction()
    }
}
