//
//  CustomAlertView.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 24/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

protocol AlertViewDelegate: NSObjectProtocol {
    func OkButton()
    func cancelButton()
}

class CustomAlertView: UIView {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnRight: GradientButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var viewRight: UIView!
    
    weak var delegate: AlertViewDelegate?
    
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
    
    class func initAlertView(title: String, message: String, btnRightStr: String, btnCancelStr: String) -> CustomAlertView {
        let view = Bundle.main.loadNibNamed("CustomAlertView", owner: nil, options: nil)?.first as! CustomAlertView
//        view.viewCancel.dropShadow()
//        view.viewRight.dropShadow()
        view.prepareUI(title: title, message: message, btnRightStr : btnRightStr, btnCancelStr: btnCancelStr)
        
        view.layoutIfNeeded()
        return view
    }
    
    func prepareUI(title: String, message: String, btnRightStr : String, btnCancelStr: String) {

        let attributedStr1 = NSAttributedString(string: btnRightStr) // .color(UIColor.hexStringToUIColor(hexStr: "F2F2F2"))
        let attributedStr2 = NSAttributedString(string:btnCancelStr)
        
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
        delegate?.cancelButton()
    }
    
    @IBAction func btnOkAction(_ sender: UIButton) {
        delegate?.OkButton()
    }
}
