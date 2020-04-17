//
//  InitialLoginPresenter.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 16/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol InitialLoginPresentationProtocol {
    func presentSomething()
    func actionSignUp()
    func actionSignIn()
}

class InitialLoginPresenter: InitialLoginPresentationProtocol {
    weak var viewController: InitialLoginProtocol?
    var interactor: InitialLoginInteractorProtocol?
    
    // MARK: Present something
    func presentSomething() {
        
    }
  
    func actionSignIn()
    {
        let controller = GeekMeets_StoryBoard.LoginSignUp.instantiateViewController(withIdentifier: GeekMeets_ViewController.SignInScreen)
        if let view = self.viewController as? UIViewController
        {
            view.pushVC(controller)
        }
        
    }
    
    func actionSignUp()
      {
          let controller = GeekMeets_StoryBoard.LoginSignUp.instantiateViewController(withIdentifier: GeekMeets_ViewController.SignUpScreen)
          if let view = self.viewController as? UIViewController
          {
              view.pushVC(controller)
          }
          
      }
}
