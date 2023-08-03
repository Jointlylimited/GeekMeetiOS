//
//  SelectAgeRangePresenter.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 23/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SelectAgeRangePresentationProtocol {
    func callQuestionaryAPI()
    func getQuestionaryResponse(response : PreferencesResponse)
    
    func callCreatePreferenceAPI(params : Dictionary<String, String>)
    func getPostPreferenceResponse(response : CommonResponse)
    
    func actionContinue()
    func actionSkip()
}

class SelectAgeRangePresenter: SelectAgeRangePresentationProtocol {
    
    
    weak var viewController: SelectAgeRangeProtocol?
    var interactor: SelectAgeRangeInteractorProtocol?
    
    // MARK: Present something
    func callQuestionaryAPI() {
       self.interactor?.callQuestionaryAPI()
    }
    
    func getQuestionaryResponse(response : PreferencesResponse) {
        UserDataModel.PreferenceData = response
        Authentication.setSignUpFlowStatus(4)
        self.viewController?.displayPreferenceData(response : response)
    }
  
    func callCreatePreferenceAPI(params : Dictionary<String, String>){
        self.interactor?.callCreatePreferenceAPI(params : params)
    }
    func getPostPreferenceResponse(response : CommonResponse){
        self.viewController?.getPostPreferenceResponse(response : response)
    }
    
    func actionContinue() {
        AppSingleton.sharedInstance().showHomeVC(fromMatch: false, userDict: [:])
//        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.TabbarScreen)
//        if let view = self.viewController as? UIViewController
//        {
//            view.pushVC(controller)
//        }
//        let controller = GeekMeets_StoryBoard.Main.instantiateViewController(withIdentifier: GeekMeets_ViewController.TutorialScreen)
//        if let view = self.viewController as? UIViewController
//        {
//            view.pushVC(controller)
//        }
    }
    func actionSkip() {
           let controller = GeekMeets_StoryBoard.LoginSignUp.instantiateViewController(withIdentifier: GeekMeets_ViewController.OTPEnter)
           if let view = self.viewController as? UIViewController
           {
               view.pushVC(controller)
           }
       }
}
