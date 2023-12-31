//
//  SignInViewController.swift
//  NearByEventPlan
//
//  Created by Hiren Gohel on 10/01/19.
//  Copyright (c) 2019 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Crashlytics

//MARK:- Protocol and Method
protocol SignInProtocol: class{
    func displayAlert(strTitle : String, strMessage : String)
    func getLoginResponse(res : UserAuthResponse)
}

//MARK:-
class SignInViewController: UIViewController,SignInProtocol
{
    //var interactor : SignInInteractorProtocol?
    var presenter : SignInPresentationProtocol?
    
    @IBOutlet weak var tfEmail : BottomBorderTF!
    @IBOutlet weak var tfPassword : BottomBorderTF!
    @IBOutlet weak var btnSignUp : UIButton?
    @IBOutlet weak var btnForgot: UIButton!
    @IBOutlet weak var btnSignIn: GradientButton!
    
    var alertView: CustomAlertView!
    
    // MARK:- Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK:- Setup
    private func setup() {
        let viewController = self
        let interactor = SignInInteractor()
        let presenter = SignInPresenter()
        
        //View Controller will communicate with only presenter
        viewController.presenter = presenter
        //viewController.interactor = interactor
        
        //Presenter will communicate with Interector and Viewcontroller
        presenter.viewController = viewController
        presenter.interactor = interactor
        
        //Interactor will communucate with only presenter.
        interactor.presenter = presenter
    }
    
    // MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
    }
    
    func setTheme(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationItem.leftBarButtonItem = leftSideBackBarButton
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        let range = (btnSignUp!.currentTitle! as NSString).range(of: "Sign Up")
        let attributedString = NSMutableAttributedString(string:(btnSignUp?.currentTitle)!)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppCommonColor.pinkColor , range: range)
        btnSignUp?.setAttributedTitle(attributedString, for: .normal)
        btnSignUp?.addTarget(self, action:#selector(clickOnSignUpBtn) , for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool){
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func displayAlert(strTitle : String, strMessage : String) {
        self.showAlert(title: strTitle, message: strMessage)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @objc func clickOnSignUpBtn(){
        let controller = GeekMeets_StoryBoard.LoginSignUp.instantiateViewController(withIdentifier: GeekMeets_ViewController.SignUpScreen) as! SignUpVCViewController
        controller.socialType = false
        self.pushVC(controller)
    }
    
    func showAlertView() {
        alertView = CustomAlertView.initAlertView(title: kVerifyEmail, message: kNotVerifyMail, btnRightStr: kResendLink, btnCancelStr: kTitleCancel, btnCenter: "", isSingleButton: false)
        alertView.delegate = self
        alertView.frame = self.view.frame
        AppDelObj.window?.addSubview(alertView)
    }
    
    func getLoginResponse(res : UserAuthResponse) {
        if res.responseCode == 401 {
            self.showAlertView()
        }
    }
}

//MARK:- IBAction Method
extension SignInViewController
{
    @IBAction func btnSignInClick(_ sender : UIButton)
    {
//        DefaultLoaderView.sharedInstance.showLoader()
        self.presenter?.callSignInAPI(tfEmail.text ?? "", password: tfPassword.text ?? "")
    }
    
    @IBAction func btnForgotPWClick(_ sender : UIButton)
    {
        self.presenter?.actionForgotPassword()
    }
    
    @IBAction func btnPasswordShowHideClick(_ sender : UIButton)
    {
        sender.isSelected = !sender.isSelected
        tfPassword.isSecureTextEntry = !sender.isSelected
    }
}

//MARK: AlertView Delegate Methods
extension SignInViewController : AlertViewDelegate {
    func OkButtonAction(title : String) {
        alertView.alpha = 0.0
        self.presenter?.callVerifyEmailAPI(email : self.tfEmail.text ?? "")
    }
    
    func cancelButtonAction() {
        alertView.alpha = 0.0
    }
}
