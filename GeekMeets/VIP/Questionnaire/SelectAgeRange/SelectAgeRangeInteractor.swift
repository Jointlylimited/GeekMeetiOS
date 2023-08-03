//
//  SelectAgeRangeInteractor.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 23/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SelectAgeRangeInteractorProtocol {
    func callQuestionaryAPI()
    func callCreatePreferenceAPI(params : Dictionary<String, String>)
}

protocol SelectAgeRangeDataStore {
    //var name: String { get set }
}

class SelectAgeRangeInteractor: SelectAgeRangeInteractorProtocol, SelectAgeRangeDataStore {
    var presenter: SelectAgeRangePresentationProtocol?
    //var name: String = ""
    
    // MARK: Do something
    func callQuestionaryAPI() {
//        LoaderView.sharedInstance.showLoader()
        PreferencesAPI.list(nonce: authToken.nonce, timestamp: Int(authToken.timeStamps)!, token: authToken.token, language: APPLANGUAGE.english, authorization: UserDataModel.authorization) { (response, error) in
            
//            delay(0.2) {
//                LoaderView.sharedInstance.hideLoader()
//            }
            if response?.responseCode == 200 {
                self.presenter?.getQuestionaryResponse(response : response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
            } else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
                }
            }
            
        }
    }
    
    func callCreatePreferenceAPI(params : Dictionary<String, String>){
        DefaultLoaderView.sharedInstance.showLoader()
        PreferencesAPI.create(nonce: authToken.nonce, timestamp: Int(authToken.timeStamps)!, token: authToken.token, language: APPLANGUAGE.english, authorization: UserDataModel.authorization, tiPreferenceType: params["tiPreferenceType"]!, iPreferenceId: params["iPreferenceId"]!, iOptionId: params["iOptionId"]!, vAnswer: params["vAnswer"]!, tiIsHide: params["tiIsHide"]!) { (response, error) in
            
            delay(0.2) {
                DefaultLoaderView.sharedInstance.hideLoader()
            }
            if response?.responseCode == 200 {
                self.presenter?.getPostPreferenceResponse(response : response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
            } else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
                }
            }
        }
    }
}