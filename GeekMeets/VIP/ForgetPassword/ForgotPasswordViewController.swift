//
//  ForgotPasswordViewController.swift
//  Basecode
//
//  Created by SOTSYS203 on 19/02/18.
//  Copyright (c) 2018 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ForgotPasswordProtocol: class {
    func displaySomething()
}

class ForgotPasswordViewController: UIViewController, ForgotPasswordProtocol {
    //var interactor : ForgotPasswordInteractorProtocol?
    var presenter : ForgotPasswordPresentationProtocol?
    
    @IBOutlet weak var txtEmail : UITextField?
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = ForgotPasswordInteractor()
        let presenter = ForgotPasswordPresenter()
        
        //View Controller will communicate with only presenter
        viewController.presenter = presenter
        //viewController.interactor = interactor
        
        //Presenter will communicate with Interector and Viewcontroller
        presenter.viewController = viewController
        presenter.interactor = interactor
        
        //Interactor will communucate with only presenter.
        interactor.presenter = presenter
    }
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething() {
        
    }
    
    func displaySomething() {
        //nameTextField.text = viewModel.name
    }
    
    @IBAction func actionBack() {
        self.popVC()
    }
}
