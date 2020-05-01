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
    static var instanceBlockClass: Authentication!
    
    class func sharedInstanceClass() -> Authentication {
        self.instanceBlockClass = (self.instanceBlockClass ?? Authentication())
        return self.instanceBlockClass
    }
    
    
    public func getAutheticationToken() -> (nonce : String, timeStamp : String, token : String){
        let nonce = 6.randomString
        let timestamp = AuthenticationObj.GetCurrentTimeStamp()
        let token = AuthenticationObj.createHashedTokenString(timeStemp: timestamp, randomStr: nonce)
        return (nonce,timestamp,token)
    }
    
    
    func GetCurrentTimeStamp() -> String
    {
        let df = DateFormatter()
        let date = NSDate()
        df.dateFormat = "yyyyMMddhhmmss"
        let NewDate = df.string(from: date as Date)
        return NewDate.replacingOccurrences(of: ":", with: "")
    }
    
    //MARK: Create Token
    func createHashedTokenString(timeStemp : String , randomStr :  String) -> String
    {
        var str = String(format: "%@=%@&%@=%@","nonce", randomStr, "timestamp",timeStemp)
        
        str = str.appending("|")
        str = str.appending(kSecret)
        str = str.hmac(algorithm: .SHA256, key:kPrivateKey)
        return str
    }
}


//class Recheable
//{
//    static var instanceBlockClass: Recheable!
//
//    class func sharedInstanceClass() -> Recheable {
//        self.instanceBlockClass = (self.instanceBlockClass ?? Recheable())
//        return self.instanceBlockClass
//    }
//    
//    func isNetwork() -> Bool
//    {
//      let hostreach : Reachability = Reachability()
//        return !(hostreach.connection == .none)
//    }
//}
