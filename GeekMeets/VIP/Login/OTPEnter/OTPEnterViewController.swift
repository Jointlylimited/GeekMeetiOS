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
    func getVerifyOTPResponse(response : UserAuthResponse)
    func getResendOTPResponse(response : CommonResponse)
    func getNewVerifyOTPResponse(response : UserAuthResponse)
}

class OTPEnterViewController: UIViewController, OTPEnterProtocol {
    
    
    //var interactor : OTPEnterInteractorProtocol?
    var presenter : OTPEnterPresentationProtocol?
    
    @IBOutlet weak var tfOTP1: BottomBorderTF!
    @IBOutlet weak var tfOTP2: BottomBorderTF!
    @IBOutlet weak var tfOTP3: BottomBorderTF!
    @IBOutlet weak var tfOTP4: BottomBorderTF!
    @IBOutlet weak var tfOTP5: BottomBorderTF!
    @IBOutlet weak var tfOTP6: BottomBorderTF!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnVerifyOTP: GradientButton!
    @IBOutlet weak var otpContainerView: UIView!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var tfMobileNumber: UITextField!
    @IBOutlet weak var btnCountrycode: UIButton!
    
    
    let otpStackView = OTPStackView()
    var isFromNewMobile : Bool = false
    var alertView: CustomAlertView!
    var timer: Timer?
    var totalTime = 300
    var signUpParams : Dictionary<String, String>?
    
