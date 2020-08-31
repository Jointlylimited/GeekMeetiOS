//
//  LikesInteractor.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 11/08/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LikesInteractorProtocol {
    func callMatchListAPI()
}

protocol LikesDataStore {
    //var name: String { get set }
}

class LikesInteractor: LikesInteractorProtocol, LikesDataStore {
    var presenter: LikesPresentationProtocol?
    //var name: String = ""
    
     // MARK: Do something
       func callMatchListAPI() {
           LoaderView.sharedInstance.showLoader()
           UserAPI.matches(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization, tiType: 2) { (response, error) in
               
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
}
