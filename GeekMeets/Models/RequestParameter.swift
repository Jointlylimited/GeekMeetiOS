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
    
    func signUpParam(vUserName : String, vFirstName: String, vLastName: String, vEmailId: String, vPassword: String, images: [UIImage]?) -> Dictionary<String, Any> {
        var requestDictionary : Dictionary<String, Any> = Dictionary()
        requestDictionary["vUserName"] = vUserName
        requestDictionary["vFirstName"] = vFirstName
        requestDictionary["vLastName"] = vLastName
        requestDictionary["vEmailId"] = vEmailId
        requestDictionary["vPassword"] = vPassword
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
    
}

