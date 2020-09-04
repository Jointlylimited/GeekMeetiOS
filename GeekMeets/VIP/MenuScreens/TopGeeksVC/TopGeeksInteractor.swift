//
//  TopGeeksInteractor.swift
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

protocol TopGeeksInteractorProtocol {
    func callGeeksPlansAPI()
    func callCreateGeeksAPI(param : Dictionary<String, String>)
    func callActiveGeeksAPI()
}

protocol TopGeeksDataStore {
    //var name: String { get set }
}

class TopGeeksInteractor: TopGeeksInteractorProtocol, TopGeeksDataStore {
    var presenter: TopGeeksPresentationProtocol?
    //var name: String = ""
    
    // MARK: Do something
    
    func callGeeksPlansAPI(){
//        LoaderView.sharedInstance.showLoader()
        BoostGeekAPI.boostGeekPlans(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization, tiType: 2) { (response, error) in
            
            delay(0.2) {
                LoaderView.sharedInstance.hideLoader()
            }
            if response?.responseCode == 200 {
                self.presenter?.getGeeksPlansResponse(response: response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
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
    
    func callCreateGeeksAPI(param : Dictionary<String, String>) {
        LoaderView.sharedInstance.showLoader()
        BoostGeekAPI.createBoostGeek(nonce: authToken.nonce, timestamp: Int(authToken.timeStamp)!, token: authToken.token, authorization: UserDataModel.authorization, tiPlanType: Int(param["tiPlanType"]!)!, fPlanPrice: param["fPlanPrice"]!, vPurchaseDate: authToken.timeStamp, iBoostCount: Int(param["iBoostCount"]!)!, iGeekCount: Int(param["iGeekCount"]!)!) { (response, error) in
            
//            delay(0.2) {
//                LoaderView.sharedInstance.hideLoader()
//            }
            if response?.responseCode == 200 {
                self.presenter?.getGeeksResponse(response: response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
            } else if response?.responseCode == 400 {
                self.presenter?.getGeeksResponse(response: response!)
            }  else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.presenter?.getGeeksResponse(response: response!)
                }
            }
        }
    }
    
    func callActiveGeeksAPI(){
        LoaderView.sharedInstance.showLoader()
        BoostGeekAPI.activeBoostGeek(nonce: authToken.nonce, timestamp: Int(authToken.timeStamp)!, token: authToken.token, authorization: UserDataModel.authorization, tiPlanType: 2) { (response, error) in
            
            delay(0.2) {
                LoaderView.sharedInstance.hideLoader()
            }
            if response?.responseCode == 200 {
                self.presenter?.getGeeksResponse(response: response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
            } else if response?.responseCode == 400 {
                self.presenter?.getGeeksResponse(response: response!)
            }  else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.presenter?.getGeeksResponse(response: response!)
                }
            }
        }
    }
}
