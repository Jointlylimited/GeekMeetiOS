//
//  Authentication.swift
//  CarRental
//
//  Created by Hiren Gohel on 13/11/18.
//  Copyright © 2018 SOTSYS203. All rights reserved.
//

import Foundation
import Reachability

class Authentication : NSObject
{
    
    static var instance: Authentication!
    
    // SHARED INSTANCE
    class func sharedInstance() -> Authentication {
        self.instance = (self.instance ?? Authentication())
        return self.instance
    }
    
    public func GetCurrentTimeStamp() -> String {
        let df = DateFormatter()
        let date = NSDate()
        df.dateFormat = "yyyyMMddhhmmss"
        let NewDate = df.string(from: date as Date)
        return NewDate.replacingOccurrences(of: ":", with: "")
    }
    
    //MARK: Create Token
    public func createHashedTokenString(timeStemp : String , randomStr :  String) -> String {
        var str = String(format: "%@=%@&%@=%@","nonce", randomStr, "timestamp",timeStemp)
        
        str = str.appending("|")
        str = str.appending(kSecret)
        str = str.hmac(algorithm: .SHA256, key:kPrivateKey)
        return str
    }
    
    public func getAutheticationToken() -> (nonce : String, timeStamp : String, token : String){
        let nonce = 6.randomString
        let timestamp = Authentication.sharedInstance().GetCurrentTimeStamp()
        let token = Authentication.sharedInstance().createHashedTokenString(timeStemp: timestamp, randomStr: nonce)
        return (nonce,timestamp,token)
    }
    
    class func setVAuthKey(_ strkey:String?)
    {
        if strkey == nil{
            print("You should use the remove auth key method.")
            return
        }
        UserDefaults.standard.set(strkey, forKey: kkAuthKey)
        UserDefaults.standard.synchronize()
    }
    class func getVAuthKey()-> String?
    {
        let vAuthKey = UserDefaults.standard.object(forKey: kkAuthKey)
        if vAuthKey != nil{
            return vAuthKey as! String     //(userData as AnyObject).object(forKey: "vAuthKey") as! String
        }
        else{
            return ""
        }
    }
    
    class func setLoggedInStatus(_ status:Bool?)
       {
           if status == nil{
               print("You should use the remove status key method.")
               return
           }
           UserDefaults.standard.set(status, forKey: kLoggedInStatus)
           UserDefaults.standard.synchronize()
       }
       class func getLoggedInStatus()-> Bool?
       {
           let vAuthKey = UserDefaults.standard.object(forKey: kLoggedInStatus)
           if vAuthKey != nil{
            return vAuthKey as? Bool     //(userData as AnyObject).object(forKey: "vAuthKey") as! String
           }
           else{
               return false
           }
       }
    
    class func setInstagramIntegrationStatus(_ status:Bool?)
    {
        if status == nil{
            print("You should use the remove status key method.")
            return
        }
        UserDefaults.standard.set(status, forKey: kInstagramMediaIntegrated)
        UserDefaults.standard.synchronize()
    }
    class func getInstagramIntegrationStatus()-> Bool?
    {
        let vAuthKey = UserDefaults.standard.object(forKey: kInstagramMediaIntegrated)
        if vAuthKey != nil{
            return vAuthKey as? Bool     //(userData as AnyObject).object(forKey: "vAuthKey") as! String
        }
        else{
            return false
        }
    }
    
    class func setSignUpFlowStatus(_ status:Int?)
    {
        if status == nil{
            print("You could not find status value.")
            return
        }
        UserDefaults.standard.set(status, forKey: kSignUpFlowStatus)
        UserDefaults.standard.synchronize()
    }
    class func getSignUpFlowStatus()-> Int?
    {
        let vAuthKey = UserDefaults.standard.object(forKey: kSignUpFlowStatus)
        if vAuthKey != nil{
            return vAuthKey as! Int     //(userData as AnyObject).object(forKey: "vAuthKey") as! String
        }
        else{
            return 0
        }
    }
    
    class func setSwipeStatus(_ status:Int?)
    {
        if status == nil{
            print("You should use the remove status key method.")
            return
        }
        UserDefaults.standard.set(status, forKey: kSwipeStatus)
        UserDefaults.standard.synchronize()
    }
    class func getSwipeStatus()-> Int?
    {
        let vSwipeKey = UserDefaults.standard.object(forKey: kSwipeStatus)
        if vSwipeKey != nil{
            return (vSwipeKey as! Int)     //(userData as AnyObject).object(forKey: "vAuthKey") as! String
        }
        else{
            return 0
        }
    }
}
