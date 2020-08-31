//
//  ReportInteractor.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 24/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ReportInteractorProtocol {
    func callReportAPI()
    func callSendReportAPI(params : Dictionary<String, String>)
}

protocol ReportDataStore {
    //var name: String { get set }
}

class ReportInteractor: ReportInteractorProtocol, ReportDataStore {
    var presenter: ReportPresentationProtocol?
    //var name: String = ""
    
    // MARK: Do something
    func callReportAPI() {
        LoaderView.sharedInstance.showLoader()
        ReportAPI.listReason(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization) { (response, error) in
            
            delay(0.2) {
                LoaderView.sharedInstance.hideLoader()
            }
            if response?.responseCode == 200 {
                self.presenter?.getReportListResponse(response : response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert(kLoogedIntoOtherDevice, okTitle: "OK")
            } else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
                }
            }
        }
    }
    
    func callSendReportAPI(params : Dictionary<String, String>){
        LoaderView.sharedInstance.showLoader()
        ReportAPI.createReport(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization, tiReportType: params["tiReportType"]!, iReasonId: params["iReasonId"]!, vReportText: params["vReportText"]!, iReportedFor: params["iReportedFor"]!, iStoryId : params["iStoryId"]!) { (response, error) in
            
            delay(0.2) {
                LoaderView.sharedInstance.hideLoader()
            }
            if response?.responseCode == 200 {
                self.presenter?.getPostReportResponse(response : response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
                AppSingleton.sharedInstance().showAlert(kLoogedIntoOtherDevice, okTitle: "OK")
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
