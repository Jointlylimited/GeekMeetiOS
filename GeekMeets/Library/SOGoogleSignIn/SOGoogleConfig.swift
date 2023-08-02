//
//  SOGoogleConfig.swift
//  SOGoogleSignIn
//
//  Created by SOTSYS203 on 18/04/18.
//  Copyright © 2018 SOTSYS203. All rights reserved.
//

import UIKit
import GoogleSignIn

protocol GoogleManagerDelegate {
    func receiveResponse(user: GIDGoogleUser?, error: Error?)// Pass Parameter that you want
}

class SOGoogleConfig: NSObject {
    
    var delegate: GoogleManagerDelegate?
    
    func ConfigGoogleSignIn() {
        // Initialize sign-in

//        GIDSignIn.sharedInstance().clientID = "Client ID"
//        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func googleSignIn() {
       // GIDSignIn.sharedInstance().signIn()
        googleSignIn()
    }
    
    func googleSignOut() {
//        GIDSignIn.sharedInstance().signOut()
//        GIDSignIn.sharedInstance().disconnect()
      googleSignOut()

    }

    GIDSignIn.sharedInstance.signIn(withPresenting: self) { (signInResult, error) in
        guard error == nil else {

            if (user.profile?.hasImage) {
                let url = user.profile?.imageURL(withDimension: 100)
                print("url....\(String(describing: url))")
                UserDefaults.standard.set(url, forKey: "user_photo")
            }
            return

        }
        guard let signInResult = signInResult else { return }

        let user = signInResult.user

        self.delegate?.receiveResponse(user: user, error: error)
    }
}

extension AppDelegate {
    
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        let isGooglePlusURL = GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
//        return isGooglePlusURL
//    }
    
}

    
//    //var GoogleConfigDelegate: GoogleManagerDelegate?
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//        print("didDisconnectWith", user)
//        print("didDisconnectWith", error)
//        self.delegate?.receiveResponse(user: user, error: error)
//    }
//
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//
//    }
//}

//extension SOGoogleConfig : GIDSignInUIDelegate {
//    //GOOGLE
//    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
//        //myActivityIndicator.stopAnimating()
//    }
//
//    // Present a view that prompts the user to sign in with Google
//    func sign(_ signIn: GIDSignIn!,
//              present viewController: UIViewController!) {
//        let vc = viewController.topMostViewControllerGoogle()
//        vc.present(viewController, animated: true, completion: nil)
//    }
//
//    // Dismiss the "Sign in with Google" view
//    func sign(_ signIn: GIDSignIn!,
//              dismiss viewController: UIViewController!) {
//
//        let vc = viewController.topMostViewControllerGoogle()
//        vc.dismiss(animated: true, completion: nil)
//    }
//}


extension UIViewController {
    func topMostViewControllerGoogle() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewControllerGoogle()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewControllerGoogle()
            }
            return tab.topMostViewControllerGoogle()
        }
        return self.presentedViewController!.topMostViewControllerGoogle()
    }
}

extension UIApplication {
//    func topMostViewController() -> UIViewController? {
//        return self.keyWindow?.rootViewController?.topMostViewController()
//    }
}
