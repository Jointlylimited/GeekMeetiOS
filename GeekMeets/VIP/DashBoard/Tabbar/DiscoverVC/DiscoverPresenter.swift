//
//  DiscoverPresenter.swift
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

protocol DiscoverPresentationProtocol {
    func callStoryListAPI()
    func getStoryListResponse(response: StoryResponse)
}

class DiscoverPresenter: DiscoverPresentationProtocol {
    weak var viewController: DiscoverProtocol?
    var interactor: DiscoverInteractorProtocol?
    
    // MARK: Present something
    func callStoryListAPI(){
        self.interactor?.callStoryListAPI()
    }
    
    func getStoryListResponse(response: StoryResponse) {
        self.viewController?.getStoryListResponse(response: response)
    }
}
