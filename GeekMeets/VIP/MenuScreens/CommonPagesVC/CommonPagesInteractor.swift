//
//  CommonPagesInteractor.swift
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

protocol CommonPagesInteractorProtocol {
    func CallContentPageAPI(slug:String)
}

protocol CommonPagesDataStore {
    //var name: String { get set }
}

class CommonPagesInteractor: CommonPagesInteractorProtocol, CommonPagesDataStore {
    var presenter: CommonPagesPresentationProtocol?
    //var name: String = ""
    
    // MARK: Do something
    func CallContentPageAPI(slug:String) {
        DefaultLoaderView.sharedInstance.showLoader()
        ContentPageAPI.contentPage(nonce: authToken.nonce, timestamp: authToken.timeStamps, token: authToken.token, slug: ContentPageAPI.Slug_contentPage(rawValue: slug)!) { (response, error) in
            
            delay(0.2) {
                DefaultLoaderView.sharedInstance.hideLoader()
            }
            if response?.responseCode == 200 {
                self.presenter?.getContentResponse(response : response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
            } else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                     self.presenter?.getContentResponse(response : response!)
                }
            }
        }
    }
}

