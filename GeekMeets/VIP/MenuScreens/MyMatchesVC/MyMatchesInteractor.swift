//
//  MyMatchesInteractor.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 22/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MyMatchesInteractorProtocol {
    func callMatchListAPI()
    func callUnMatchUserAPI(iProfileId : String)
}

protocol MyMatchesDataStore {
    //var name: String { get set }
}

class MyMatchesInteractor: MyMatchesInteractorProtocol, MyMatchesDataStore {
    var presenter: MyMatchesPresentationProtocol?
    //var name: String = ""
    
    // MARK: Do something
    func callMatchListAPI() {
        LoaderView.sharedInstance.showLoader()
        UserAPI.matches(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization, tiType: 0) { (response, error) in
            
            delay(0.2) {
                LoaderView.sharedInstance.hideLoader()
            }
            if response?.responseCode == 200 {
                self.presenter?.getMatchResponse(response: response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert(kLoogedIntoOtherDevice, okTitle: "OK")
            } else if response?.responseCode == 400 {
                self.presenter?.getMatchResponse(response: response!)
            }  else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.presenter?.getMatchResponse(response: response!)
                }
            }
        }
    }
    
    func callUnMatchUserAPI(iProfileId : String){
        LoaderView.sharedInstance.showLoader()
        UserAPI.unMatch(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization, vXmppUser: iProfileId) { (response, error) in
            
            delay(0.2) {
                LoaderView.sharedInstance.hideLoader()
            }
            if response?.responseCode == 200 {
                self.presenter?.getUnMatchResponse(response: response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert(kLoogedIntoOtherDevice, okTitle: "OK")
            } else if response?.responseCode == 400 {
                self.presenter?.getUnMatchResponse(response: response!)
            }  else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.presenter?.getUnMatchResponse(response: response!)
                }
            }
        }
    }
}
