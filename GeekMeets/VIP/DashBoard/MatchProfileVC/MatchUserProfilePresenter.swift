//
//  MatchUserProfilePresenter.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 03/06/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MatchUserProfilePresentationProtocol {
    func presentSomething()
}

class MatchUserProfilePresenter: MatchUserProfilePresentationProtocol {
    weak var viewController: MatchUserProfileProtocol?
    var interactor: MatchUserProfileInteractorProtocol?
    
    // MARK: Present something
    func presentSomething() {
        
    }
}
