//
//  InitialSignUpViewController.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 15/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import AuthenticationServices

protocol InitialSignUpProtocol: class {
}

class InitialSignUpViewController: UIViewController, InitialSignUpProtocol {
    //var interactor : InitialSignUpInteractorProtocol?
    var presenter : InitialSignUpPresentationProtocol?
    
    @IBOutlet weak var btnSignUpWithGoogle: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnInstagram: UIButton!
    @IBOutlet weak var btnSnapchat: UIButton!
    @IBOutlet weak var btnApple: UIButton!
    
    @IBOutlet weak var lblPrivacyTerm: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    
    
    // MARK: Object lifecycle
    
    let objConfig = SOGoogleConfig()
    
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
        let interactor = InitialSignUpInteractor()
        let presenter = InitialSignUpPresenter()
        
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
        setUpUI()
        setTheme()
    }

    func setUpUI(){
        self.btnSignUpWithGoogle.titleEdgeInsets = DeviceType.iPhoneXRMax || DeviceType.iPhoneX ? UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0) : UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        self.btnFacebook.titleEdgeInsets = DeviceType.iPhoneXRMax || DeviceType.iPhoneX ? UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0) : UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        self.btnSnapchat.titleEdgeInsets = DeviceType.iPhoneXRMax || DeviceType.iPhoneX ? UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0) : UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        self.btnInstagram.titleEdgeInsets = DeviceType.iPhoneXRMax || DeviceType.iPhoneX ? UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0) : UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        self.btnApple.titleEdgeInsets = DeviceType.iPhoneXRMax || DeviceType.iPhoneX ? UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0) : UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    func setTheme() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "1058883482858-feo3v537akjippp47hcq8cs80ed3q8ti.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        setupMultipleTapLabel()
        
        //Facebook Logout
        let loginManager = LoginManager()
        loginManager.logOut()
        AccessToken.current = nil
    }

    func setupMultipleTapLabel() {
          lblPrivacyTerm.text = "By clicking sign up, you agree to our Terms. Learn how weprocess your data in our privacy policy & Cookie Privacy"
          let text = (lblPrivacyTerm.text)!
          let underlineAttriString = NSMutableAttributedString(string: text)
          let range1 = (text as NSString).range(of: "Terms")
//          underlineAttriString.addAttribute(.foregroundColor, value: UIColor.blue, range: range1)
          underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
          let range2 = (text as NSString).range(of: "privacy policy")
          underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range2)
          let range3 = (text as NSString).range(of: "Cookie Privacy")
          underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range3)
          lblPrivacyTerm.attributedText = underlineAttriString
          let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
          lblPrivacyTerm.isUserInteractionEnabled = true
          lblPrivacyTerm.addGestureRecognizer(tapAction)
      }
  
     // MARK:- IBAction Method
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
      
        let text = (lblPrivacyTerm.text)!
        let termsRange = (text as NSString).range(of: "Terms")
        let privacyRange = (text as NSString).range(of: "privacy policy")

        if gesture.didTapAttributedTextInLabel(label: lblPrivacyTerm, inRange: termsRange) {
            print("Terms of service")
          
        } else if gesture.didTapAttributedTextInLabel(label: lblPrivacyTerm, inRange: privacyRange) {
            print("Privacy policy")
        }
      
  }
}

//MARK: IBAction Methods

extension  InitialSignUpViewController{
    @IBAction func btnLoginAction(_ sender: UIButton) {
        if sender.titleLabel?.text == "Login" {
            self.btnLogin.setTitle("Sign Up", for: .normal)
            self.btnSignUpWithGoogle.setTitle("Login with Google", for: .normal)
        } else {
            self.presenter?.actionSignUp()
        }
    }
    
    @IBAction func actionGoogleSignUp(_ sender: UIButton) {
        if self.btnLogin.titleLabel?.text != "Login" {
            self.presenter?.actionLogin()
        } else {
             GIDSignIn.sharedInstance().signIn()
        }
    }
    @IBAction func actionFacebookSignUp(_ sender: Any) {
        self.presenter?.callFBLogin()
    }
    @IBAction func actionInstagramSignUp(_ sender: Any) {
        
    }
    @IBAction func actionSnapchatSignUp(_ sender: Any) {
        self.presenter?.callSnapchatLoginRequest(objLoginVC : self)
    }
    @IBAction func actionAppleSignUp(_ sender: Any) {
        
    }
}


extension InitialSignUpViewController : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        //        LoaderView.sharedInstance.hideLoader()
        
        if (error == nil) {
            
            print(user.authentication)
            print(user.profile.givenName)
            print(user.profile.familyName)
            print(user.profile.email)
                        
            let param = RequestParameter.sharedInstance().googleSigninParams(tiSocialType : "2", accessKey: user.authentication.accessToken, service: "google", vUserName: user.profile.givenName, vEmailId: user.profile.email, vSocialId: user.userID, vImageUrl: user.profile.imageURL(withDimension: 120).absoluteString)
            
            self.presenter?.callGoogleSigninAPI(loginParams: param)
        }
        else {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//        LoaderView.sharedInstance.hideLoader()
        print(error?.localizedDescription ?? "")
    }
}
