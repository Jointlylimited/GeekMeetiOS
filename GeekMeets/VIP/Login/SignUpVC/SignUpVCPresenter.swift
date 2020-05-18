//
//  SignUpVCPresenter.swift
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

protocol SignUpVCPresentationProtocol {
    
    func callSignUpRequest(signUpParams : Dictionary<String, String>)
    func getEmailAvailResponse(response : UserAuthResponse)
    func getNormalSignupResponse(response : UserAuthResponse)
}

class SignUpVCPresenter: SignUpVCPresentationProtocol {
    weak var viewController: SignUpVCProtocol?
    var interactor: SignUpVCInteractorProtocol?
    var signUpParams : Dictionary<String, String>?
    
    func callSignUpRequest(signUpParams : Dictionary<String, String>){
        if validateSignUpParams(param: signUpParams) {
            self.signUpParams = signUpParams
            self.interactor?.callEmailAvailabilityAPI(email : signUpParams["vEmail"]!)
//            self.actionContinue(signUpParams : signUpParams)
        }
    }
    
    func validateSignUpParams(param : Dictionary<String, String>) -> Bool {
        let Password = String(describing: param["vPassword"]!)
        let ConfirmPassword = String(describing: param["vConfirmPassword"]!)
        if String(describing: param["vEmail"]!).isEmpty {
            self.viewController?.displayAlert(strTitle: "", strMessage: kEnterEmail)
            return false
        } else if !String(describing: param["vEmail"]!).isEmail {
            self.viewController?.displayAlert(strTitle: "", strMessage: kEnterValidEmail)
            return false
        }
        
        if String(describing: param["vPassword"]!).isEmpty {
            self.viewController?.displayAlert(strTitle: "", strMessage: kEnterPassword)
            return false
        } else if !Password.isPassword  {
            self.viewController?.displayAlert(strTitle: "", strMessage: kPasswordWeak)
            return false
        }
        
        if String(describing: param["vConfirmPassword"]!).isEmpty {
            self.viewController?.displayAlert(strTitle: "", strMessage: kEnterConfirmPassword)
            return false
        } else if !ConfirmPassword.isPassword {
            self.viewController?.displayAlert(strTitle: "", strMessage: kConfirmPasswordWeak)
            return false
        }
        
        if param["vPassword"] as! String != param["vConfirmPassword"] as! String {
            self.viewController?.displayAlert(strTitle: "", strMessage: kPasswordNotMatch)
            return false
        }
        
        if String(describing: param["vCountryCode"]!).isEmpty {
            self.viewController?.displayAlert(strTitle: "", strMessage: kSelectCountryCode)
            return false
        }
        
        if String(describing: param["vPhone"]!).isEmpty {
            self.viewController?.displayAlert(strTitle: "", strMessage: KEnterMobileNo)
            return false
        }else if !String(describing: param["vPhone"]!).isMobileNumber {
            self.viewController?.displayAlert(strTitle: "", strMessage: KEnterValidMobileNo)
            return false
        }
        
        if param["termsChecked"]! == "0" {
            self.viewController?.displayAlert(strTitle: "", strMessage: kSelectTerms)
            return false
        }
        
        return true
    }
  
    func getEmailAvailResponse(response : UserAuthResponse) {
        if response.responseCode == 200 {
            UserDataModel.currentUser = response.responseData
            self.actionContinue(signUpParams: self.signUpParams!)
        }
    }
    
    func actionContinue(signUpParams : Dictionary<String, String>) {
        if signUpParams["vSocialId"]! == "" {
            self.interactor?.callNormalSignupAPI(params : signUpParams)
        } else {
            let controller = GeekMeets_StoryBoard.LoginSignUp.instantiateViewController(withIdentifier: GeekMeets_ViewController.UserProfile) as! UserProfileViewController
            controller.signUpParams = signUpParams
            if let view = self.viewController as? UIViewController
            {
                view.pushVC(controller)
            }
        }
    }
    
    func getNormalSignupResponse(response : UserAuthResponse) {
        UserDataModel.currentUser = response.responseData
        if response.responseCode == 200 {
            self.goToOTPScreen()
        }
    }
    func goToOTPScreen(){
        let controller = GeekMeets_StoryBoard.LoginSignUp.instantiateViewController(withIdentifier: GeekMeets_ViewController.OTPEnter) as? OTPEnterViewController
        controller?.signUpParams = signUpParams
        if let view = self.viewController as? UIViewController
        {
            view.pushVC(controller!)
        }
    }
}
