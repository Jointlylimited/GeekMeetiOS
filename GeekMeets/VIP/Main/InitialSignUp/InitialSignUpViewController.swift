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
import Alamofire

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
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var btnStackLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnSTackTrailingConstraint: NSLayoutConstraint!
    
    let clientId = ""
    let clientSecret = ""
    let redirectUri = ""
    var InstaAccessToken : String?
    var InstaUserID : String?
    var isSuccssess : Bool = false


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
        
         if #available(iOS 13.0, *) {
            self.btnApple.alpha = 1.0
            self.btnStackLeadingConstraint.constant = 20
            self.btnSTackTrailingConstraint.constant = 20
         } else {
            self.btnApple.alpha = 0.0
            self.btnStackLeadingConstraint.constant = 100
            self.btnSTackTrailingConstraint.constant = 100
        }
    }
    
    func setTheme() {
//        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().clientID = "784959084971-42nkai7mqrspe87v6euc5gfe5d77uodi.apps.googleusercontent.com"
//        GIDSignIn.sharedInstance()?.presentingViewController = self

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

//        let objConfig = SOGoogleConfig(self)
//        objConfig.delegate = self

            self.presenter?.actionLogin()
       /* } else {
          //   GIDSignIn.sharedInstance().signIn()
        }*/
      
    }
    @IBAction func actionFacebookSignUp(_ sender: Any) {
        if !NetworkReachabilityManager.init()!.isReachable{
            AppSingleton.sharedInstance().showAlert(NoInternetConnection, okTitle: "OK")
            return
        }
        self.presenter?.callFBLogin()
    }
    
    @IBAction func actionInstagramSignUp(_ sender: Any) {
        if !NetworkReachabilityManager.init()!.isReachable{
            AppSingleton.sharedInstance().showAlert(NoInternetConnection, okTitle: "OK")
            return
        }
        let instaVC = GeekMeets_StoryBoard.Main.instantiateViewController(withIdentifier: GeekMeets_ViewController.InstagramLoginScreen) as! InstagramLoginVC
        instaVC.isFromEditProfile = false
        instaVC.delegate = self
        self.presentVC(instaVC)
    }
    
    @IBAction func actionSnapchatSignUp(_ sender: Any) {
        if !NetworkReachabilityManager.init()!.isReachable{
            AppSingleton.sharedInstance().showAlert(NoInternetConnection, okTitle: "OK")
            return
        }
        self.presenter?.callSnapchatLoginRequest(objLoginVC : self)
    }
    @IBAction func actionAppleSignUp(_ sender: Any) {
        if !NetworkReachabilityManager.init()!.isReachable{
            AppSingleton.sharedInstance().showAlert(NoInternetConnection, okTitle: "OK")
            return
        }
        self.handleAppleIdRequest()
    }
    
    private func setupInstagramSignIn()
    {
        
        if InstaUserID == nil && InstaAccessToken == nil
        {
            let instagramAuthViewController = InstagramLoginVC(clientId: clientId, clientSecret: clientSecret, redirectUri: redirectUri)
            instagramAuthViewController.delegate = self
            let navController = UINavigationController(rootViewController: instagramAuthViewController)
            present(navController, animated: true)
        }
        else
        {
            if let ID = InstaUserID
            {
//                fetchInstaPhoto(strUrl: "https://graph.instagram.com/\(ID)/media?fields=id,caption,media_url,media_type&access_token=\(InstaAccessToken!)", accessToken: InstaAccessToken!, strPageToken: "")
            }
        }
    }
    
    @objc func handleAppleIdRequest() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
            performExistingAccountSetupFlows()
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func performExistingAccountSetupFlows() {
        if let userIdentifier = UserDefaults.standard.object(forKey: "userIdentifier1") as? String {
            if #available(iOS 13.0, *) {
                let authorizationProvider = ASAuthorizationAppleIDProvider()
                authorizationProvider.getCredentialState(forUserID: userIdentifier) { (state, error) in
                    switch (state) {
                    case .authorized:
                        print("Account Found - Signed In")
                        DispatchQueue.main.async {

                        }
                        break
                    case .revoked:
                        print("No Account Found")
                        fallthrough
                    case .notFound:
                        print("No Account Found")
                        DispatchQueue.main.async {
                            
                        }
                    default:
                        break
                    }
                }
            } else {
                // Fallback on earlier versions
            }
            
        }
           
       }
}

