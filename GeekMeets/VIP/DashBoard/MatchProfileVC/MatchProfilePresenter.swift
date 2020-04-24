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
}

class MatchProfilePresenter: MatchProfilePresentationProtocol {
    weak var viewController: MatchProfileProtocol?
    var interactor: MatchProfileInteractorProtocol?
    
    // MARK: Present something
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
