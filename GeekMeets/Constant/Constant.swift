//
//  Constant.swift
//  Basecode
//
//  Created by SOTSYS203 on 19/02/18.
//  Copyright © 2018 SOTSYS203. All rights reserved.
//

import UIKit


let AppDelObj : AppDelegate = AppDelegate.shared

class Constant: NSObject {

}

struct APPUser {
  
    static let Customer = 1
  
}

struct UserListingData {
    static let Bussiness = 1
}

struct GeekMeets_StoryBoard
{
    static let Main = UIStoryboard(name: "Main", bundle: nil)
    static let LoginSignUp = UIStoryboard(name: "LoginSingUp", bundle: nil)
    static let Profile = UIStoryboard(name: "Profile", bundle: nil)
    static let SideMenu = UIStoryboard(name: "SideMenu", bundle: nil)
    static let Home = UIStoryboard(name: "Home", bundle: nil)
    static let Setting = UIStoryboard(name: "Setting", bundle: nil)
    static let MissingWorkPlace = UIStoryboard(name: "AddMissingBussiness", bundle: nil)
    static let Dashboard = UIStoryboard(name: "Dashboard", bundle: nil)
}
struct GeekMeets_ViewController
{
    static let SignInScreen = "SignInViewController"
    static let SignUpScreen = "SignUpVCViewController"
    static let OTPScreen = "OTPViewController"
    static let ForgotPassword = "ForgotPasswordViewController"
    static let compeleteProfile = "CompleteProfileViewController"
    static let  sideMenu = "SideMenuViewController"
    static let SelectLanguageScreen = "SelectLanguageViewController"
    static let BusinessInformationVC = "BusinessInformationViewController"
    static let AddressLandMarkVC = "AddressLandMarkViewController"
    static let CharacteristicsVC = "CharacteristicsViewController"
    static let OpeningDaysVC = "OpeningDaysViewController"
    static let UploadImageVC = "UploadImageViewController"
    static let CharacteristicsCategoryVC = "CharacteristicsCategoryViewController"
    
    static let TabbarScreen = "TabbarViewController"
    static let MatchScreen = "MatchViewController"
}


struct ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
    static let maxWH = max(ScreenSize.width, ScreenSize.height)
    static let maxLength = ScreenSize.height
}

struct AppCommonColor {
    static let pinkColor = #colorLiteral(red: 0.7098039216, green: 0.3254901961, blue: 0.8941176471, alpha: 1)
    static let navigationTitleFontColor = #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1803921569, alpha: 1.0)
    static let orangeColor = #colorLiteral(red: 0.9883782268, green: 0.305493474, blue: 0.3512662053, alpha: 1)
    static let placeHolderColor = #colorLiteral(red: 0.6990235448, green: 0.7155820727, blue: 0.719522655, alpha: 1)
    static let firstGradient = #colorLiteral(red: 0.606272161, green: 0.2928337753, blue: 0.8085166812, alpha: 1)
    static let secondGradient = #colorLiteral(red: 0.8740701079, green: 0.5383403897, blue: 0.9913718104, alpha: 1)
    
}

struct APPLANGUAGE {
    static let english = "en"
    static let arabic = "ar"
}

struct UserDefaultKeyName {
    static let kCurrentCustomerDetail = "CurrentCustomer"
    static let kCurrentProviderDetail = "kCurrentProvider"
    static let kCustomerLanguage = "CustomerLanguage"
}

struct AppResponseCode {
    static let SUCCESS = 200
    static let UNAUTHORIZE = 203
    static let MEHOD_NOT_ALLOW = 405
    static let NO_DATA_FOUND = 204

}
