//
//  HomeInteractor.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 20/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol HomeInteractorProtocol {
     func callUserCardAPI()
     func callSwipeCardAPI(iProfileId : String, tiSwipeType : String)
    func callUpdateLocationAPI(fLatitude : String, fLongitude : String, tiIsLocationOn : String)
}

protocol HomeDataStore {
    //var name: String { get set }
}

class HomeInteractor: HomeInteractorProtocol, HomeDataStore {
    var presenter: HomePresentationProtocol?
    //var name: String = ""
    
    // MARK: Do something
     func callUserCardAPI() {
        LoaderView.sharedInstance.showLoader()
        UserAPI.cardList(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization) { (response, error) in
            
            LoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.presenter?.getUserCardResponse(response : response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
            } else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.presenter?.getUserCardResponse(response : response!)
                }
            }
        }
    }
    
    func callSwipeCardAPI(iProfileId : String, tiSwipeType : String){
        LoaderView.sharedInstance.showLoader()
        UserAPI.swipeUser(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization, iProfileId: iProfileId, tiSwipeType: tiSwipeType) { (response, error) in
            
            LoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.presenter?.getSwipeCardResponse(response : response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
            } else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.presenter?.getSwipeCardResponse(response : response!)
                }
            }
        }
    }
    
    func callUpdateLocationAPI(fLatitude : String, fLongitude : String, tiIsLocationOn : String){
//        LoaderView.sharedInstance.showLoader()
        UserAPI.locationUpdate(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization, vDeviceToken: vDeviceToken, fLatitude: fLatitude, fLongitude: fLongitude, tiIsLocationOn : tiIsLocationOn) { (response, error) in
            
//            LoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.presenter?.getLocationUpdateResponse(response : response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
            } else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.presenter?.getLocationUpdateResponse(response : response!)
                }
            }
        }
    }
}