extension InitialSignUpViewController: InstagramAuthDelegate {
    func instagramAuthControllerDidFinish(accessToken: String?,id: String?, error: Error?, mediaData: NSArray){
        if let error = error {
            print("Error logging in to Instagram: \(error.localizedDescription)")
            
        } else {
            isSuccssess = true
            InstaAccessToken = accessToken!
            InstaUserID = id
            print("Access token: \(accessToken!)")
            let signupModel = SignUpUserModel(email: "", password: "", confirmpassword: "", mobile: "", countryCode: "", firstName: "", lastName: "", phone: "", birthday: "")
            UserDataModel.SignUpUserResponse = signupModel
            
            Authentication.setInstagramIntegrationStatus(true)
            UserDefaults.standard.set(mediaData, forKey: "InstagramPhotosModel")
            
            let param = RequestParameter.sharedInstance().socialSigninParams(tiSocialType: "3", accessKey: accessToken!, service: "Instagram")
            self.presenter?.callSignInForAppleAPI(params: param)
        }
    }
}

extension InitialSignUpViewController : ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // return the current view window
        return self.view.window!
    }
}

extension InitialSignUpViewController : ASAuthorizationControllerDelegate {
    
    // ASAuthorizationControllerDelegate function for successful authorization
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let userFirstName = appleIDCredential.fullName?.givenName
            let userLastName = appleIDCredential.fullName?.familyName
            let userEmail = appleIDCredential.email
            
            let defaults = UserDefaults.standard
            defaults.set(userIdentifier, forKey: "userIdentifier1")
              
            //Save the UserIdentifier somewhere in your server/database
            let signupModel = SignUpUserModel(email: userEmail, password: "", confirmpassword: "", mobile: "", countryCode: "", firstName: userFirstName, lastName: userLastName, phone: "", birthday: "")
            UserDataModel.SignUpUserResponse = signupModel
            
            let param = RequestParameter.sharedInstance().socialSigninParams(tiSocialType: "5", accessKey: userIdentifier, service: "Apple")
            self.presenter?.callSignInForAppleAPI(params: param)

            //Navigate to other view controller
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            //Navigate to other view controller
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //Handle error here
        print("Sign In Error : \(error.localizedDescription)")
    }
}

extension InitialSignUpViewController : InstagramAuthenticationDelegate {
    func fetchAuthToken(token: String) {
        print(token)
    }
}

extension InitialSignUpViewController : GoogleManagerDelegate {
    func receiveResponse(user: GIDGoogleUser?, error: Error?) {
        if (error == nil){

            print(user?.authentication)
            print(user?.profile?.givenName)
            print(user?.profile?.familyName)
            print(user?.profile?.email)

            guard let objUser = user else {return}

            let param = RequestParameter.sharedInstance().googleSigninParams(tiSocialType : "2", accessKey: objUser.authentication.accessToken, service: "google", vUserName: objUser.profile?.givenName ?? "", vEmailId: objUser.profile?.email ?? "", vSocialId: objUser.userID ?? "0", vImageUrl: objUser.profile?.imageURL(withDimension: 120)?.absoluteString ?? "")

            self.presenter?.callGoogleSigninAPI(loginParams: param)
        }
        else {
            print("\(error?.localizedDescription)")
        }
    }

//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//
//        //        LoaderView.sharedInstance.hideLoader()
//        if (error == nil){
//
//            print(user.authentication)
//            print(user.profile.givenName)
//            print(user.profile.familyName)
//            print(user.profile.email)
//
//            let param = RequestParameter.sharedInstance().googleSigninParams(tiSocialType : "2", accessKey: user.authentication.accessToken, service: "google", vUserName: user.profile.givenName, vEmailId: user.profile.email, vSocialId: user.userID, vImageUrl: user.profile.imageURL(withDimension: 120).absoluteString)
//
//            self.presenter?.callGoogleSigninAPI(loginParams: param)
//        }
//        else {
//            print("\(error.localizedDescription)")
//        }
//    }
//
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
////        LoaderView.sharedInstance.hideLoader()
//        print(error?.localizedDescription ?? "")
//    }
}