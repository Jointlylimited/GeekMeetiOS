//
//  AppDelegate.swift
//  Basecode
//
//  Created by SOTSYS203 on 13/02/18.
//  Copyright © 2018 SOTSYS203. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SCSDKLoginKit
import GoogleSignIn
import Firebase

let kSecret = "BmECMMDZdXM8VhKIw4EKLY8nx0uC4Jtt@geekmeets"
let kPrivateKey = "QOUATaUA24pIFBPiIHr2Nu3BTcjFS8DA@geekmeets"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        
        let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
        let options = FirebaseOptions(contentsOfFile: filePath)
        FirebaseApp.configure(options: options!)
        GIDSignIn.sharedInstance().clientID = "784959084971-42nkai7mqrspe87v6euc5gfe5d77uodi.apps.googleusercontent.com"
        
        //Push Notification call
        self.registerForPushNotifications()
        
        if Authentication.getLoggedInStatus() == true {
            AppSingleton.sharedInstance().showHomeVC()
        }
        
        return true
    }
  
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return SCSDKLoginClient.application(app, open: url, options: options)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
  
    
}


extension UIApplicationDelegate {
    static var shared: Self {
        return UIApplication.shared.delegate! as! Self
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
