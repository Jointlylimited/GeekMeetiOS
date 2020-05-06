//
//  InitialSignUpPresenter.swift
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

protocol InitialSignUpPresentationProtocol {
    func actionSignUp()
    func actionLogin()
    
    func callFBLogin()
    func getFBResponse(response:SignupSocialDM)
    
    func callGoogleSigninAPI(loginParams : Dictionary<String, String>)
    
    func getLoginResponse(userData : UserAuthResponse?)
    func callSnapchatLoginRequest(objLoginVC : InitialSignUpViewController)
}

class InitialSignUpPresenter: InitialSignUpPresentationProtocol {
    weak var viewController: InitialSignUpProtocol?
    var interactor: InitialSignUpInteractorProtocol?
    
    func actionSignUp()
    {
        let controller = GeekMeets_StoryBoard.LoginSignUp.instantiateViewController(withIdentifier: GeekMeets_ViewController.SignUpScreen)
        if let view = self.viewController as? UIViewController
        {
            view.pushVC(controller)
        }
    }
    
    func actionLogin()
    {
        let controller = GeekMeets_StoryBoard.LoginSignUp.instantiateViewController(withIdentifier: GeekMeets_ViewController.SignInScreen)
        if let view = self.viewController as? UIViewController
        {
            view.pushVC(controller)
        }
    }
    
    func callFBLogin() {
        self.interactor?.callFBLogin()
    }
    
    func getFBResponse(response: SignupSocialDM) {
        print(response.email ?? "")
        print(response.firstName ?? "")
        print(response.token)
        
        let param = RequestParameter.sharedInstance().socialSigninParams(tiSocialType: "1", accessKey: response.token, service: "facebook")
        self.interactor?.callSocialSignInAPI(params: param)
    }

    func callGoogleSigninAPI(loginParams : Dictionary<String, String>) {
        self.interactor?.callSocialSignInAPI(params: loginParams)
    }
    
    func getLoginResponse(userData : UserAuthResponse?) {
        
    }
    
    func callSnapchatLoginRequest(objLoginVC : InitialSignUpViewController){
            
                self.interactor?.callSnapchatLogin(objLoginVC : objLoginVC)
            
          }
    
}
