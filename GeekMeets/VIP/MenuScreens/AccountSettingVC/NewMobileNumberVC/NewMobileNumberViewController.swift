//
//  NewMobileNumberViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 29/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol NewMobileNumberProtocol: class {
    func getResendOTPResponse(response: CommonResponse)
}

class NewMobileNumberViewController: UIViewController, NewMobileNumberProtocol {
    //var interactor : NewMobileNumberInteractorProtocol?
    var presenter : NewMobileNumberPresentationProtocol?
    
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var txtMobNo: UITextField!
    
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
        let interactor = NewMobileNumberInteractor()
        let presenter = NewMobileNumberPresenter()
        
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
        setData()
    }

    func setData(){
        self.txtCountryCode.text = UserDataModel.currentUser?.vCountryCode ?? ""
        self.txtMobNo.text = UserDataModel.currentUser?.vPhone ?? ""
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func btnSelectCountryAction(_ sender: UIButton) {
        CountryPickerWithSectionViewController.presentController(on: self) { (country: Country) in
            self.setCountryPickerData(country)
        }
    }
    
    @IBAction func btnContinueAction(_ sender: GradientButton) {
        
        if self.txtCountryCode.text!.isEmpty {
            AppSingleton.sharedInstance().showAlert(kSelectCountryCode, okTitle: "OK")
            return
        }
        
        if self.txtMobNo.text!.isEmpty {
            AppSingleton.sharedInstance().showAlert(KEnterMobileNo, okTitle: "OK")
            return
        }else if !self.txtMobNo.text!.isMobileNumber {
            AppSingleton.sharedInstance().showAlert(KEnterValidMobileNo, okTitle: "OK")
            return
        }
        self.presenter?.callResendOTPAPI(vCountryCode : self.txtCountryCode.text ?? "" ,vPhone : self.txtMobNo.text ?? "")
    }
    
    func getResendOTPResponse(response: CommonResponse){
        if response.responseCode == 200 {
            let otpVC = GeekMeets_StoryBoard.LoginSignUp.instantiateViewController(withIdentifier: GeekMeets_ViewController.OTPEnter) as! OTPEnterViewController
            otpVC.isFromNewMobile = true
            otpVC.strNewCountryCode = self.txtCountryCode.text ?? ""
            otpVC.strNewPhoneNumber = self.txtMobNo.text ?? ""
            self.pushVC(otpVC)
        } else {
            AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle: "OK")
        }
    }
}

extension NewMobileNumberViewController {
    func setCountryPickerData(_ country : Country)
    {
        self.txtCountryCode.text = country.dialingCode
    }
}
