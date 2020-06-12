//
//  BoostViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 22/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol BoostProtocol: class {
}

class BoostViewController: UIViewController, BoostProtocol {
    //var interactor : BoostInteractorProtocol?
    var presenter : BoostPresentationProtocol?
    
    // MARK: Object lifecycle
    
    @IBOutlet var btnBoostColl: [UIButton]!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        let interactor = BoostInteractor()
        let presenter = BoostPresenter()
        
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
        self.dismissVC(completion: nil)
    }
    
    @IBAction func btnContinueAction(_ sender: UIButton) {
        self.dismissVC(completion: nil)
    }
    
    @IBAction func btnBoostAction(_ sender: UIButton) {
        
        btnBoostColl.forEach{
            $0.isSelected = false
        }
        sender.isSelected = true
    }
}
