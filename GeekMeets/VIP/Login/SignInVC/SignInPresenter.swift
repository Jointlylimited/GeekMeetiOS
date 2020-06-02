//
//  SignInPresenter.swift
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

protocol SignInPresentationProtocol
{
    func callSignInAPI(_ userName : String, password : String)
    func getSignInResponse(response : UserAuthResponse)
    func getPrefernceResponse(response : PreferencesResponse)
    
    func actionForgotPassword()
    func gotoHomeScreen()
}

class SignInPresenter: SignInPresentationProtocol {
    weak var viewController: SignInProtocol?
    var interactor: SignInInteractorProtocol?
    
    //MARK:- API Calling
    func callSignInAPI(_ userName: String, password: String)
    {
        if validateSignInRequest(userName, password: password)
        {
            self.interactor?.callSignInAPI(userName, password: password)
        }
    }
    
    func validateSignInRequest(_ userName : String, password : String) -> Bool
    {
        if userName.isEmpty
        {
            self.viewController?.displayAlert(strTitle: "", strMessage: kEnterEmail)
            return false
        }
        if password.isEmpty
        {
            self.viewController?.displayAlert(strTitle: "", strMessage: kEnterPassword)
            return false
        }
        return true
    }
    
    func getSignInResponse(response : UserAuthResponse)
    {
        UserDataModel.currentUser = response.responseData
        UserDataModel.setAuthKey(key: (response.responseData?.vAuthKey)!)
        
        if response.responseCode == 200 {
//            let controller = GeekMeets_StoryBoard.Questionnaire.instantiateViewController(withIdentifier: GeekMeets_ViewController.SelectAgeRange)
//            if let view = self.viewController as? UIViewController
//            {
//                view.pushVC(controller)
//            }
            self.callPreferenceAPI()
        } else if response.responseCode == 203 {
            let controller = GeekMeets_StoryBoard.LoginSignUp.instantiateViewController(withIdentifier: GeekMeets_ViewController.OTPEnter)
            if let view = self.viewController as? UIViewController
            {
                view.pushVC(controller)
            }
        } else {
            self.viewController?.displayAlert(strTitle: "", strMessage: response.responseMessage!)
        }
    }
    
    func callPreferenceAPI(){
        self.interactor?.callQuestionaryAPI()
    }
    
    func getPrefernceResponse(response : PreferencesResponse){
        if response.responseCode == 200 {
            UserDataModel.UserPreferenceResponse = response
             AppSingleton.sharedInstance().showHomeVC(fromMatch : false)
        }
    }
    
    func actionForgotPassword() {
        let controller = GeekMeets_StoryBoard.LoginSignUp.instantiateViewController(withIdentifier: GeekMeets_ViewController.ForgotPassword)
        if let view = self.viewController as? UIViewController
        {
            view.pushVC(controller)
        }
    }
    
    func gotoHomeScreen(){
        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.TabbarScreen)
        if let view = self.viewController as? UIViewController
        {
            view.pushVC(controller)
        }
    }
}
