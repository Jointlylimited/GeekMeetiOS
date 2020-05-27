//
//  EditPreferencePresenter.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 27/05/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol EditPreferencePresentationProtocol {
    func callCreatePreferenceAPI(params : Dictionary<String, String>)
    func getPostPreferenceResponse(response : CommonResponse)
}

class EditPreferencePresenter: EditPreferencePresentationProtocol {
    weak var viewController: EditPreferenceProtocol?
    var interactor: EditPreferenceInteractorProtocol?
    
    // MARK: Present something
    func callCreatePreferenceAPI(params : Dictionary<String, String>){
        self.interactor?.callCreatePreferenceAPI(params : params)
    }
    func getPostPreferenceResponse(response : CommonResponse){
        self.viewController?.getPostPreferenceResponse(response : response)
    }
}
