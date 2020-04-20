//
//  ProfilePresenter.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 20/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ProfilePresentationProtocol {
    func gotoEditProfile()
}

class ProfilePresenter: ProfilePresentationProtocol {
    weak var viewController: ProfileProtocol?
    var interactor: ProfileInteractorProtocol?
    
    // MARK: Present something
    func gotoEditProfile() {
//        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.TabbarScreen)
//        if let view = self.viewController as? UIViewController
//        {
//            view.pushVC(controller)
//        }
    }
}
