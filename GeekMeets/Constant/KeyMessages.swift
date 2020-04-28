//
//  KeyNames.swift
//  Basecode
//
//  Created by SOTSYS203 on 01/03/18.
//  Copyright © 2018 SOTSYS203. All rights reserved.
//

import UIKit


//USERDEFAULT
let kDeviceToken = "DEVICE_TOKEN"
let kAuthKey = "vAuthKey"


//Messages
let kEnterUsername = "Please enter Username"
let kEnterFirstname = "Please enter Firstname"
let kEnterLastname = "Please enter Lastname"
let kEnterEmail = "Please enter email"
let kEnterValidEmail = "Please enter valid email"
let kEnterPassword = "Please enter Password"
let kEnterConfirmPassword = "Please enter confirm password"
let kPasswordNotMatch = "Confirm password not matching"
let kPasswordWeak = "Password is very weak. It should be at least 8 character"

//AppName
let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String

// MARK: Permission
let kCameraAccessTitle   = "No camera access"
let kCameraAccessMsg     = "Please go to settings and switch on your Camera. settings -> \(appName) -> switch on camera"
let kPhotosAccessTitle   = "No photos access"
let kPhotosAccessMsg     = "Please go to settings and switch on your photos. settings -> \(appName) -> switch on photos"
let kContactAccess       = "No contact access"

class KeyMessages: NSObject {

}
