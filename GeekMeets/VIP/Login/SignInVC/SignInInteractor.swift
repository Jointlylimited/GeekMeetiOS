//
//  SignInInteractor.swift
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

protocol SignInInteractorProtocol
{
    func callSignInAPI(_ userName : String, password : String)
    func callQuestionaryAPI()
    func callVerifyEmailAPI(email : String)
    func callPushStatusAPI()
}

class SignInInteractor: SignInInteractorProtocol {
    var presenter: SignInPresentationProtocol?
    //var name: String = ""
    
    // MARK: Do something
    func callSignInAPI(_ userName : String, password : String)
    {
        LoaderView.sharedInstance.showLoader()
        UserAPI.signIn(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, vEmail: userName, vPassword: password, vTimeOffset: vTimeOffset, vTimeZone: vTimeZone, vDeviceToken: vDeviceToken, tiDeviceType: UserAPI.TiDeviceType_signIn(rawValue: 1)!, vDeviceName: vDeviceName, vDeviceUniqueId: vDeviceUniqueId!, vApiVersion: vApiVersion, vAppVersion: vAppVersion, vOsVersion: vOSVersion, vIpAddress: vIPAddress) { (response, error) in

            delay(0.2) {
                LoaderView.sharedInstance.hideLoader()
            }
            
            if response?.responseCode == 200 {
                self.presenter?.getSignInResponse(response : response!)
            } else if response?.responseCode == 203 {
                self.presenter?.getSignInResponse(response : response!)
            } else if response?.responseCode == 401 {
                self.presenter?.getSignInResponse(response : response!)
            } else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
                }
            }
        }
    }
    
    func callQuestionaryAPI() {
//        LoaderView.sharedInstance.showLoader()
        PreferencesAPI.list(nonce: authToken.nonce, timestamp: Int(authToken.timeStamp)!, token: authToken.token, language: APPLANGUAGE.english, authorization: UserDataModel.authorization) { (response, error) in
            
//            LoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.presenter?.getPrefernceResponse(response : response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
            } else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
                }
            }
            
        }
    }
    
    func callVerifyEmailAPI(email : String){
        LoaderView.sharedInstance.showLoader()
        UserAPI.requestForEmail(nonce: authToken.nonce, timestamp: Int(authToken.timeStamp)!, token: authToken.token, language: APPLANGUAGE.english, vEmail: email) { (response, error) in
            
            delay(0.2) {
                LoaderView.sharedInstance.hideLoader()
            }
            
            if response?.responseCode == 200 {
                self.presenter?.getEmailVerifyResponse(response : response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
            } else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
                }
            }
        }
    }
    
    func callPushStatusAPI() {
            DispatchQueue.main.async {
    //            LoaderView.sharedInstance.showLoader()
            }
            
        UserAPI.setPushStatus(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization, vDeviceToken: AppDelObj.deviceToken, tiIsAcceptPush: UserDataModel.getPushStatus()) { (response, error) in
                DispatchQueue.main.async {
    //                LoaderView.sharedInstance.hideLoader()
                }
                if response?.responseCode == 200 {
                    self.presenter?.getPushStatusResponse(response : response!)
                } else if response?.responseCode == 203 {
                    AppSingleton.sharedInstance().logout()
                    AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
                } else {
                    if error != nil {
                        AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                    } else {
                        self.presenter?.getPushStatusResponse(response : response!)
                    }
                }
            }
        }
}
