//
//  OTPEnterViewController.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 21/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol OTPEnterProtocol: class {
    func displaySomething()
}

class OTPEnterViewController: UIViewController, OTPEnterProtocol {
    //var interactor : OTPEnterInteractorProtocol?
    var presenter : OTPEnterPresentationProtocol?
    
    @IBOutlet weak var tfOTP1: UITextField!
    @IBOutlet weak var tfOTP2: UITextField!
    @IBOutlet weak var tfOTP3: UITextField!
    @IBOutlet weak var tfOTP4: UITextField!
    @IBOutlet weak var tfOTP5: UITextField!
    @IBOutlet weak var tfOTP6: UITextField!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnVerifyOTP: UIButton!
  // MARK: Object lifecycle
    
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
        let interactor = OTPEnterInteractor()
        let presenter = OTPEnterPresenter()
        
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
        doSomething()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething() {
            self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.leftBarButtonItem = leftSideBackBarButton
            let range = (btnResend!.currentTitle! as NSString).range(of: "Resend")
                       let attributedString = NSMutableAttributedString(string:(btnResend?.currentTitle)!)
                       attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppCommonColor.pinkColor , range: range)
                       btnResend?.setAttributedTitle(attributedString, for: .normal)
              btnVerifyOTP.applyGradient(colors: AppCommonColor.gredientColor)
            tfOTP1.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
            tfOTP2.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
            tfOTP3.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
            tfOTP4.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
            tfOTP5.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
            tfOTP6.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
    }
    
    func displaySomething() {
        //nameTextField.text = viewModel.name
    }
  
  @IBAction func actionVerifyOTP(_ sender: Any) {
    
  }
}
