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
    
    func signUpParam(vEmail: String, vPassword:String, vConfirmPassword:String, vCountryCode: String, vPhone : String, termsChecked : String, vSocialId : String, vLiveIn : String, fLatitude : String, fLongitude: String, tiIsSocialLogin : String) -> Dictionary<String, String> {
        
        var requestDictionary : Dictionary<String, String> = Dictionary()
        requestDictionary["vEmail"] = vEmail
        requestDictionary["vPassword"] = vPassword
        requestDictionary["vConfirmPassword"] = vConfirmPassword
        requestDictionary["vCountryCode"] = vCountryCode
        requestDictionary["vPhone"] = vPhone
        requestDictionary["termsChecked"] = termsChecked
        requestDictionary["vSocialId"] = vSocialId
        requestDictionary["vLiveIn"] = vLiveIn
        requestDictionary["fLatitude"] = fLatitude
        requestDictionary["fLongitude"] = fLongitude
        requestDictionary["tiIsSocialLogin"] = tiIsSocialLogin
        
        return requestDictionary
    }
    
    func signUpInfoParam(vProfileImage:String, vName:String, dDob:String, tiAge:String, tiGender:String, iCurrentStatus:String, txCompanyDetail:String, txAbout:String, photos:String) -> Dictionary<String, String> {
        
        var requestDictionary : Dictionary<String, String> = Dictionary()
        requestDictionary["vProfileImage"] = vProfileImage
        requestDictionary["vName"] = vName
        requestDictionary["dDob"] = dDob
        requestDictionary["tiAge"] = tiAge
        requestDictionary["tiGender"] = tiGender
        requestDictionary["iCurrentStatus"] = iCurrentStatus
        requestDictionary["txCompanyDetail"] = txCompanyDetail
        requestDictionary["txAbout"] = txAbout
        requestDictionary["photos"] = photos
        
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
    
    func editProfileParam(vEmail: String, vProfileImage: String, vName: String, dDob: String, tiAge: String, tiGender: String,  vLiveIn: String, txCompanyDetail:String, txAbout:String, deletephotos: String, photos:String, vInstaLink : String, vSnapLink: String, vFbLink: String, tiIsShowAge: String, tiIsShowDistance: String, tiIsShowContactNumber: String, tiIsShowProfileToLikedUser: String) -> Dictionary<String, String> {
        
        var requestDictionary : Dictionary<String, String> = Dictionary()
        requestDictionary["vEmail"] = vEmail
        requestDictionary["vProfileImage"] = vProfileImage
        requestDictionary["vName"] = vName
        requestDictionary["dDob"] = dDob
        requestDictionary["tiAge"] = tiAge
        requestDictionary["tiGender"] = tiGender
        
        requestDictionary["vLiveIn"] = vLiveIn
        requestDictionary["txCompanyDetail"] = txCompanyDetail
        requestDictionary["txAbout"] = txAbout
        requestDictionary["photos"] = photos
        requestDictionary["deletephotos"] = deletephotos
        requestDictionary["vInstaLink"] = vInstaLink
        requestDictionary["vSnapLink"] = vSnapLink
        requestDictionary["vFbLink"] = vFbLink
        requestDictionary["tiIsShowAge"] = tiIsShowAge
        requestDictionary["tiIsShowDistance"] = tiIsShowDistance
        requestDictionary["tiIsShowContactNumber"] = tiIsShowContactNumber
        requestDictionary["tiIsShowProfileToLikedUser"] = tiIsShowProfileToLikedUser
        
        return requestDictionary
    }
    
    func createPrefrence(tiPreferenceType : String, iPreferenceId: String, iOptionId : String, vAnswer: String, tiIsHide: String) -> Dictionary<String,String> {
        
        var requestDictionary : Dictionary<String,String> = Dictionary()
        requestDictionary["tiPreferenceType"] = tiPreferenceType;
        requestDictionary["iPreferenceId"] = iPreferenceId
        requestDictionary["iOptionId"] = iOptionId
        requestDictionary["vAnswer"] = vAnswer
        requestDictionary["tiIsHide"] = tiIsHide
        return requestDictionary
    }
    
    func updatePrefrence(tiPreferenceType : String, iPreferenceId: String, iOptionId : String, iAnswerId: String, tiIsHide: String) -> Dictionary<String,String> {
        
        var requestDictionary : Dictionary<String,String> = Dictionary()
        requestDictionary["tiPreferenceType"] = tiPreferenceType;
        requestDictionary["iPreferenceId"] = iPreferenceId
        requestDictionary["iOptionId"] = iOptionId
        requestDictionary["iAnswerId"] = iAnswerId
        requestDictionary["tiIsHide"] = tiIsHide
        return requestDictionary
    }
    
    func sendReason(iReportedFor : String, iStoryId: String, tiReportType : String, iReasonId: String, vReportText: String) -> Dictionary<String,String> {
        
        var requestDictionary : Dictionary<String,String> = Dictionary()
        requestDictionary["iReportedFor"] = iReportedFor;
        requestDictionary["iStoryId"] = iStoryId
        requestDictionary["tiReportType"] = tiReportType
        requestDictionary["iReasonId"] = iReasonId
        requestDictionary["vReportText"] = vReportText
        
        return requestDictionary
    }
    
    func createBoostGeekParams(fPlanPrice : String, tiPlanType: String, iBoostCount:String, iGeekCount:String) -> Dictionary<String,String> {
        
        var requestDictionary : Dictionary<String,String> = Dictionary()
        requestDictionary["fPlanPrice"] = fPlanPrice
        requestDictionary["tiPlanType"] = tiPlanType
        requestDictionary["iBoostCount"] = iBoostCount
        requestDictionary["iGeekCount"] = iGeekCount
        return requestDictionary
    }
    
    func createSubscriptionParams(vTransactionId: String, tiType: String, fPrice: String, vReceiptData: String, iStartDate: String, iEndDate: String) -> Dictionary<String, String> {
        
        var requestDictionary : Dictionary<String,String> = Dictionary()
        requestDictionary["vTransactionId"] = vTransactionId
        requestDictionary["tiType"] = tiType
        requestDictionary["fPrice"] = fPrice
        requestDictionary["vReceiptData"] = vReceiptData
        requestDictionary["iStartDate"] = iStartDate
        requestDictionary["iEndDate"] = iEndDate
        return requestDictionary
    }
    
    func updateSubscriptionParams(iSubscriptionId : String, iEndDate: String, isExpire:String) -> Dictionary<String,String> {
        
        var requestDictionary : Dictionary<String,String> = Dictionary()
        requestDictionary["iSubscriptionId"] = iSubscriptionId
        requestDictionary["iEndDate"] = iEndDate
        requestDictionary["isExpire"] = isExpire
        return requestDictionary
    }
}

