//
//  RequestParameter.swift
//  CodeStructure
//
//  Created by Hitesh on 11/29/16.
//  Copyright © 2016 myCompany. All rights reserved.
//

import UIKit

class RequestParameter: NSObject {
    static var instance: RequestParameter!
    
//    var objUser : UserData! = nil
    let vDeviceToken = UserDefaults.standard[kDeviceToken] as! String
    let eDeviceType = "1"
    
    // SHARED INSTANCE
    class func sharedInstance() -> RequestParameter {
        self.instance = (self.instance ?? RequestParameter())
        return self.instance
    }
    
    func signUpParam(vEmail: String, vPassword:String, vConfirmPassword:String, vCountryCode: String, vPhone : String, termsChecked : String, vProfileImage:String, vName:String, dDob:String, tiAge:String, tiGender:String, iCurrentStatus:String, txCompanyDetail:String, txAbout:String, photos:String, vTimeOffset:String, vTimeZone:String) -> Dictionary<String, String> {
        var requestDictionary : Dictionary<String, String> = Dictionary()
        requestDictionary["vEmail"] = vEmail
        requestDictionary["vPassword"] = vPassword
        requestDictionary["vConfirmPassword"] = vConfirmPassword
        requestDictionary["vCountryCode"] = vCountryCode
        requestDictionary["vPhone"] = vPhone
        requestDictionary["termsChecked"] = termsChecked
        
        requestDictionary["vProfileImage"] = vProfileImage
        requestDictionary["vName"] = vName
        requestDictionary["dDob"] = dDob
        requestDictionary["tiAge"] = tiAge
        requestDictionary["tiGender"] = tiGender
        requestDictionary["iCurrentStatus"] = iCurrentStatus
        requestDictionary["txCompanyDetail"] = txCompanyDetail
        requestDictionary["txAbout"] = txAbout
        requestDictionary["photos"] = photos
        requestDictionary["vTimeOffset"] = vTimeOffset
        requestDictionary["vTimeZone"] = vTimeZone
        
        
        requestDictionary["vDeviceToken"] = vDeviceToken
        requestDictionary["eDeviceType"] = eDeviceType
        
//        if images != nil {
//            for (index, image) in (images?.enumerated())! {
//                requestDictionary["vMediaName[\(index)]"] = UIImageJPEGRepresentation(image, 1.0)
//            }
//        }
        return requestDictionary
    }
    
    func loginParam(email : String, password: String) -> Dictionary<String,String> {
        
        var requestDictionary : Dictionary<String,String> = Dictionary()
        requestDictionary["vEmailId"] = email;
        requestDictionary["vPassword"] = password
        requestDictionary["vDeviceToken"] = vDeviceToken
        requestDictionary["eDeviceType"] = eDeviceType

        //print(requestDictionary)
        return requestDictionary
    }
    
    func changePasswordParam(newPassword : String, oldPassword: String) -> Dictionary<String,String> {
        
        var requestDictionary : Dictionary<String,String> = Dictionary()
        requestDictionary["vPassword"] = newPassword;
        requestDictionary["vOldPassword"] = oldPassword
        requestDictionary["vDeviceToken"] = vDeviceToken
        requestDictionary["eDeviceType"] = eDeviceType
        
        //print(requestDictionary)
        return requestDictionary
    }
  
    func socialLoginParam(accessToken : String, service: String) -> Dictionary<String,String> {
        
        var requestDictionary : Dictionary<String,String> = Dictionary()
        requestDictionary["accessToken"] = accessToken;
        requestDictionary["service"] = service
        requestDictionary["eDeviceType"] = eDeviceType
        
        //print(requestDictionary)
        return requestDictionary
    }
    
    func googleSigninParams(tiSocialType : String, accessKey:String, service:String, vUserName:String, vEmailId:String, vSocialId:String, vImageUrl:String) -> Dictionary<String,String> {
        
        var requestDictionary : Dictionary<String,String> = Dictionary()
        requestDictionary["tiSocialType"] = tiSocialType
        requestDictionary["vDeviceToken"] = vDeviceToken
        requestDictionary["eDeviceType"] = eDeviceType
        
        requestDictionary["accessKey"] = accessKey
        requestDictionary["service"] = service
        requestDictionary["vUserName"] = vUserName
        requestDictionary["vEmailId"] = vEmailId
        requestDictionary["vSocialId"] = vSocialId
        requestDictionary["vImageUrl"] = vImageUrl
        
        return requestDictionary
    }
    
    func socialSigninParams(tiSocialType : String, accessKey:String, service:String) -> Dictionary<String,String> {
        
        var requestDictionary : Dictionary<String,String> = Dictionary()
        requestDictionary["tiSocialType"] = tiSocialType
        
        requestDictionary["accessKey"] = accessKey
        requestDictionary["service"] = service
        
        return requestDictionary
    }
}

