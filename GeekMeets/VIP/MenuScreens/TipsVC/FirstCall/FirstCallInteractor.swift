//
//  FirstCallInteractor.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 16/07/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FirstCallInteractorProtocol {
    func callStaticPageAPI()
}

protocol FirstCallDataStore {
    //var name: String { get set }
}

class FirstCallInteractor: FirstCallInteractorProtocol, FirstCallDataStore {
    var presenter: FirstCallPresentationProtocol?
    //var name: String = ""
    
    // MARK: Do something
    func callStaticPageAPI() {
        
        LoaderView.sharedInstance.showLoader()
        ContentPageAPI.contentPage(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, slug: ContentPageAPI.Slug_contentPage(rawValue: "tips")!) { (response, error) in
            delay(0.2) {
                LoaderView.sharedInstance.hideLoader()
            }
            if response?.responseCode == 200 {
                self.presenter?.getContentPageResponse(response:response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
            } else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                     self.presenter?.getContentPageResponse(response:response!)
                }
            }
        }
    }
}
