//
//  TabbarPresenter.swift
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

protocol TabbarPresentationProtocol {
    func gotoMatchVC()
}

class TabbarPresenter: TabbarPresentationProtocol {
    weak var viewController: TabbarProtocol?
    var interactor: TabbarInteractorProtocol?
    
    // MARK: Present something
    func gotoMatchVC() {
        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.MatchScreen)
        if let view = self.viewController as? UIViewController
        {
            view.pushVC(controller)
        }
    }
}
