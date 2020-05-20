//
//  AddPhotosInteractor.swift
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
import CoreLocation

protocol AddPhotosInteractorProtocol {
    func callUserSignUpAPI(signParams : Dictionary<String, String>)
    func callSocialSignUpAPI(signParams : Dictionary<String, String>)
}

protocol AddPhotosDataStore {
    //var name: String { get set }
}

class AddPhotosInteractor: AddPhotosInteractorProtocol, AddPhotosDataStore {
    var presenter: AddPhotosPresentationProtocol?
    //var name: String = ""
    
    // MARK: Do something
    func callUserSignUpAPI(signParams : Dictionary<String, String>) {
      print(signParams)
        LoaderView.sharedInstance.showLoader()
        UserAPI.signUp(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, tiIsSocialLogin: UserAPI.TiIsSocialLogin_signUp(rawValue: "0")!, vEmail: signParams["vEmail"]!, vPassword: signParams["vPassword"]!, vCountryCode: signParams["vCountryCode"]!, vPhone: signParams["vPhone"]!, vName: signParams["vName"]!, dDob: signParams["dDob"]!, tiAge: signParams["tiAge"]!, tiGender: UserAPI.TiGender_signUp(rawValue: signParams["tiGender"]!)!, iCurrentStatus: UserAPI.ICurrentStatus_signUp(rawValue: signParams["iCurrentStatus"]!)!, txCompanyDetail: signParams["txCompanyDetail"]!, txAbout: signParams["txAbout"]!, photos: signParams["photos"]!, vTimeOffset: signParams["vTimeOffset"]!, vTimeZone: signParams["vTimeZone"]!, vDeviceToken: vDeviceToken, tiDeviceType: UserAPI.TiDeviceType_signUp(rawValue: 1)!, vDeviceName: vDeviceName, vDeviceUniqueId: vDeviceUniqueId ?? "", vApiVersion: vApiVersion, vAppVersion: vAppVersion, vOsVersion: vOSVersion, vIpAddress: vIPAddress) { (response, error) in
            
            LoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.presenter?.getSignUpResponse(response : response!)
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
    
    func callSocialSignUpAPI(signParams : Dictionary<String, String>) {
        let socialType = UserDataModel.getSocialType()
        LoaderView.sharedInstance.showLoader()
           UserAPI.signUp(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, tiIsSocialLogin: UserAPI.TiIsSocialLogin_signUp(rawValue: "1")!, vEmail: signParams["vEmail"]!, vPassword: signParams["vPassword"]!, vCountryCode: signParams["vCountryCode"]!, vPhone: signParams["vPhone"]!, vName: signParams["vName"]!, dDob: signParams["dDob"]!, tiAge: signParams["tiAge"]!, tiGender: UserAPI.TiGender_signUp(rawValue: signParams["tiGender"]!)!, iCurrentStatus: UserAPI.ICurrentStatus_signUp(rawValue: signParams["iCurrentStatus"]!)!, txCompanyDetail: signParams["txCompanyDetail"]!, txAbout: signParams["txAbout"]!, photos: signParams["photos"]!, vTimeOffset: signParams["vTimeOffset"]!, vTimeZone: signParams["vTimeZone"]!, vDeviceToken: vDeviceToken, tiDeviceType: UserAPI.TiDeviceType_signUp(rawValue: 1)!, vDeviceName: vDeviceName, vDeviceUniqueId: vDeviceUniqueId ?? "", vApiVersion: vApiVersion, vAppVersion: vAppVersion, vOsVersion: vOSVersion, vIpAddress: vIPAddress, vSocialId: signParams["vSocialId"]!, tiSocialType: UserAPI.TiSocialType_signUp(rawValue: socialType)!, vProfileImage: signParams["vProfileImage"]!, fLatitude: Float(signParams["fLatitude"]!), fLongitude: Float(signParams["fLongitude"]!)) { (response, error) in
               
            LoaderView.sharedInstance.hideLoader()
               if response?.responseCode == 200 {
                   self.presenter?.getSignUpResponse(response : response!)
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
