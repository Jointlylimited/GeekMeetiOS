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
    func uploadImgToS3(with obj: Dictionary<String, Any>, images : [NSDictionary])
    func callUserSignUpAPI(signParams : Dictionary<String, String>)
    func callSocialSignUpAPI(signParams : Dictionary<String, String>)
}

protocol AddPhotosDataStore {
    //var name: String { get set }
}

class AddPhotosInteractor: AddPhotosInteractorProtocol, AddPhotosDataStore {
    var presenter: AddPhotosPresentationProtocol?
    //var name: String = ""
    
    var paramDetails : Dictionary<String, Any>!
    var thumbURlUpload: (path: String, name: String) {
        let folderName = user_Profile
        let timeStamp = Authentication.sharedInstance().GetCurrentTimeStamp()
        let imgExtension = ".jpeg"
        let path = "\(folderName)\(timeStamp)\(imgExtension)"
        return (path: path, name: "\(timeStamp)\(imgExtension)")
    }
    
    func uploadImgToS3(with obj: Dictionary<String, Any>, images : [NSDictionary]) {
            if images.count == 0 {
                _ = AppSingleton.sharedInstance().showAlert(kSelectUserProfile, okTitle: "OK")
                return
            }
            
            DispatchQueue.main.async {
                LoaderView.sharedInstance.showLoader()
            }
            var finalStr = ""
            self.paramDetails = obj
            
            for indexValue in 0..<images.count {
                let image = images[indexValue].value(forKey: "tiImage") as! UIImage
                let tiDefault = images[indexValue].value(forKey: "tiIsDefault") as! Int
                
                AWSHelper.setup()
                
                self.uploadSingleImg(image: image) { (success, path) in
                    if tiDefault == 1 {
                        self.paramDetails["vProfileImage"] = path.split("/").last!
                    }
                    
                    let ustr = "{\"vMedia\":\"\(path.split("/").last!)\",\"tiMediaType\":\"1\",\"fHeight\":\"\(image.size.height)\",\"fWidth\":\"\(image.size.height)\",\"tiIsDefault\":\"\(tiDefault)\"}"
                    finalStr = finalStr != "" ? "[\(finalStr),\(ustr)]" : images.count == 1 ? "[\(ustr)]" : ustr
                    self.paramDetails["photos"] = finalStr
                    print(finalStr)
                    
                    if finalStr.contains("[") {
                        DispatchQueue.main.async {
                            LoaderView.sharedInstance.hideLoader()
                        }
                        if finalStr.contains("[") {
                            if obj["vSocialId"] as! String != "" && obj["vSocialId"] as! String != "0" {
                                self.callSocialSignUpAPI(signParams: self.paramDetails as! Dictionary<String, String>)
                            } else {
                                self.callUserSignUpAPI(signParams: self.paramDetails as! Dictionary<String, String>)
                            }
                        }
                    }
                }
            }
        }
        
        func uploadSingleImg(image : UIImage, complete: @escaping (Bool, String) -> ()){
            AWSHelper.shared.upload(img: image, imgPath: self.thumbURlUpload.path, imgName: self.thumbURlUpload.name) { [weak self] (isUploaded, path, error) in

                guard let `self` = self else {return}
                if let err = error {
                    print("ERROR : \(err.localizedDescription)")
                    _ = AppSingleton.sharedInstance().showAlert(err.localizedDescription, okTitle: "OK")
                } else if isUploaded {
                    complete(true, path!)
                } else {
                    _ = AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                }
            }
        }
    
    // MARK: Do something
    func callUserSignUpAPI(signParams : Dictionary<String, String>) {
      print(signParams)
        DispatchQueue.main.async {
            LoaderView.sharedInstance.showLoader()
        }
        UserAPI.signUp(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, tiIsSocialLogin: UserAPI.TiIsSocialLogin_signUp(rawValue: "0")!, vName: signParams["vName"]!, dDob: signParams["dDob"]!, tiAge: signParams["tiAge"]!, tiGender: UserAPI.TiGender_signUp(rawValue: signParams["tiGender"]!)!, iCurrentStatus: UserAPI.ICurrentStatus_signUp(rawValue: signParams["iCurrentStatus"]!)!, txCompanyDetail: signParams["txCompanyDetail"]!, txAbout: signParams["txAbout"]!, photos: signParams["photos"]!, vTimeOffset: vTimeOffset, vTimeZone: vTimeZone, vDeviceToken: vDeviceToken, tiDeviceType: UserAPI.TiDeviceType_signUp(rawValue: 1)!, vDeviceName: vDeviceName, vDeviceUniqueId: vDeviceUniqueId ?? "", vApiVersion: vApiVersion, vAppVersion: vAppVersion, vOsVersion: vOSVersion, vIpAddress: vIPAddress, iUserId: "\(UserDataModel.currentUser!.iUserId!)", vEmail: signParams["vEmail"]!, vPassword: signParams["vPassword"]!, vCountryCode: signParams["vCountryCode"]!, vPhone: signParams["vPhone"]!, vProfileImage: signParams["vProfileImage"]!, fLatitude:  Float(signParams["fLatitude"]!), fLongitude: Float(signParams["fLongitude"]!)) { (response, error) in
            DispatchQueue.main.async {
                LoaderView.sharedInstance.hideLoader()
            }
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
        DispatchQueue.main.async {
            LoaderView.sharedInstance.showLoader()
        }
        UserAPI.signUp(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, tiIsSocialLogin: UserAPI.TiIsSocialLogin_signUp(rawValue: "1")!, vName: signParams["vName"]!, dDob: signParams["dDob"]!, tiAge: signParams["tiAge"]!, tiGender: UserAPI.TiGender_signUp(rawValue: signParams["tiGender"]!)!, iCurrentStatus: UserAPI.ICurrentStatus_signUp(rawValue: signParams["iCurrentStatus"]!)!, txCompanyDetail: signParams["txCompanyDetail"]!, txAbout: signParams["txAbout"]!, photos: signParams["photos"]!, vTimeOffset: vTimeOffset, vTimeZone: vTimeZone, vDeviceToken: vDeviceToken, tiDeviceType: UserAPI.TiDeviceType_signUp(rawValue: 1)!, vDeviceName: vDeviceName, vDeviceUniqueId: vDeviceUniqueId ?? "", vApiVersion: vApiVersion, vAppVersion: vAppVersion, vOsVersion: vOSVersion, vIpAddress: vIPAddress, vSocialId: signParams["vSocialId"]!, tiSocialType: UserAPI.TiSocialType_signUp(rawValue: socialType)!, vEmail: signParams["vEmail"]!, vPassword: signParams["vPassword"]!, vCountryCode: signParams["vCountryCode"]!, vPhone: signParams["vPhone"]!, vProfileImage: signParams["vProfileImage"]!, fLatitude: Float(signParams["fLatitude"]!), fLongitude: Float(signParams["fLongitude"]!)) { (response, error) in
               
            DispatchQueue.main.async {
                LoaderView.sharedInstance.hideLoader()
            }
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
