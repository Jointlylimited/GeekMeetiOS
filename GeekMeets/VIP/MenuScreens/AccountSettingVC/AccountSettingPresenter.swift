//
//  AccountSettingPresenter.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 23/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com

import UIKit

protocol AccountSettingPresentationProtocol {
    func callUserProfileAPI(id : String, code : String)
    func getUserProfileResponse(response : UserAuthResponseField)
}

class AccountSettingPresenter: AccountSettingPresentationProtocol {
    weak var viewController: AccountSettingProtocol?
    var interactor: AccountSettingInteractorProtocol?
    
    // MARK: Present something
    func callUserProfileAPI(id : String, code : String) {
        self.interactor?.callUserProfileAPI(id : id, code : code)
    }
    
    func getUserProfileResponse(response : UserAuthResponseField){
        self.viewController?.getUserProfileResponse(response : response)
    }
}
