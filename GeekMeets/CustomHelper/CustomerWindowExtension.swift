//
//  WindowExtension.swift
//  NearByEventPlan
//
//  Created by SOTSYS195 on 22/01/19.
//  Copyright © 2019 SOTSYS203. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow
{
    func json(_ object: Any) -> String?
    {
        let jsonData = try! JSONSerialization.data(withJSONObject: object, options: [])
        return String(data: jsonData, encoding: String.Encoding.ascii)!
    }
    
    func userLogin()
    {
//        selectLanguage = currentCustomerUser.getLanguagedata()
        let objSideMenu = GeekMeets_StoryBoard.SideMenu
            .instantiateViewController(withIdentifier: GeekMeets_ViewController.sideMenu)
        AppDelegate.shared.window?.rootViewController = objSideMenu
    }
    
    func userLogout()
    {
//        let authenticationObj = AuthenticationObj.getAutheticationToken()
//        AppsingtonObj.showActivityIndicatior()
//
//        UserAPI.signout(nonce: authenticationObj.nonce, timestamp: authenticationObj.timeStamp, token: authenticationObj.token, authorization: currentCustomerUser.accessToken) { (commonResponse, error) in
//            if error == nil
//            {
//                AppsingtonObj.removeActivityIndicatior()
//                if let response = commonResponse
//                {
//                    if response.responseCode == AppResponseCode.SUCCESS || response.responseCode == AppResponseCode.UNAUTHORIZE
//                    {
//                        self.unauthoriseLogout()
//                    }
//                    else
//                    {
//                        self.rootViewController?.showNearByAlertSingleButton(self.rootViewController!, alertMessage: response.responseMessage!)
//                    }
//                }
//            }
//            else
//            {
//                AppsingtonObj.removeActivityIndicatior()
//                self.rootViewController?.showNearByAlertSingleButton(self.rootViewController!, alertMessage: error!.localizedDescription)
//            }
//        }
//
        
    }
    
    func unauthoriseLogout()
    {
//        UserResponse.removeCurrentCustomerUser()
        let controller : UINavigationController = GeekMeets_StoryBoard.Main.instantiateViewController(withIdentifier: "navigationLogin") as! UINavigationController
        AppDelObj.window?.rootViewController = controller
    }
    
    func setRootViewController()
    {
        let controller : UINavigationController = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: "navigationLogin") as! UINavigationController
        Authentication.setLoggedInStatus(true)
        AppDelObj.window?.rootViewController = controller
    }
}
