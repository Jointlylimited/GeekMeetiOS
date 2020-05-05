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
}

class SignUpVCPresenter: SignUpVCPresentationProtocol {
    weak var viewController: SignUpVCProtocol?
    var interactor: SignUpVCInteractorProtocol?
    
    func callSignUpRequest(signUpParams : Dictionary<String, String>){
        if validateSignUpParams(param: signUpParams) {
            self.actionContinue(signUpParams : signUpParams)
        }
    }
    
    func validateSignUpParams(param : Dictionary<String, String>) -> Bool {
        
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
        } else if String(describing: param["vPassword"]!).length < 6  {
            self.viewController?.displayAlert(strTitle: "", strMessage: kPasswordWeak)
            return false
        }
        
        if String(describing: param["vConfirmPassword"]!).isEmpty {
            self.viewController?.displayAlert(strTitle: "", strMessage: kEnterConfirmPassword)
            return false
        } else if String(describing: param["vConfirmPassword"]!).length < 6  {
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
        }
        
        if param["termsChecked"]! == "0" {
            self.viewController?.displayAlert(strTitle: "", strMessage: kSelectTerms)
            return false
        }
        
        return true
    }
  
    func actionContinue(signUpParams : Dictionary<String, String>) {
        let controller = GeekMeets_StoryBoard.LoginSignUp.instantiateViewController(withIdentifier: GeekMeets_ViewController.UserProfile) as! UserProfileViewController
        controller.signUpParams = signUpParams
        if let view = self.viewController as? UIViewController
        {
            view.pushVC(controller)
        }
    }
}