    var strCountryCode: String = UserDataModel.currentUser?.vCountryCode ?? "+91"
    var strPhonenumber: String? = UserDataModel.currentUser?.vPhone ?? "756713373"
    var strNewCountryCode : String = ""
    var strNewPhoneNumber : String = ""
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isFromNewMobile {
            self.navigationController?.isNavigationBarHidden = true
        } else {
            self.navigationController?.isNavigationBarHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !isFromNewMobile {
            self.navigationController?.isNavigationBarHidden = false
        } else {
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    
    func doSomething() {
        print(signUpParams)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = leftSideBackBarButton
        let range = (btnResend!.currentTitle! as NSString).range(of: "Resend")
        let attributedString = NSMutableAttributedString(string:(btnResend?.currentTitle)!)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppCommonColor.pinkColor , range: range)
        btnResend?.setAttributedTitle(attributedString, for: .normal)
        
        btnVerifyOTP.isHidden = true
        otpContainerView.addSubview(otpStackView)
        otpStackView.delegate = self
        otpStackView.heightAnchor.constraint(equalTo: otpContainerView.heightAnchor).isActive = true
        otpStackView.centerXAnchor.constraint(equalTo: otpContainerView.centerXAnchor).isActive = true
        otpStackView.centerYAnchor.constraint(equalTo: otpContainerView.centerYAnchor).isActive = true
        
        if !isFromNewMobile {
            strCountryCode = signUpParams!["vCountryCode"]!
            strPhonenumber = signUpParams!["vPhone"]!
            startTimer()
        } else {
            strCountryCode = strNewCountryCode
            strPhonenumber = strNewPhoneNumber
        }
        btnCountrycode.setTitle(strCountryCode, for: .normal)
        tfMobileNumber.text = "\(strCountryCode) \(strPhonenumber ?? "")"
        btnCountrycode.isUserInteractionEnabled = false
        tfMobileNumber.isUserInteractionEnabled = false
        
        
    }
    
    func displaySomething() {
        //nameTextField.text = viewModel.name
    }
    
    
    
    private func startTimer() {
        self.totalTime = 60
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        self.lblTime.text = self.timeFormatted(self.totalTime) // will show timer
        if totalTime != 0 {
            totalTime -= 1
        } else {
            if let timer = self.timer {
                self.btnResend.isUserInteractionEnabled = true
                
                timer.invalidate()
                self.timer = nil
            }
        }
    }
    
    func stopTimer(){
        if self.timer != nil {
            timer!.invalidate()
        }
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    @IBAction func actionEditMobileNumber(_ sender: Any) {
        self.popVC()
        /*  displayAlert(strTitle : "", strMessage : "Now you can Edit phone number")
         btnCountrycode.isUserInteractionEnabled = true
         tfMobileNumber.isUserInteractionEnabled = true*/
        
    }
    
    @IBAction func actionSelectCountryCode(_ sender: Any) {
        CountryPickerWithSectionViewController.presentController(on: self) { (country: Country) in
            self.setCountryPickerData(country)
        }
    }
    
    func setCountryPickerData(_ country : Country)
    {
        strCountryCode = country.dialingCode!
        btnCountrycode.setTitle(country.dialingCode, for: .normal)
        //          btnCountryCode.setImage(country.flag?.resizeImage(targetSize:  CGSize(width: btnCountryCode.frame.height / 2, height: btnCountryCode.frame.height / 2)).withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    @IBAction func actionVerifyOTP(_ sender: Any) {
        btnCountrycode.isUserInteractionEnabled = false
        tfMobileNumber.isUserInteractionEnabled = false
        if !isFromNewMobile {
            //        strPhonenumber = tfMobileNumber.text
            print("Final OTP : ",otpStackView.getOTP())
            otpStackView.setAllFieldColor(isWarningColor: true, color: .yellow)
            self.presenter?.callVerifyOTPAPI(iOTP : otpStackView.getOTP(),vCountryCode : strCountryCode,vPhone : strPhonenumber ?? "7567173373", signUpParams : signUpParams)
            
        } else {
            self.presenter?.callResendOTPAPI(vCountryCode : strCountryCode ,vPhone : strPhonenumber ?? "7567173373")
            startTimer()
            otpStackView.setAllFieldColor(isWarningColor: true, color: .yellow)
            self.presenter?.callNewVerifyOTPAPI(iOTP : otpStackView.getOTP(),vCountryCode : strCountryCode,vPhone : strPhonenumber ?? "7567173373")
        }
    }
    
    @IBAction func btnResendOTP(_ sender : UIButton)
    {
        btnCountrycode.isUserInteractionEnabled = false
        tfMobileNumber.isUserInteractionEnabled = false
        //      strPhonenumber = tfMobileNumber.text
        otpStackView.clearTextField()
        self.presenter?.callResendOTPAPI(vCountryCode : strCountryCode ,vPhone : strPhonenumber ?? "7567173373")
    }
    
    func displayAlert(strTitle : String, strMessage : String) {
        //nameTextField.text = viewModel.name
        self.showAlert(title: strTitle, message: strMessage)
    }
}

extension OTPEnterViewController: OTPDelegate {
    
    func didChangeValidity(isValid: Bool) {
        btnVerifyOTP.isHidden = !isValid
    }
    
}

extension OTPEnterViewController {
    func showAlertView() {
        alertView = CustomAlertView.initAlertView(title: "Successful", message: "Your mobile is changed & verified Successfully", btnRightStr: "", btnCancelStr: "", btnCenter: "OK", isSingleButton: true)
        alertView.delegate1 = self
        alertView.frame = self.view.frame
        self.view.addSubview(alertView)
    }
    
    func getVerifyOTPResponse(response : UserAuthResponse) {
        self.displayAlert(strTitle: "", strMessage: response.responseMessage!)
    }
    
    func getResendOTPResponse(response: CommonResponse) {
        if response.responseCode == 200  {
            startTimer()
            btnResend.isUserInteractionEnabled = false
        }
        self.displayAlert(strTitle: "", strMessage: response.responseMessage!)
    }
    
    func getNewVerifyOTPResponse(response : UserAuthResponse) {
        if response.responseCode == 200 {
            UserDataModel.currentUser = response.responseData
            self.navigationController?.isNavigationBarHidden = true
            self.showAlertView()
        } else {
            self.displayAlert(strTitle: "", strMessage: response.responseMessage!)
        }
    }
}

extension OTPEnterViewController : AlertViewCentreButtonDelegate {
    
    func centerButtonAction(){
        let accVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.AccountSettingScreen)
        self.pop(toLast: accVC.classForCoder)
    }
}
