//
//  ManageSubscriptionViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 23/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ManageSubscriptionProtocol: class {
}

class ManageSubscriptionViewController: UIViewController, ManageSubscriptionProtocol {
    //var interactor : ManageSubscriptionInteractorProtocol?
    var presenter : ManageSubscriptionPresentationProtocol?
    
    // MARK: Object lifecycle
    
    @IBOutlet var btnSubColl: [UIButton]!
    @IBOutlet var btnStackList: [UIButton]!
    
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
        let interactor = ManageSubscriptionInteractor()
        let presenter = ManageSubscriptionPresenter()
        
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
        setTheme()
    }
    
    func setTheme(){
        for btn in btnStackList {
            btn.titleLabel?.font = DeviceType.iPhone5orSE ? UIFont(name: FontTypePoppins.Poppins_Medium.rawValue, size: 12.0) : UIFont(name: FontTypePoppins.Poppins_Medium.rawValue, size: 16.0)
        }
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismissVC(completion: nil)
    }
    
    @IBAction func btnContinueAction(_ sender: UIButton) {
        self.dismissVC(completion: nil)
    }
    
    @IBAction func btnSubscriptionAction(_ sender: UIButton) {
        btnSubColl.forEach{
            $0.isSelected = false
        }
        sender.isSelected = true
    }
}
