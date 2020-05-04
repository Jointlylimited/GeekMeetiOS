//
//  HSFacebookLoginHelper.swift
//  WantIt
//
//  Created by SOTSYS216 on 14/06/17.
//  Copyright © 2017 myCompany. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

//Branch 09-01-2018

/*
 {
     email = "accfbpost@gmail.com";
     "first_name" = Abhishree;
     id = 2251503338408075;
     "last_name" = Patel;
     picture =     {
         data =         {
             height = 320;
             "is_silhouette" = 0;
             url = "https://scontent.xx.fbcdn.net/v/t1.0-1/p320x320/14222168_2071398789751865_5802625431553854246_n.jpg?oh=a18ca613fb778891c199b28b02c284e2&oe=59DDE92E";
             width = 512;
         };
     };
 }
 */

struct SignupSocialDM {
    var email: String?
    var firstName: String?
    var lastName: String?
    
    var profilePictureURL: URL?
    
    var token: String = ""
    var userID: String = ""
}

extension SignupSocialDM{
    init(token: String, userID: String) {
        self.token = token
        self.userID = userID
    }
    
    init(userID: String) {
        self.userID = userID
    }
}

typealias HSFBLoginCompletion = (_ result: SignupSocialDM?, _ isLogout: Bool, _ error: Error?)->(Void)

class HSFacebookLoginManager {
    
    static var manager: HSFacebookLoginManager = HSFacebookLoginManager()
    
    var readPermissions: [String] = []
    var publishPermissions: [String] = []
    var loginCompletion: HSFBLoginCompletion?
    
    func initialize(application:UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?, readPermissions: [String]){
        self.readPermissions = readPermissions
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool{
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func loginWithFacebook(in viewController: UIViewController, completion: @escaping HSFBLoginCompletion)
    {
        self.loginCompletion = completion
        
        LoginManager().logIn(permissions: self.readPermissions, from: viewController, handler: { (result, error) in

            if error != nil {
                LoginManager().logOut()
                self.loginCompletion!(nil, true, error)
                return
            }
            else if result!.isCancelled {
                LoginManager().logOut()
                self.loginCompletion!(nil, true, nil)
                return
            }
            else {
                
//                LoaderView.sharedInstance.showLoader()

                
                let param = ["fields": "id,email,first_name,last_name,picture.width(512)"]
                let graphRequest = GraphRequest(graphPath: "me", parameters: param)
                
                graphRequest.start { connection, result, error in
                
//                    LoaderView.sharedInstance.hideLoader()
                    
                    if result != nil
                    {
                        let resultDictionary = result as! [String:Any]
                        
                        print(resultDictionary)
                        //HHT change 2018 (open issue)
                        //var model = SignupSocialDM.init(token: FBSDKAccessToken.current().tokenString, userID: FBSDKAccessToken.current().userID)
                        
//                        var model = SignupSocialDM.init(userID: (resultDictionary["id"] as? String)!)
                        var model = SignupSocialDM(token: AccessToken.current!.tokenString, userID:(resultDictionary["id"] as? String)!)
                        model.email = resultDictionary["email"] as? String
                        model.firstName = resultDictionary["first_name"] as? String
                        model.lastName = resultDictionary["last_name"] as? String
                        model.profilePictureURL = URL(string: "http://graph.facebook.com/"+model.userID+"/picture?type=large&width=720&height=720")
                        //model.profilePictureURL = URL(string: "http://graph.facebook.com/"+FBSDKAccessToken.current().userID+"/picture?type=large&width=720&height=720")
                        
                        self.loginCompletion!(model, false, error)
                        return
                    }
                    else{
                        self.loginCompletion!(nil, false, error)
                    }
                }
            }
        })
    }
    
    func loginUsingPublishPermissionWithFacebook(in viewController: UIViewController, completion: @escaping HSFBLoginCompletion)
    {
        self.loginCompletion = completion
        LoginManager().logIn(permissions: self.publishPermissions,
                                  from: viewController) { (result, error) in
                                    if error != nil {
                                        LoginManager().logOut()
                                        self.loginCompletion!(nil, true, error)
                                        return
                                    }
                                    else if result!.isCancelled {
                                        LoginManager().logOut()
                                        self.loginCompletion!(nil, true, nil)
                                        return
                                    }
                                    else {
                                        let param = ["fields": "id,email,first_name,last_name,picture.width(512)"]
                                        let graphRequest = GraphRequest(graphPath: "me", parameters: param)
                                        
                                        graphRequest.start { connection, result, error in
                                            
                                            if result != nil
                                            {
                                                let resultDictionary = result as! [String:Any]
                                                
                                                //var model = SignupSocialDM.init(token: FBSDKAccessToken.current().tokenString, userID: FBSDKAccessToken.current().userID)
                                                
                                                var model = SignupSocialDM.init(userID: (resultDictionary["id"] as? String)!)
                                                model.email = resultDictionary["email"] as? String
                                                model.firstName = resultDictionary["first_name"] as? String
                                                model.lastName = resultDictionary["last_name"] as? String
                                                model.profilePictureURL = URL(string: "http://graph.facebook.com/"+model.userID+"/picture?type=large&width=720&height=720")
                                                //model.profilePictureURL = URL(string: "http://graph.facebook.com/"+FBSDKAccessToken.current().userID+"/picture?type=large&width=720&height=720")
                                                
                                                self.loginCompletion!(model, false, error)
                                                return
                                            }
                                            else {
                                                self.loginCompletion!(nil, false, error)
                                            }
                                        }
                                    }
        }
    }
    
    
    var canPublishOnFaceBook: Bool {
        return AccessToken.current != nil && AccessToken.current!.hasGranted(permission: "publish_actions")
    }
}
