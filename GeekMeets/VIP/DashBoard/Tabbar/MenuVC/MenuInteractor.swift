//
//  MenuInteractor.swift
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

protocol MenuInteractorProtocol {
    func callSignoutAPI()
    func callUpdateLocationAPI(fLatitude : String, fLongitude : String, tiIsLocationOn : String)
    func callPushStatusAPI(tiIsAcceptPush : String)
    func callMatchListAPI()
    func callGeeksPlansAPI()
}

protocol MenuDataStore {
    //var name: String { get set }
}

class MenuInteractor: MenuInteractorProtocol, MenuDataStore {
    var presenter: MenuPresentationProtocol?
    //var name: String = ""
    
    // MARK: Do something
    func callSignoutAPI() {
        LoaderView.sharedInstance.showLoader()
        UserAPI.signout(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization) { (response, error) in
            
            LoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.presenter?.getSignoutResponse(response : response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
            } else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
                }
            }
        }
    }
    
    func callUpdateLocationAPI(fLatitude : String, fLongitude : String, tiIsLocationOn : String){
        LoaderView.sharedInstance.showLoader()
        UserAPI.locationUpdate(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization, vDeviceToken: vDeviceToken, fLatitude: fLatitude, fLongitude: fLongitude, tiIsLocationOn : tiIsLocationOn) { (response, error) in
            
            LoaderView.sharedInstance.hideLoader()
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
    
    func callPushStatusAPI(tiIsAcceptPush : String) {
        LoaderView.sharedInstance.showLoader()
        UserAPI.setPushStatus(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization, vDeviceToken: AppDelObj.deviceToken, tiIsAcceptPush: tiIsAcceptPush) { (response, error) in
            
            LoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.presenter?.getPushStatusResponse(response : response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
            } else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.presenter?.getPushStatusResponse(response : response!)
                }
            }
        }
    }
    
    func callMatchListAPI() {
        LoaderView.sharedInstance.showLoader()
        UserAPI.matches(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization) { (response, error) in
            
            LoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.presenter?.getMatchResponse(response: response!)
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
    
    func callGeeksPlansAPI(){
//        LoaderView.sharedInstance.showLoader()
        BoostGeekAPI.boostGeekPlans(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization, tiType: 1) { (response, error) in
            
//            LoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.presenter?.getGeeksPlansResponse(response: response!)
            } else if response?.responseCode == 400 {
                self.presenter?.getGeeksPlansResponse(response: response!)
            }  else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.presenter?.getGeeksPlansResponse(response: response!)
                }
            }
        }
    }
}
