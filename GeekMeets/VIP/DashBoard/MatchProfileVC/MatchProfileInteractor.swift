//
//  MatchProfileInteractor.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 21/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MatchProfileInteractorProtocol {
    func callUserProfileAPI(id : String, code : String)
    func callStoryListAPI(id : Int)
    
    func callBlockUserAPI(vXmppUser: String, tiIsBlocked: String)
    func callBlockUserListAPI()
    func callReactEmojiAPI( iUserId: String, iMediaId: String, tiRactionType: String)
    
    func callSwipeCardAPI(iProfileId : String, tiSwipeType : String)
}

protocol MatchProfileDataStore {
    //var name: String { get set }
}

class MatchProfileInteractor: MatchProfileInteractorProtocol, MatchProfileDataStore {
    var presenter: MatchProfilePresentationProtocol?
    //var name: String = ""
    
    // MARK: Do something
    
    func callUserProfileAPI(id : String, code : String){
        DefaultLoaderView.sharedInstance.showLoader()
        UserAPI.userProfile(nonce: authToken.nonce, timestamp: authToken.timeStamps, token: authToken.token, authorization: UserDataModel.authorization, iUserId: id, vReferralCode: code) { (response, error) in
            
            delay(0.2) {
                DefaultLoaderView.sharedInstance.hideLoader()
            }
            
            if response?.responseCode == 200 {
                print((response?.responseData!)!)
                self.presenter?.getUserProfileResponse(response: (response?.responseData!)!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
            } else if response?.responseCode == 400 {
                self.presenter?.getUserProfileResponse(response: (response?.responseData!)!)
            }  else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.presenter?.getUserProfileResponse(response: (response?.responseData!)!)
                }
            }
        }
    }
    
    func callStoryListAPI(id : Int) {
//        LoaderView.sharedInstance.showLoader()
        MediaAPI.listStory(nonce: authToken.nonce, timestamp: authToken.timeStamps, token: authToken.token, authorization: UserDataModel.authorization, _id: id) { (response, error) in
            
            DefaultLoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.presenter?.getStoryListResponse(response: response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
            } else if response?.responseCode == 400 {
                self.presenter?.getStoryListResponse(response: response!)
            }  else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.presenter?.getStoryListResponse(response: response!)
                }
            }
        }
    }
    
    func callBlockUserAPI(vXmppUser: String, tiIsBlocked: String) {
//        LoaderView.sharedInstance.showLoader()
        UserAPI.blockUsers(nonce: authToken.nonce, timestamp: authToken.timeStamps, token: authToken.token, authorization: UserDataModel.authorization, vXmppUser: vXmppUser, tiIsBlocked: tiIsBlocked) { (response, error) in
            
            DefaultLoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.presenter?.getBlockUserResponse(response: response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
            } else if response?.responseCode == 400 {
                self.presenter?.getBlockUserResponse(response: response!)
            }  else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.presenter?.getBlockUserResponse(response: response!)
                }
            }
            
        }
    }
    
    func callBlockUserListAPI(){
//        LoaderView.sharedInstance.showLoader()
        UserAPI.blockList(nonce: authToken.nonce, timestamp: authToken.timeStamps, token: authToken.token, authorization: UserDataModel.authorization) { (response, error) in
            
            DefaultLoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.presenter?.getBlockUserListResponse(response: response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
            } else if response?.responseCode == 400 {
                self.presenter?.getBlockUserListResponse(response: response!)
            }  else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.presenter?.getBlockUserListResponse(response: response!)
                }
            }
            
        }
    }
    
    func callReactEmojiAPI( iUserId: String, iMediaId: String, tiRactionType: String){
        DefaultLoaderView.sharedInstance.showLoader()
        MediaAPI.applyReaction(nonce: authToken.nonce, timestamp: authToken.timeStamps, token: authToken.token, authorization: UserDataModel.authorization, iUserId: iUserId, iMediaId: iMediaId, tiRactionType: tiRactionType) { (response, error) in
            
            DefaultLoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.presenter?.getReactEmojiResponse(response: response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
            } else if response?.responseCode == 400 {
                self.presenter?.getReactEmojiResponse(response: response!)
            }  else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.presenter?.getReactEmojiResponse(response: response!)
                }
            }
            
        }
    }
    
    func callSwipeCardAPI(iProfileId : String, tiSwipeType : String){
        DefaultLoaderView.sharedInstance.showLoader()
        UserAPI.swipeUser(nonce: authToken.nonce, timestamp: authToken.timeStamps, token: authToken.token, authorization: UserDataModel.authorization, iProfileId: iProfileId, tiSwipeType: tiSwipeType) { (response, error) in
            
            delay(0.2) {
                DefaultLoaderView.sharedInstance.hideLoader()
            }
            if response?.responseCode == 200 {
                self.presenter?.getSwipeCardResponse(response : response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
            } else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.presenter?.getSwipeCardResponse(response : response!)
                }
            }
        }
    }
}