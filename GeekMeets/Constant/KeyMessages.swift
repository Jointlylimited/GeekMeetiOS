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

let kInternetConnection = "Please check your internet connection"
let kEnterFullName = "Please enter full name"
let kEnterFirstName = "Please enter first name"
let kEnterLastName = "Please enter last name"
let kEnterUsername = "Please enter email address"
let kEnterEmail = "Email cannot be blank"
let kEnterValidEmail = "Please enter valid email address"
let kEnterPassword = "Password cannot be blank"
let kEnterOldPassword = "Please enter current Password"
let kEnterNewPassword = "Please enter new Password"
let kEnterConfirmPassword = "Confirm password cannot be blank"
let kPasswordNotMatch = "Password doesn’t match"
let kPasswordWeak = "Password must contain at least 8 characters including UPPER/Lowercase,Number,Spacial Character"
let kConfirmPasswordWeak = "Please enter Confirm Password at least 6 characters"
let kSelectCountryCode = "Select country code"
let kSelectUserProfile = "Select User Profile"
let KEnterMobileNo = "Mobile number cannot be blank"
let KEnterCountryCode = "Please enter your country code"
let KEnterValidMobileNo = "Invalid number”"
let kSelectTerms = "Please confirm that you have read all the terms & condition and privacy policy"
let kEnterOTP = "Enter OTP "
let kOTP = ""
let kSelectLanguage = "Please select Language"
let kSelectGender = "Please select Gender"
let kSelectDate = "Please select Date"
let kEnterMessage = "Please enter Message"
let kCamaraNotAvaliable = "Camera Not available"
let kContactUsMessage = "Please enter message"
let kEnterCompanyDetail = "Please enter Company Detail"
let kEnterUserAbout = "Please enter user Info"
let kEnterDoBProper = "Please select date of birth "
let kEnterUserName = "Name cannot be blank"
let kAddPhotos = "Please add photos"

//let kEnterUsername = "Please enter Username"
let kEnterFirstname = "Please enter Firstname"
let kEnterLastname = "Please enter Lastname"
//let kEnterEmail = "Please enter email"
//let kEnterValidEmail = "Please enter valid email"
//let kEnterPassword = "Please enter Password"
//let kEnterConfirmPassword = "Please enter confirm password"
//let kPasswordNotMatch = "Confirm password not matching"
//let kPasswordWeak = "Password is very weak. It should be at least 8 character"

//AppName
let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String

// MARK: Permission
let kCameraAccessTitle   = "No camera access"
let kCameraAccessMsg     = "Please go to settings and switch on your Camera. settings -> \(appName) -> switch on camera"
let kPhotosAccessTitle   = "No photos access"
let kPhotosAccessMsg     = "Please go to settings and switch on your photos. settings -> \(appName) -> switch on photos"
let kContactAccess       = "No contact access"
let kLocationAccessTitle   = "No Location access"
let kLocationAccessMsg     = "Please go to settings and allow your Location. settings -> \(appName) -> Allow Location"

let kSomethingWentWrong = "Something went wrong...Please try again"
let kLoogedIntoOtherDevice = "It is look like you logged in another device."
let kUserCurrentLocation = "kUserCurrentLocation"
let kMobileVerifySucc = "Your mobile is changed & verified Successfully"
class KeyMessages: NSObject {

}
