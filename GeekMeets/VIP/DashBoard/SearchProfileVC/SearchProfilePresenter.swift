//
//  SearchProfilePresenter.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 27/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SearchProfilePresentationProtocol {
    func presentSomething()
}

class SearchProfilePresenter: SearchProfilePresentationProtocol {
    weak var viewController: SearchProfileProtocol?
    var interactor: SearchProfileInteractorProtocol?
    
    // MARK: Present something
    func presentSomething() {
        
    }
}