//
//  MatchProfilePresenter.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 21/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MatchProfilePresentationProtocol {
    func gotoMatchVC()
    func gotoReportVC()
    
    func callUserProfileAPI(id : String)
    func getUserProfileResponse(response : UserAuthResponseField)
    
    func callStoryListAPI(id : Int)
    func getStoryListResponse(response: StoryResponse)
    
    func callBlockUserAPI(iBlockTo: String, tiIsBlocked: String)
    func getBlockUserResponse(response : CommonResponse)
    
    func callBlockUserListAPI()
    func getBlockUserListResponse(response : BlockUser)
    
    func callReactEmojiAPI( iUserId: String, iMediaId: String, tiRactionType: String)
    func getReactEmojiResponse(response : MediaReaction)
    
    func callSwipeCardAPI(iProfileId : String, tiSwipeType : String)
    func getSwipeCardResponse(response : SwipeUser)
}

class MatchProfilePresenter: MatchProfilePresentationProtocol {
    weak var viewController: MatchProfileProtocol?
    var interactor: MatchProfileInteractorProtocol?
    
    // MARK: Present something
    func callUserProfileAPI(id : String){
        self.interactor?.callUserProfileAPI(id: id)
    }
    func getUserProfileResponse(response : UserAuthResponseField){
        self.viewController?.getUserProfileResponse(response: response)
    }
    
    func callStoryListAPI(id : Int){
        self.interactor?.callStoryListAPI(id : id)
    }
    func getStoryListResponse(response: StoryResponse){
        self.viewController?.getStoryListResponse(response: response)
    }
    func callBlockUserAPI(iBlockTo: String, tiIsBlocked: String){
        self.interactor?.callBlockUserAPI(iBlockTo: iBlockTo, tiIsBlocked: tiIsBlocked)
    }
    
    func getBlockUserResponse(response : CommonResponse){
        self.viewController?.getBlockUserResponse(response : response)
    }
    
    func callBlockUserListAPI(){
        self.interactor?.callBlockUserListAPI()
    }
    
    func getBlockUserListResponse(response : BlockUser){
        self.viewController?.getBlockUserListResponse(response : response)
    }
    
    func callReactEmojiAPI( iUserId: String, iMediaId: String, tiRactionType: String){
        self.interactor?.callReactEmojiAPI(iUserId: iUserId, iMediaId: iMediaId, tiRactionType: tiRactionType)
    }
    
    func getReactEmojiResponse(response : MediaReaction){
        self.viewController?.getReactEmojiResponse(response: response)
    }
    
    func callSwipeCardAPI(iProfileId : String, tiSwipeType : String){
        self.interactor?.callSwipeCardAPI(iProfileId: iProfileId, tiSwipeType: tiSwipeType)
    }
    func getSwipeCardResponse(response : SwipeUser){
        self.viewController?.getSwipeCardResponse(response : response)
    }
    
    func gotoMatchVC() {
        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.MatchScreen)
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .overCurrentContext
        
        if let view = self.viewController as? UIViewController
        {
            view.presentVC(controller)
            //            view.pushVC(controller)
        }
    }
    
    func gotoReportVC(){
        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.ReportScreen)
        
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .overCurrentContext
        
        if let view = self.viewController as? UIViewController
        {
            view.presentVC(controller)
        }
    }
}
