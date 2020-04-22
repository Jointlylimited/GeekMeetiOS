//
//  SignUpVCViewController.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 17/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SignUpVCProtocol: class {
    func displaySomething()
}

class SignUpVCViewController: UIViewController, SignUpVCProtocol {
    //var interactor : SignUpVCInteractorProtocol?
    var presenter : SignUpVCPresentationProtocol?
    
  @IBOutlet weak var tfEmailAddress: UITextField!
  @IBOutlet weak var tfPassword: UITextField!
  @IBOutlet weak var tfConfirmPassword: UITextField!
  @IBOutlet weak var tfMobileNumber: UITextField!
  @IBOutlet weak var btnContinue: UIButton!
  @IBOutlet weak var btnCountrycode: UIButton!
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
        let interactor = SignUpVCInteractor()
        let presenter = SignUpVCPresenter()
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
       self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething() {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
            self.navigationItem.leftBarButtonItem = leftSideBackBarButton
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            btnContinue.applyGradient(colors: AppCommonColor.gredientColor)
            tfEmailAddress.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
            tfPassword.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
            tfConfirmPassword.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
            tfMobileNumber.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
      
    }
  
    func displaySomething() {
        //nameTextField.text = viewModel.name
      
    }
  
    func setCountryPickerData(_ country : Country)
      {
        
          btnCountrycode.setTitle(country.dialingCode, for: .normal)
//          btnCountryCode.setImage(country.flag?.resizeImage(targetSize:  CGSize(width: btnCountryCode.frame.height / 2, height: btnCountryCode.frame.height / 2)).withRenderingMode(.alwaysOriginal), for: .normal)
      }
  //MARK: IBAction Method
  
  @IBAction func actionContinue(_ sender: Any) {
    
    self.presenter?.actionContinue()
  }
  
  
  @IBAction func actionSelectCountryCode(_ sender: Any) {
        CountryPickerWithSectionViewController.presentController(on: self) { (country: Country) in
                        self.setCountryPickerData(country)
                    }
  }
  @IBAction func btnPasswordShowHideClick(_ sender : UIButton)
     {
         sender.isSelected = !sender.isSelected
         tfPassword.isSecureTextEntry = !sender.isSelected
     }
  @IBAction func btnConfirmPasswordShowHideClick(_ sender : UIButton)
     {
         sender.isSelected = !sender.isSelected
         tfConfirmPassword.isSecureTextEntry = !sender.isSelected
     }
}
