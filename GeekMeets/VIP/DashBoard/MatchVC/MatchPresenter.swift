//
//  MatchPresenter.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 17/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MatchPresentationProtocol {
    func presentSomething()
}

class MatchPresenter: MatchPresentationProtocol {
    weak var viewController: MatchProtocol?
    var interactor: MatchInteractorProtocol?
    
    // MARK: Present something
    func presentSomething() {
        
    }
}