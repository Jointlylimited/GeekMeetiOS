//
//  Share_EarnViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 24/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol Share_EarnProtocol: class {
}

class Share_EarnViewController: UIViewController, Share_EarnProtocol {
    //var interactor : Share_EarnInteractorProtocol?
    var presenter : Share_EarnPresentationProtocol?
    
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
        let interactor = Share_EarnInteractor()
        let presenter = Share_EarnPresenter()
        
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
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.popVC()
    }
    @IBAction func btnShareAction(_ sender: GradientButton) {
        shareInviteApp(message: "Google", link: "htttp://google.com", controller: self)
    }
}
