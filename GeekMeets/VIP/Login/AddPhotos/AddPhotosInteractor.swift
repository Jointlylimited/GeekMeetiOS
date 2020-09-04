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
    func callSignUpInfoAPI(signParams : Dictionary<String, String>)
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
    var index = 0
    var images : [NSDictionary]?
    var finalStr = ""
    
    func sequenceUpload(){
        guard index < images!.count else {
            index = 0
            //            images.removeAll()
            return
        }
        
        let image = images![index].value(forKey: "tiImage") as! UIImage
        let tiDefault = images![index].value(forKey: "tiIsDefault") as! Int
        let imgName = images![index].value(forKey: "vMedia") as! String
        let imgPath = images![index].value(forKey: "vMediaPath") as! String
        
        index += 1
        
        AWSHelper.setup()
        
        self.uploadSingleImg(image: image, path: imgPath, name: imgName) { (success, path) in
            if tiDefault == 1 {
                self.paramDetails["vProfileImage"] = path.split("/").last!
            }
            
            let ustr = "{\"vMedia\":\"\(path.split("/").last!)\",\"tiMediaType\":\"1\",\"fHeight\":\"\(image.size.height)\",\"fWidth\":\"\(image.size.height)\",\"tiIsDefault\":\"\(tiDefault)\"}"
            self.finalStr = self.finalStr != "" ? "\(self.finalStr),\(ustr)" : ustr
            
            print(self.finalStr)
            
            if self.index == self.images!.count {
                DispatchQueue.main.async {
                    LoaderView.sharedInstance.hideLoader()
                }
                self.paramDetails["photos"] = "[\(self.finalStr)]"
                self.callSignUpInfoAPI(signParams: self.paramDetails as! Dictionary<String, String>)
            }
        }
    }
    
    func uploadImgToS3(with obj: Dictionary<String, Any>, images : [NSDictionary]) {
        if images.count == 0 {
            _ = AppSingleton.sharedInstance().showAlert(kSelectUserProfile, okTitle: "OK")
            return
        }
        self.images = images
        self.sequenceUpload()
        DispatchQueue.main.async {
            LoaderView.sharedInstance.showLoader()
        }
        var finalStr = ""
        self.paramDetails = obj
        
//        for indexValue in 0..<images.count {
//            let image = images[indexValue].value(forKey: "tiImage") as! UIImage
//            let tiDefault = images[indexValue].value(forKey: "tiIsDefault") as! Int
//            let imgName = images[indexValue].value(forKey: "vMedia") as! String
//            let imgPath = images[indexValue].value(forKey: "vMediaPath") as! String
//
//            AWSHelper.setup()
            
//            self.uploadSingleImg(image: image, path: imgPath, name: imgName) { (success, path) in
//                if tiDefault == 1 {
//                    self.paramDetails["vProfileImage"] = path.split("/").last!
//                }
//
//                let ustr = "{\"vMedia\":\"\(path.split("/").last!)\",\"tiMediaType\":\"1\",\"fHeight\":\"\(image.size.height)\",\"fWidth\":\"\(image.size.height)\",\"tiIsDefault\":\"\(tiDefault)\"}"
//                finalStr = finalStr != "" ? "[\(finalStr),\(ustr)]" : images.count == 1 ? "[\(ustr)]" : ustr
//                self.paramDetails["photos"] = finalStr
//                print(finalStr)
//
//                DispatchQueue.main.async {
//                    if finalStr.contains("[") {
//                        LoaderView.sharedInstance.hideLoader()
//                    }
//                    //                    if finalStr.contains("[") {
//                    self.callSignUpInfoAPI(signParams: self.paramDetails as! Dictionary<String, String>)
//                    //                    }
//                }
//            }
//        }
    }
        
        func uploadSingleImg(image : UIImage, path: String, name: String, complete: @escaping (Bool, String) -> ()){
            AWSHelper.shared.upload(img: image, imgPath: path, imgName: name) { [weak self] (isUploaded, path, error) in

                guard let `self` = self else {return}
                if let err = error {
                    print("ERROR : \(err.localizedDescription)")
                    _ = AppSingleton.sharedInstance().showAlert(err.localizedDescription, okTitle: "OK")
                } else if isUploaded {
                    complete(true, path!)
                } else {
                    _ = AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                }
                self.sequenceUpload()
            }
        }
    
    func callSignUpInfoAPI(signParams : Dictionary<String, String>) {
        DispatchQueue.main.async {
            LoaderView.sharedInstance.showLoader()
        }
        UserAPI.signUpInfo(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization, iUserId: "\(UserDataModel.currentUser?.iUserId ?? 1)", vName: signParams["vName"]!, dDob: signParams["dDob"]!, tiAge: signParams["tiAge"]!, tiGender: UserAPI.TiGender_signUpInfo(rawValue: signParams["tiGender"]!)!, iCurrentStatus: UserAPI.ICurrentStatus_signUpInfo(rawValue: signParams["iCurrentStatus"]!)!, txCompanyDetail: signParams["txCompanyDetail"]!, txAbout: signParams["txAbout"]!, photos: signParams["photos"]!, vProfileImage: signParams["vProfileImage"]!) { (response, error) in
            
            //            DispatchQueue.main.async {
            LoaderView.sharedInstance.hideLoader()
            //            }
            if response?.responseCode == 200 {
                self.presenter?.getSignUpResponse(response : response!)
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
}
