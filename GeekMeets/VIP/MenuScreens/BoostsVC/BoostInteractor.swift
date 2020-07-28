//
//  BoostInteractor.swift
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

protocol BoostInteractorProtocol {
    func callBoostPlansAPI()
    func callCreateBoostAPI(param : Dictionary<String, String>)
    func callActiveBoostAPI()
}

protocol BoostDataStore {
    //var name: String { get set }
}

class BoostInteractor: BoostInteractorProtocol, BoostDataStore {
    var presenter: BoostPresentationProtocol?
    //var name: String = ""
    
    // MARK: Do something
    func callBoostPlansAPI(){
        LoaderView.sharedInstance.showLoader()
        BoostGeekAPI.boostGeekPlans(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization, tiType: 1) { (response, error) in
            
            LoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.presenter?.getBoostPlansResponse(response: response!)
            } else if response?.responseCode == 400 {
                self.presenter?.getBoostPlansResponse(response: response!)
            }  else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.presenter?.getBoostPlansResponse(response: response!)
                }
            }
        }
    }
    
    func callCreateBoostAPI(param : Dictionary<String, String>) {
        
        LoaderView.sharedInstance.showLoader()
        BoostGeekAPI.createBoostGeek(nonce: authToken.nonce, timestamp: Int(authToken.timeStamp)!, token: authToken.token, authorization: UserDataModel.authorization, tiPlanType: 1, fPlanPrice: param["fPlanPrice"]!, vPurchaseDate:  authToken.timeStamp, iBoostGeekCount: Int(param["iBoostGeekCount"]!)!) { (response, error) in
            
            LoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.presenter?.getBoostResponse(response: response!)
            } else if response?.responseCode == 400 {
                self.presenter?.getBoostResponse(response: response!)
            }  else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.presenter?.getBoostResponse(response: response!)
                }
            }
        }
    }
    
    func callActiveBoostAPI(){
        LoaderView.sharedInstance.showLoader()
        BoostGeekAPI.activeBoostGeek(nonce: authToken.nonce, timestamp: Int(authToken.timeStamp)!, token: authToken.token, authorization: UserDataModel.authorization, tiPlanType: 1) { (response, error) in
            
            LoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.presenter?.getBoostResponse(response: response!)
            } else if response?.responseCode == 400 {
                self.presenter?.getBoostResponse(response: response!)
            }  else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.presenter?.getBoostResponse(response: response!)
                }
            }
        }
    }
}
