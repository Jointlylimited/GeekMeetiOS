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
}

class SignInInteractor: SignInInteractorProtocol {
    var presenter: SignInPresentationProtocol?
    //var name: String = ""
    
    // MARK: Do something
    func callSignInAPI(_ userName : String, password : String)
    {
        LoaderView.sharedInstance.showLoader()
        UserAPI.signIn(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, vEmail: userName, vPassword: password, vTimeOffset: vTimeOffset, vTimeZone: vTimeZone, vDeviceToken: vDeviceToken, tiDeviceType: UserAPI.TiDeviceType_signIn(rawValue: 1)!, vDeviceName: vDeviceName, vDeviceUniqueId: vDeviceUniqueId!, vApiVersion: vApiVersion, vAppVersion: vAppVersion, vOsVersion: vOSVersion, vIpAddress: vIPAddress) { (response, error) in
            
            LoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.presenter?.getSignInResponse(response : response!)
            } else if response?.responseCode == 203 {
                self.presenter?.getSignInResponse(response : response!)
//                AppSingleton.sharedInstance().logout()
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
