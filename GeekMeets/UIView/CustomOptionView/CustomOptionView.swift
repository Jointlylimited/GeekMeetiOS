//
//  CustomOptionView.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 28/05/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

protocol CustomOptionViewDelegate: NSObjectProtocol {
    func OptionButtonAction(index : Int)
}

class CustomOptionView: UIView {

    @IBOutlet weak var btnUnMatch: UIButton!
    @IBOutlet weak var btnClearChat: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnBlock: UIButton!
    @IBOutlet weak var btnReport: UIButton!
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var BtnStackView: UIStackView!
    
    weak var delegate: CustomOptionViewDelegate?
    
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
    
    class func initAlertView() -> CustomOptionView {
        let view = Bundle.main.loadNibNamed("CustomOptionView", owner: nil, options: nil)?.first as! CustomOptionView
//        view.viewCancel.dropShadow()
//        view.viewRight.dropShadow()
//        view.prepareUI()
        
        view.layoutIfNeeded()
        return view
    }
    
//    func prepareUI(title: String, message: String, btnRightStr : String, btnCancelStr: String, btnCenter : String, isSingleButton : Bool) {
//
//        if isSingleButton {
//            self.BtnStackView.alpha = 0
////            self.viewCentre.alpha = 1
//        } else {
////            self.viewCentre.alpha = 0
//            self.BtnStackView.alpha = 1
//        }
////        lblTitle.text = title
////        lblDesc.text = message
//
////        self.btnRight.setTitle(btnRightStr, for: .normal)
//        self.btnCancel.setTitle(btnCancelStr, for: .normal)
//
//    }
}

extension CustomOptionView {
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func btnUnmatchAction(_ sender: UIButton) {
        delegate?.OptionButtonAction(index: sender.tag)
    }
    
    @IBAction func btnClearChatAction(_ sender: UIButton) {
        delegate?.OptionButtonAction(index: sender.tag)
    }
    
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        delegate?.OptionButtonAction(index: sender.tag)
    }
    
    @IBAction func btnBlockAction(_ sender: UIButton) {
        delegate?.OptionButtonAction(index: sender.tag)
    }
    
    @IBAction func btnReportAction(_ sender: UIButton) {
        delegate?.OptionButtonAction(index: sender.tag)
    }
}
