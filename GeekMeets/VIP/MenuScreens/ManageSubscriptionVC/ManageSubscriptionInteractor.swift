//
//  ManageSubscriptionInteractor.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 23/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ManageSubscriptionInteractorProtocol {
    func callSubscriptionDetailsAPI()
    func callCreateSubscriptionAPI(param : Dictionary<String, String>)
    func callUpdateSubscriptionAPI(param : Dictionary<String, String>)
    func callUserProfileAPI()
}

protocol ManageSubscriptionDataStore {
    //var name: String { get set }
}

class ManageSubscriptionInteractor: ManageSubscriptionInteractorProtocol, ManageSubscriptionDataStore {
    var presenter: ManageSubscriptionPresentationProtocol?
    //var name: String = ""
    
    // MARK: Do something
    func callSubscriptionDetailsAPI(){
        DefaultLoaderView.sharedInstance.showLoader()
        SubscriptionAPI.subscriptionDetails(nonce: authToken.nonce, timestamp: authToken.timeStamps, token: authToken.token, authorization: UserDataModel.authorization) { (response, error) in
            
            delay(0.2) {
                DefaultLoaderView.sharedInstance.hideLoader()
            }
            if response?.responseCode == 200 {
                self.presenter?.getSubscriptionDetailsResponse(response: response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
            } else if response?.responseCode == 400 {
                self.presenter?.getSubscriptionDetailsResponse(response: response!)
            }  else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.presenter?.getSubscriptionDetailsResponse(response: response!)
                }
            }
        }
    }
    
    func callCreateSubscriptionAPI(param : Dictionary<String, String>) {
        LoaderView.sharedInstance.showLoader()
        SubscriptionAPI.createSubscription(nonce: authToken.nonce, timestamp: authToken.timeStamps, token: authToken.token, authorization: UserDataModel.authorization, vTransactionId: param["vTransactionId"]!, tiType: param["tiType"]!, fPrice: param["fPrice"]!, vReceiptData: param["vReceiptData"]!, iStartDate: param["iStartDate"]!, iEndDate: param["iEndDate"]!) { (response, error) in
            
            delay(0.2) {
                LoaderView.sharedInstance.hideLoader()
            }
            if response?.responseCode == 200 {
                self.presenter?.getSubscriptionResponse(response: response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
            } else if response?.responseCode == 400 {
                self.presenter?.getSubscriptionResponse(response: response!)
            }  else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.presenter?.getSubscriptionResponse(response: response!)
                }
            }
        }
    }
    
    func callUpdateSubscriptionAPI(param : Dictionary<String, String>){
//        LoaderView.sharedInstance.showLoader()
        SubscriptionAPI.updateSubscription(nonce: authToken.nonce, timestamp: authToken.timeStamps, token: authToken.token, authorization: UserDataModel.authorization, iSubscriptionId: param["iSubscriptionId"]!, iEndDate: param["iEndDate"]!) { (response, error) in
            
//            delay(0.2) {
//                LoaderView.sharedInstance.hideLoader()
//            }
            if response?.responseCode == 200 {
                self.presenter?.getUpdateSubscriptionResponse(response: response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
            } else if response?.responseCode == 400 {
                self.presenter?.getUpdateSubscriptionResponse(response: response!)
            }  else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.presenter?.getUpdateSubscriptionResponse(response: response!)
                }
            }
        }
    }
    
    func callUserProfileAPI(){
//        LoaderView.sharedInstance.showLoader()
        UserAPI.userProfile(nonce: authToken.nonce, timestamp: authToken.timeStamps, token: authToken.token, authorization: UserDataModel.authorization, iUserId: "\(UserDataModel.currentUser!.iUserId!)", vReferralCode: "") { (response, error) in
            
//            delay(0.2) {
//                LoaderView.sharedInstance.hideLoader()
//            }
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
}