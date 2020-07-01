//
//  OTPEnterPresenter.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 21/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol OTPEnterPresentationProtocol {
    func presentSomething()
    func actionVerifyOTP()
    func callVerifyOTPAPI(iOTP : String,vCountryCode : String,vPhone : String, signUpParams : Dictionary<String, String>?)
    func getVerifyOTPResponse(response : UserAuthResponse)
    func getResendOTPResponse(response : CommonResponse)
    func callResendOTPAPI(vCountryCode : String,vPhone : String)
}

class OTPEnterPresenter: OTPEnterPresentationProtocol {
    
    weak var viewController: OTPEnterProtocol?
    var interactor: OTPEnterInteractorProtocol?
    var signParams : Dictionary<String, String>?
    
    // MARK: Present something
    func presentSomething() {
        
    }
    func callVerifyOTPAPI(iOTP : String,vCountryCode : String,vPhone : String, signUpParams : Dictionary<String, String>?) {
        self.signParams = signUpParams
        self.interactor?.callVerifyOTPAPI(iOTP : iOTP,vCountryCode : vCountryCode,vPhone : vPhone)
    }
    
    func callResendOTPAPI(vCountryCode: String, vPhone: String) {
        self.interactor?.callResendOTPAPI(vCountryCode: vCountryCode, vPhone: vPhone)
    }
    
    func actionVerifyOTP() {
        let controller = GeekMeets_StoryBoard.LoginSignUp.instantiateViewController(withIdentifier: GeekMeets_ViewController.UserProfile) as! UserProfileViewController
        controller.signUpParams = self.signParams
        if let view = self.viewController as? UIViewController
        {
            view.pushVC(controller)
        }
//        let controller = GeekMeets_StoryBoard.Questionnaire.instantiateViewController(withIdentifier: GeekMeets_ViewController.SelectAgeRange)
//        if let view = self.viewController as? UIViewController
//        {
//            view.pushVC(controller)
//        }
    }
    func getResendOTPResponse(response : CommonResponse) {
        
        
        self.viewController?.getResendOTPResponse(response: response)
        
    }
    func getVerifyOTPResponse(response : UserAuthResponse) {
        
        if response.responseCode == 400{
            self.viewController?.getVerifyOTPResponse(response: response)
        }else{
            Authentication.setSignUpFlowStatus(response.responseData!.tiStep!)
            //        self.viewController?.getForgotPasswordResponse(response: response)
            self.actionVerifyOTP()
            
        }
    }
    
}
