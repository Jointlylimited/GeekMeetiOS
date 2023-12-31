//
//  LoginPresenter.swift
//  Basecode
//
//  Created by SOTSYS203 on 19/02/18.
//  Copyright (c) 2018 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LoginPresentationProtocol {
    func callLoginRequest(loginParams : Dictionary<String, String>)
    func getLoginResponse(userData : BaseModel?)
    
    func callSignUp()
    func callForgetPassword()
}

class LoginPresenter: LoginPresentationProtocol {
    weak var viewController: LoginProtocol?
    var interactor: LoginInteractorProtocol?
    
    // MARK: Present something
    func callLoginRequest(loginParams : Dictionary<String, String>) {
        if self.validateLogin(param: loginParams) {
            self.interactor?.callLoginApi(params : loginParams)
        }
    }
    
    func validateLogin(param : Dictionary<String, Any>) -> Bool {
        
        if String(describing: param["vEmailId"]).isEmpty {
            self.viewController?.displayAlert(strTitle: "", strMessage: kEnterEmail)
            return false
        } else if String(describing: param["vEmailId"]!).isEmail == false {
            self.viewController?.displayAlert(strTitle: "", strMessage: kEnterValidEmail)
            return false
        }
        
        if String(describing: param["vPassword"]).isEmpty {
            self.viewController?.displayAlert(strTitle: "", strMessage: kEnterPassword)
            return false
        } else if String(describing: param["vPassword"]!).length < 8  {
            self.viewController?.displayAlert(strTitle: "", strMessage: kPasswordWeak)
            return false
        }
        
        return true
    }
    
    func getLoginResponse(userData : BaseModel?) {
        print("present something")
        //You can go to the same Viewcontroller with data
        //self.viewController?.displaySomething()
        if userData != nil {
//            let mainBoard = UIStoryboard(name: "Main", bundle: nil)
//            let objFeed = mainBoard.instantiateViewController(withIdentifier: "SOIFeedViewController") as! SOIFeedViewController
//            objFeed.objUserData = userData
//            if let view = self.viewController as? UIViewController {
//                view.navigationController?.pushViewController(objFeed, animated: true)
//            }
        } else {
            self.viewController?.displayAlert(strTitle: "", strMessage: (userData?.responseMessage)!)
        }
    }
    
    func callSignUp() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let objLogin = mainStoryboard.instantiateViewController(withIdentifier: "SignUpViewController")
        if let view = self.viewController as? UIViewController {
            view.navigationController?.pushViewController(objLogin, animated: true)
        }
    }
    
    func callForgetPassword() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let objLogin = mainStoryboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController")
        if let view = self.viewController as? UIViewController {
            view.navigationController?.pushViewController(objLogin, animated: true)
        }
    }
}
