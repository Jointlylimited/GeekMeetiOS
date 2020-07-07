//
//  SignUpVCInteractor.swift
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

protocol SignUpVCInteractorProtocol {
    func callEmailAvailabilityAPI(email : String)
    func callNormalSignupAPI(params : Dictionary<String, String>, tiIsLocationOn : String)
}

protocol SignUpVCDataStore {
    //var name: String { get set }
}

class SignUpVCInteractor: SignUpVCInteractorProtocol, SignUpVCDataStore {
    var presenter: SignUpVCPresentationProtocol?
    
    // MARK: Do something
    func callEmailAvailabilityAPI(email : String) {
        LoaderView.sharedInstance.showLoader()
        UserAPI.checkEmailAvailability(nonce: authToken.nonce, timestamp: Int(authToken.timeStamp)!, token: authToken.token, language: APPLANGUAGE.english, vEmail: email) { (response, error) in
            
            LoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.presenter?.getEmailAvailResponse(response : response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
            } else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
                }
            }
        }
    }
    
    func callNormalSignupAPI(params : Dictionary<String, String>, tiIsLocationOn : String){
        let socialType = UserDataModel.getSocialType()
        let tiIsAcceptPush = UserDataModel.getPushStatus()
        
        if UserDataModel.currentUser!.tiIsAdmin == 1 {
            LoaderView.sharedInstance.showLoader()
            UserAPI.signUp(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, tiIsSocialLogin: UserAPI.TiIsSocialLogin_signUp(rawValue: params["tiIsSocialLogin"]!)!, vTimeOffset: vTimeOffset, vTimeZone: vTimeZone, vDeviceToken: vDeviceToken, tiDeviceType: UserAPI.TiDeviceType_signUp(rawValue: 1)!, vDeviceName: vDeviceName, vDeviceUniqueId: vDeviceUniqueId!, vApiVersion: vApiVersion, vAppVersion: vAppVersion, vOsVersion: vOSVersion, vIpAddress: vIPAddress, iUserId: "\(UserDataModel.currentUser!.iUserId!)", vSocialId: params["vSocialId"]!, vEmail: params["vEmail"]!, vPassword: params["vPassword"]!, vCountryCode: params["vCountryCode"]!, vPhone: params["vPhone"]!, vLiveIn: params["vLiveIn"]!, fLatitude: Float(params["fLatitude"]!), fLongitude: Float(params["fLongitude"]!), tiIsLocationOn : tiIsLocationOn, tiIsAcceptPush : tiIsAcceptPush) { (response, error) in
                
                LoaderView.sharedInstance.hideLoader()
                if response?.responseCode == 200 {
                    self.presenter?.getNormalSignupResponse(response : response!)
                } else if response?.responseCode == 203 {
                    AppSingleton.sharedInstance().logout()
                } else {
                    if error != nil {
                        AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                    } else {
                        AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
                    }
                }
            }
        } else {
            if socialType != "" {
                LoaderView.sharedInstance.showLoader()
                UserAPI.signUp(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, tiIsSocialLogin: UserAPI.TiIsSocialLogin_signUp(rawValue: params["tiIsSocialLogin"]!)!, vTimeOffset: vTimeOffset, vTimeZone: vTimeZone, vDeviceToken: vDeviceToken, tiDeviceType: UserAPI.TiDeviceType_signUp(rawValue: 1)!, vDeviceName: vDeviceName, vDeviceUniqueId: vDeviceUniqueId!, vApiVersion: vApiVersion, vAppVersion: vAppVersion, vOsVersion: vOSVersion, vIpAddress: vIPAddress, vSocialId: params["vSocialId"]!, tiSocialType: UserAPI.TiSocialType_signUp(rawValue: socialType)!, vEmail: params["vEmail"]!, vPassword: params["vPassword"]!, vCountryCode: params["vCountryCode"]!, vPhone: params["vPhone"]!, vLiveIn: params["vLiveIn"]!, fLatitude: Float(params["fLatitude"]!), fLongitude: Float(params["fLongitude"]!), tiIsLocationOn : tiIsLocationOn, tiIsAcceptPush : tiIsAcceptPush) { (response, error) in
                    
                    LoaderView.sharedInstance.hideLoader()
                    if response?.responseCode == 200 {
                        self.presenter?.getNormalSignupResponse(response : response!)
                    } else if response?.responseCode == 203 {
                        AppSingleton.sharedInstance().logout()
                    } else {
                        if error != nil {
                            AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                        } else {
                            AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
                        }
                    }
                }
            } else {
                LoaderView.sharedInstance.showLoader()
                UserAPI.signUp(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, tiIsSocialLogin: UserAPI.TiIsSocialLogin_signUp(rawValue: params["tiIsSocialLogin"]!)!, vTimeOffset: vTimeOffset, vTimeZone: vTimeZone, vDeviceToken: vDeviceToken, tiDeviceType: UserAPI.TiDeviceType_signUp(rawValue: 1)!, vDeviceName: vDeviceName, vDeviceUniqueId: vDeviceUniqueId!, vApiVersion: vApiVersion, vAppVersion: vAppVersion, vOsVersion: vOSVersion, vIpAddress: vIPAddress, vSocialId: params["vSocialId"]!, vEmail: params["vEmail"]!, vPassword: params["vPassword"]!, vCountryCode: params["vCountryCode"]!, vPhone: params["vPhone"]!, vLiveIn: params["vLiveIn"]!, fLatitude: Float(params["fLatitude"]!), fLongitude: Float(params["fLongitude"]!), tiIsLocationOn : tiIsLocationOn, tiIsAcceptPush : tiIsAcceptPush) { (response, error) in
                    
                    LoaderView.sharedInstance.hideLoader()
                    if response?.responseCode == 200 {
                        self.presenter?.getNormalSignupResponse(response : response!)
                    } else if response?.responseCode == 203 {
                        AppSingleton.sharedInstance().logout()
                    } else {
                        if error != nil {
                            AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                        } else {
                            AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
                        }
                    }
                }
            }
        }
    }
}
