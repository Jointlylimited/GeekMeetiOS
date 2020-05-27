//
//  CustomAlertView.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 24/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

protocol AlertViewDelegate: NSObjectProtocol {
    func OkButtonAction()
    func cancelButtonAction()
}

protocol AlertViewCentreButtonDelegate: NSObjectProtocol {
    func centerButtonAction()
}

class CustomAlertView: UIView {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnRight: GradientButton!
    @IBOutlet weak var btnCentre: GradientButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var viewRight: UIView!
    @IBOutlet weak var viewCentre: UIView!
    @IBOutlet weak var BtnStackView: UIStackView!
    
    weak var delegate: AlertViewDelegate?
    weak var delegate1: AlertViewCentreButtonDelegate?
    
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
    
    class func initAlertView(title: String, message: String, btnRightStr: String, btnCancelStr: String, btnCenter : String, isSingleButton : Bool) -> CustomAlertView {
        let view = Bundle.main.loadNibNamed("CustomAlertView", owner: nil, options: nil)?.first as! CustomAlertView
//        view.viewCancel.dropShadow()
//        view.viewRight.dropShadow()
        view.prepareUI(title: title, message: message, btnRightStr : btnRightStr, btnCancelStr: btnCancelStr, btnCenter : btnCenter, isSingleButton : isSingleButton)
        
        view.layoutIfNeeded()
        return view
    }
    
    func prepareUI(title: String, message: String, btnRightStr : String, btnCancelStr: String, btnCenter : String, isSingleButton : Bool) {
        
        if isSingleButton {
            self.BtnStackView.alpha = 0
            self.viewCentre.alpha = 1
        } else {
            self.viewCentre.alpha = 0
            self.BtnStackView.alpha = 1
        }
        lblTitle.text = title
        lblDesc.text = message
        
        self.btnRight.setTitle(btnRightStr, for: .normal)
        self.btnCancel.setTitle(btnCancelStr, for: .normal)
        
    }
}

extension CustomAlertView {
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
        delegate?.cancelButtonAction()
    }
    
    @IBAction func btnOkAction(_ sender: UIButton) {
        
        delegate?.OkButtonAction()
    }
    
    @IBAction func btnCentreAction(_ sender: UIButton) {
        delegate1?.centerButtonAction()
    }
}
