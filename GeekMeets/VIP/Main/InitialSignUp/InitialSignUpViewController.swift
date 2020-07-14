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
import ActiveLabel

protocol InstagramAuthenticationDelegate {
    func fetchAuthToken(token : String)
}

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
    
    @IBOutlet weak var lblPrivacyTerm: ActiveLabel!
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
        GIDSignIn.sharedInstance().clientID = "784959084971-42nkai7mqrspe87v6euc5gfe5d77uodi.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        setLink()
        
        //Facebook Logout
        let loginManager = LoginManager()
        loginManager.logOut()
        AccessToken.current = nil
    }

    func setLink(){
        
        let customType = ActiveType.custom(pattern: "\\sTerms\\b")
        let customType1 = ActiveType.custom(pattern: "\\sPrivacy Policy\\b")
        let customType2 = ActiveType.custom(pattern: "\\sCookie Privacy\\b")
        
        lblPrivacyTerm.enabledTypes.append(customType)
        lblPrivacyTerm.enabledTypes.append(customType1)
        lblPrivacyTerm.enabledTypes.append(customType2)
        
        lblPrivacyTerm.customize { label in
          
            label.text = "By clicking sign up, you agree to our Terms. Learn how we process your data in our privacy policy & Cookie Privacy"
            label.numberOfLines = 3
            label.lineSpacing = 0
            
            label.textColor = UIColor.white
            
            label.customColor[customType] =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            label.customColor[customType1] =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            label.customColor[customType2] =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            label.highlightFontName = FontTypePoppins.Poppins_Medium.rawValue
            label.highlightFontSize = 12
            
            label.font = UIFont.init(name: FontTypePoppins.Poppins_Medium.rawValue, size: 12)
            
            label.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                atts[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.thick.rawValue
                return atts
            }
            
            label.handleCustomTap(for: customType) {_ in
                let commonVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.CommonPagesScreen) as! CommonPagesViewController
                commonVC.objCommonData = CommonModelData.Terms
                commonVC.slug = CommonModelData.Terms.slugTitle
                self.pushVC(commonVC)
            }
            
            label.handleCustomTap(for: customType1) {_ in
                let commonVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.CommonPagesScreen) as! CommonPagesViewController
                commonVC.objCommonData = CommonModelData.Privacy
                commonVC.slug = CommonModelData.Privacy.slugTitle
                self.pushVC(commonVC)
            }
            
            label.handleCustomTap(for: customType2) {_ in
                let commonVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.CommonPagesScreen) as! CommonPagesViewController
                commonVC.objCommonData = CommonModelData.Privacy
                commonVC.slug = CommonModelData.Privacy.slugTitle
                self.pushVC(commonVC)
            }
        }
    }
}

//MARK: IBAction Methods
extension  InitialSignUpViewController{
    @IBAction func btnLoginAction(_ sender: UIButton) {
        /*if sender.titleLabel?.text == "Login" {
            self.btnLogin.setTitle("Sign Up", for: .normal)
            self.btnSignUpWithGoogle.setTitle("Login", for: .normal)
        } else {*/
            self.presenter?.actionSignUp()
       // }
    }
    
    @IBAction func actionGoogleSignUp(_ sender: UIButton) {
       // if self.btnLogin.titleLabel?.text != "Login" {
            self.presenter?.actionLogin()
       /* } else {
          //   GIDSignIn.sharedInstance().signIn()
        }*/
      
    }
    @IBAction func actionFacebookSignUp(_ sender: Any) {
        self.presenter?.callFBLogin()
    }
    
    @IBAction func actionInstagramSignUp(_ sender: Any) {
        let instaVC = GeekMeets_StoryBoard.Main.instantiateViewController(withIdentifier: GeekMeets_ViewController.InstagramLoginScreen) as! InstagramLoginVC
        instaVC.delegate = self
        self.presentVC(instaVC)
    }
    
    @IBAction func actionSnapchatSignUp(_ sender: Any) {
        self.presenter?.callSnapchatLoginRequest(objLoginVC : self)
    }
    @IBAction func actionAppleSignUp(_ sender: Any) {
      
    }
}

extension InitialSignUpViewController : InstagramAuthenticationDelegate {
    func fetchAuthToken(token: String) {
        print(token)
    }
}

extension InitialSignUpViewController : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        //        LoaderView.sharedInstance.hideLoader()
        if (error == nil){
            
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
