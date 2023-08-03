//
//  ChangeEmailMobileInteractor.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 28/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ChangeEmailMobileInteractorProtocol {
    func callUpdateEmailAPI(iUserId: String, vEmail : String)
}

protocol ChangeEmailMobileDataStore {
    //var name: String { get set }
}

class ChangeEmailMobileInteractor: ChangeEmailMobileInteractorProtocol, ChangeEmailMobileDataStore {
    var presenter: ChangeEmailMobilePresentationProtocol?
    //var name: String = ""
    
    // MARK: Do something
    func callUpdateEmailAPI(iUserId: String, vEmail : String) {
        DefaultLoaderView.sharedInstance.showLoader()
        UserAPI.requestForEmail(nonce: authToken.nonce, timestamp: Int(authToken.timeStamps)!, token: authToken.token, language: APPLANGUAGE.english, vEmail: vEmail, iUserId: iUserId) { (response, error) in
            
            delay(0.2) {
                DefaultLoaderView.sharedInstance.hideLoader()
            }
            if response?.responseCode == 200 {
                self.presenter?.getUpdateEmailResponse(response : response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
            } else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.presenter?.getUpdateEmailResponse(response : response!)
                }
            }
        }
    }
}