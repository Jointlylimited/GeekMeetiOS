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
let NoInternetConnection = "No internet connection"
let kInternetConnection = "Please check your internet connection"
let kEnterFullName = "Please enter full name"
let kEnterFirstName = "Please enter first name"
let kEnterLastName = "Please enter last name"
let kEnterUsername = "Please enter email address"
let kEnterEmail = "Email cannot be blank"
let kEnterValidEmail = "Please enter valid email address"
let kEnterPassword = "Password cannot be blank"
let kEnterOldPassword = "Please enter Old Password"
let kEnterNewPassword = "Please enter new Password"
let kEnterConfirmPassword = "Confirm password cannot be blank"
let kPasswordNotMatch = "Password & confirm password must be same" // "Password doesn’t match"
let kPasswordWeak = "Password should contain min. 8 characters, One digit, Special characters, Upper case & Lower case letter"
let kOldPasswordWeak = "Old Password should contain min. 8 characters, One digit, Special characters, Upper case & Lower case letter"
let kNewPasswordWeak = "New Password should contain min. 8 characters, One digit, Special characters, Upper case & Lower case letter"
let kConfirmPasswordWeak = "Confirm Password should contain min. 8 characters, One digit, Special characters, Upper case & Lower case letter"
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
let kEnterCompanyDetail = "Company Detail cannot be blank"
let kEnterCollageSchoolDetail = "Collage/School Detail cannot be blank"
let kEnterUserAbout = " User Info cannot be blank"
let kEnterDoBProper = "Please select date of birth "
let kEnterUserName = "Name cannot be blank"
let kAddPhotos = "Please add photos"

let kEnterFirstname = "Please enter Firstname"
let kEnterLastname = "Please enter Lastname"
let kSocialType = "kSocialType"
let kSelectPreferene = "Please select your preference"
let kSelectReason = "Select Reason"
let kReasonEmpty = "Reason cannot be blank"

let kTitleCancel = "Cancel"
let kTitleBlock = "Block"
let kTitleUnBlock = "Unblock"
let kBlockStr = "Are you sure you want to block?"
let kUnblockStr = "Are you sure you want to unblock?"
let kBlockDesStr = "User will not able to see your profile after blocking"
let kUnblockDesStr = "User will able to see your profile after unblocking"
let kDelTitleStr = "Delete"
let kDelStr = "Are you sure you want to delete?"
let kClearTitleStr = "Clear Chat"
let kClearChatStr = "Are you sure you want to clear chat?"
let kClearBtnStr = "Clear"
let kUnMatchTitleStr = "Unmatch"
let kUnMatchDesStr = "You can not chat after unmatching \nAre you sure you want to clear chat?"
let kUnMatchBtnStr = "Un-match"
let kNotificationCount = "notificationCount"
let kMatchesCount = "MatchesCount"
let kPushStatus = "PushStatus"
let kVerifyEmail = "Verify Email"
let kNotVerifyMail = "Your email address is not verified please verify your email address"
let kResendLink = "Resend Link"
let kClearNotification = "You had successfully cleared all notifications."
let kPreferenceUpdate = "Preference updated successfuly."
let kNoProfile = "No other profiles available"
let kLogout = "Logout"
let kLogoutStr = "Are you sure you want to Logout?"
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
let kSubscription = "Subscription"
let kBoost = "Boost"
let kTopStory = "TopStory"
let kkAuthKey = "vAuthKey"
let kLoggedInStatus = "isUserLoggedIn"
let kSignUpFlowStatus = "SignUpFlowStatus"
let kSwipeStatus = "SwipeStatus"
let kSwipeLimit = "You have exceeded your swipe limit, Subscribe to check other further profiles..."
let kSuccessPurBoostPlan = "You have successfully purchased Boost plan"
let kSuccessPurStoryPlan = "You have successfully purchased Story plan"
let kSuccessPurSubscriptionPlan = "You have successfully purchased Subscription plan"
class KeyMessages: NSObject {

}
