//
//  RecommandedProfileView.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 15/05/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

protocol RecommandedProfileViewDelegate: NSObjectProtocol {
    func SetProfileButtonAction()
    func NoButtonAction()
}

class RecommandedProfileView: UIView {

    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var btnSetAsProfile: GradientButton!
    @IBOutlet weak var btnNoThanks: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnCloseView: UIButton!
    
    weak var delegate: RecommandedProfileViewDelegate?
    
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
    
    class func initAlertView(imgString : String) -> RecommandedProfileView {
        
        let view = Bundle.main.loadNibNamed("RecommandedProfileView", owner: nil, options: nil)?.first as! RecommandedProfileView
        if imgString != "" {
            let url = URL(string:"\(fileUploadURL)\(user_Profile)\(imgString)")
            print(url!)
            view.imgProfile.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "Image 64"))
        }
        
        view.layoutIfNeeded()
        return view
    }
    
  
}

extension RecommandedProfileView {
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
          self.removeFromSuperview()
      }
      
      @IBAction func btnSetProfileAction(_ sender: UIButton) {
        delegate?.SetProfileButtonAction()
      }
      
      @IBAction func btnNoThanksAction(_ sender: UIButton) {
          delegate?.NoButtonAction()
      }
}
