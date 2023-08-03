//
//  InitialLoginViewController.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 16/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoogleSignIn


protocol InitialLoginProtocol: class {
}

class InitialLoginViewController: UIViewController, InitialLoginProtocol {
    //var interactor : InitialLoginInteractorProtocol?
    var presenter : InitialLoginPresentationProtocol?
    @IBOutlet weak var lblPrivacyTerm: UILabel!
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
        let interactor = InitialLoginInteractor()
        let presenter = InitialLoginPresenter()
        
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
        setTheme()
    }
    
    func setTheme() {
        
//        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().clientID = "1058883482858-feo3v537akjippp47hcq8cs80ed3q8ti.apps.googleusercontent.com"
//        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        setupMultipleTapLabel()
        //        // Automatically sign in the user.
        //        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    func setupMultipleTapLabel() {
        lblPrivacyTerm.text = "By clicking sign up, you agree to our Terms. Learn how weprocess your data in our privacy policy & Cookie Privacy"
        let text = (lblPrivacyTerm.text)!
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "Terms")
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
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        
        let text = (lblPrivacyTerm.text)!
        let termsRange = (text as NSString).range(of: "Terms")
        let privacyRange = (text as NSString).range(of: "privacy policy")
        
        if gesture.didTapAttributedTextInLabel(label: lblPrivacyTerm, inRange: termsRange) {
            print("Terms of service")
        } else if gesture.didTapAttributedTextInLabel(label: lblPrivacyTerm, inRange: privacyRange) {
            print("Privacy policy")
        }
    }
    
    // MARK: IBAction Method
    @IBAction func actionGmailSignup(_ sender: Any) {
//        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func actionFacebookSignup(_ sender: Any){
        self.presenter?.callFacebookLoginRequest(objLoginVC : self)
    }
    
    @IBAction func actionSignup(_ sender: Any) {
        self.presenter?.actionSignUp()
    }
    
    @IBAction func actionSignIn(_ sender: Any) {
        self.presenter?.actionSignIn()
    }
    
    @IBAction func actionSnapChatSignUp(_ sender: Any) {
        self.presenter?.callSnapchatLoginRequest(objLoginVC : self)
    }
}

//extension InitialLoginViewController : GIDSignInDelegate{
//
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
//              withError error: Error!) {
//
//        if let error = error {
//            print("\(error.localizedDescription)")
//        } else {
//            // Perform any operations on signed in user here.
//            // ...
//            let params = RequestParameter.sharedInstance().socialLoginParam(accessToken: user.authentication.accessToken, service: "google")
//            self.presenter?.callSocialLoginRequest(loginParams: params)
//        }
//    }
//
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
//              withError error: Error!) {
//        // Perform any operations when the user disconnects from app here.
//        // ...
//    }
//}