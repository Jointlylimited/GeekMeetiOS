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
        
        let alert = UIAlertController(title: "Error", message: "Please enable access to Notifications in the Settings app.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
            self.gotoAppSettings()
            alert.dismiss(animated: false, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        //self.window?.rootViewController?.show(alert, sender: nil)
        self.window?.rootViewController?.present(alert, animated: false, completion: nil)
        
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
//            AppDelObj.deviceToken = token11!
//            UserDefaults.standard.set(token11, forKey: kDeviceToken)
//            UserDefaults.standard.synchronize()
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
//        UserDefaults.standard.set(15.randomString, forKey: kDeviceToken)
        print("Failed to register:", error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        //let aps = userInfo["aps"]
        // If your app was running and in the foreground
        // Or
        // If your app was running or suspended in the background and the user brings it to the foreground by tapping the push notification
    }
}

extension AppDelegate: MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        AppDelObj.deviceToken = fcmToken
//        UserDefaults.standard.set(fcmToken, forKey: kDeviceToken)
//        UserDefaults.standard.synchronize()
//        print(kDeviceToken)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Recive")
    }
}
