//
//  AppdelegateNotification.swift
//  Basecode
//
//  Created by SOTSYS203 on 22/02/18.
//  Copyright © 2018 SOTSYS203. All rights reserved.
//

import UIKit
import UserNotifications
import SCSDKLoginKit
import FirebaseInstanceID
import FirebaseMessaging
import Firebase

extension AppDelegate : UNUserNotificationCenterDelegate {
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                print("Permission granted: \(granted)")
                if granted {
                    UserDataModel.setPushStatus(status: "1")
                } else {
                    UserDataModel.setPushStatus(status: "0")
                }
                
                guard granted else {
                    self.showPermissionAlert()
                    return
                }
                
                self.getNotificationSettings()
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    @available(iOS 10.0, *)
    func getNotificationSettings() {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            guard settings.authorizationStatus == .authorized else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    
    func showPermissionAlert() {
        UserDataModel.setPushStatus(status: "0")
        let alert = UIAlertController(title: "Error", message: "Please enable access to Notifications in the Settings app.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
            self.gotoAppSettings()
            alert.dismiss(animated: false, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        delay(0.2) {
            self.window?.rootViewController?.present(alert, animated: false, completion: nil)
        }
    }
    
    private func gotoAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(settingsUrl)
                // Fallback on earlier versions
            }
        }
    }
    
    func connectToFcm() {
        Messaging.messaging().shouldEstablishDirectChannel = true
        let token11 = Messaging.messaging().fcmToken
        if token11 != nil {
            print(token11)
            AppDelObj.deviceToken = token11!
            UserDefaults.standard.set(token11, forKey: kDeviceToken)
            UserDefaults.standard.synchronize()
        }
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .badge {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let strDeviceToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token:", strDeviceToken)
        UserDefaults.standard.set(strDeviceToken, forKey: kDeviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        UserDefaults.standard.set(15.randomString, forKey: kDeviceToken)
        print("Failed to register:", error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        print("aps : \(userInfo["aps"])")
        let dict = (userInfo["aps"] as! [String:Any])
        let badge = (dict["badge"] as! Int)
        AppDelObj.notificationBadgeCount = AppDelObj.notificationBadgeCount! + badge
        print(UIApplication.shared.applicationIconBadgeNumber)
        UIApplication.shared.applicationIconBadgeNumber = UserDataModel.getNotificationCount() + 1
        UserDataModel.setNotificationCount(count: UserDataModel.getNotificationCount() + 1)
        
        print(badge)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userDict = response.notification.request.content.userInfo as! [String:Any]
        let decoder = JSONDecoder()
        
        //        guard userDict.jsonData() != nil else {
        //            completionHandler()
        //            return
        //        }
        
        let dict = (userDict["aps"] as! [String:Any])
        let badge = (dict["badge"] as! Int)
        print("badge :\(badge), System Badge : \(UIApplication.shared.applicationIconBadgeNumber)")
        self.callReadAPI(iNotificationId: String(Int((userDict["gcm.notification.iUserNotificationId"] as! NSString).intValue)), tiType: "1")
        
        UserDataModel.setNotificationCount(count: UserDataModel.getNotificationCount() + 1)
        self.notificationBadgeCount = UserDataModel.getNotificationCount()
        
        print(userDict)
        let notiType = (userDict["gcm.notification.type"] as! NSString).intValue
        
        if notiType == 1 {
            
            let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.MatchScreen) as! MatchViewController
            controller.isFromNotification = true
            controller.OtherUserData = ["UserID": Int((userDict["gcm.notification.iOtherUserId"] as! NSString).intValue), "name" : userDict["gcm.notification.vOtherUserName"] as! NSString, "profileImage" : userDict["gcm.notification.vOtherProfileImage"] as! NSString]
            if let navctrl = self.window?.rootViewController as? UINavigationController{
                navctrl.pushViewController(controller, animated: true)
            }
        }
    }
}

extension AppDelegate {
    func callPushStatusAPI(tiIsAcceptPush : String) {
        
        UserAPI.setPushStatus(nonce: authToken.nonce, timestamp: authToken.timeStamps, token: authToken.token, authorization: UserDataModel.authorization, vDeviceToken: AppDelObj.deviceToken, tiIsAcceptPush: tiIsAcceptPush) { (response, error) in

            if response?.responseCode == 200 {
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
            } else {}
        }
    }
    func callReadAPI(iNotificationId : String, tiType : String) {
        DefaultLoaderView.sharedInstance.showLoader()
        NotificationAPI.viewNotification(nonce: authToken.nonce, timestamp: Int(authToken.timeStamps)!, token: authToken.token, authorization: UserDataModel.authorization, iNotificationId: iNotificationId, tiType: tiType) { (response, error) in
            
            DefaultLoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.callBadgeCountAPI()
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
            }  else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
//                    self.presenter?.getReadNotificationResponse(response: response!)
                }
            }
        }
    }
    
    func callBadgeCountAPI(){
        DefaultLoaderView.sharedInstance.showLoader()
        NotificationAPI.budgeCount(nonce: authToken.nonce, timestamp: Int(authToken.timeStamps)!, token: authToken.token, authorization: UserDataModel.authorization) { (response, error) in
            
            DefaultLoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                UserDataModel.setNotificationCount(count: UserDataModel.getNotificationCount() + 1)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
            }  else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    
                }
            }
        }
    }
}
extension AppDelegate: MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(kDeviceToken)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Recive")
    }
}
