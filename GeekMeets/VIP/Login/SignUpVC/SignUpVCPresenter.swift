//
//  SignUpVCPresenter.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 17/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SignUpVCPresentationProtocol {
    func presentSomething()
    func actionContinue()
}

class SignUpVCPresenter: SignUpVCPresentationProtocol {
    weak var viewController: SignUpVCProtocol?
    var interactor: SignUpVCInteractorProtocol?
    
    // MARK: Present something
    func presentSomething() {
        
    }
  
    func actionContinue() {
        let controller = GeekMeets_StoryBoard.LoginSignUp.instantiateViewController(withIdentifier: GeekMeets_ViewController.UserProfile)
        if let view = self.viewController as? UIViewController
        {
            view.pushVC(controller)
        }
    }
}
