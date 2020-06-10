//
//  MatchViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 17/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MatchProtocol: class {
}

class MatchViewController: UIViewController, MatchProtocol {
    //var interactor : MatchInteractorProtocol?
    var presenter : MatchPresentationProtocol?
    
    // MARK: Object lifecycle
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var matchUserImgView: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var userImgWidthContraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeightConstant: NSLayoutConstraint!
    
    var UserDetails : UserAuthResponseField!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = MatchInteractor()
        let presenter = MatchPresenter()
        
        //View Controller will communicate with only presenter
        viewController.presenter = presenter
        //viewController.interactor = interactor
        
        //Presenter will communicate with Interector and Viewcontroller
        presenter.viewController = viewController
        presenter.interactor = interactor
        
        //Interactor will communucate with only presenter.
        interactor.presenter = presenter
    }
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        
        userImgWidthContraint.constant = ScreenSize.width/2 - 30
        viewHeightConstant.constant = userImgWidthContraint.constant
        stackViewHeightConstant.constant = DeviceType.iPhone5orSE ? 80 : 120
        
        self.matchUserImgView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/9))
        self.userImgView.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi/9))
        
        if UserDataModel.currentUser?.vProfileImage != "" {
            let url = URL(string:"\(UserDataModel.currentUser!.vProfileImage!)")
            print(url!)
            self.userImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_rect"))
        }
        if UserDetails != nil {
            self.lblDesc.text = "Wow, You and \(UserDetails.vName!) have liked each other"
            if UserDetails.vProfileImage != "" {
                let url = URL(string:"\(UserDetails.vProfileImage!)")
                print(url!)
                self.matchUserImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_rect"))
            }
        }
    }
    
    @IBAction func btnContinueSwippingAction(_ sender: UIButton) {
//        self.view.window!.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
        self.dismissVC {
            AppSingleton.sharedInstance().showHomeVC(fromMatch: false)
        }
    }
    @IBAction func btnSendMsgAction(_ sender: UIButton) {
        //        let tabVC = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.TabbarScreen) as! TabbarViewController
        //        tabVC.modalTransitionStyle = .crossDissolve
        //        tabVC.modalPresentationStyle = .overCurrentContext
        //        tabVC.isFromMatch = true
        //        self.presentVC(tabVC)
        self.dismissVC {
            AppSingleton.sharedInstance().showHomeVC(fromMatch: true)
        }
    }
}
