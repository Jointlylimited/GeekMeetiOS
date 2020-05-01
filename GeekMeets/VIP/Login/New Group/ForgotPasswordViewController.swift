//
//  ForgotPasswordViewController.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 20/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ForgotPasswordProtocol: class {
    func getForgotPasswordResponse(response : CommonResponse)
}

class ForgotPasswordViewController: UIViewController, ForgotPasswordProtocol {
    //var interactor : ForgotPasswordInteractorProtocol?
    var presenter : ForgotPasswordPresentationProtocol?
    
    @IBOutlet weak var btnSend: GradientButton!
    @IBOutlet weak var tfEmail: BottomBorderTF!
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
    }

    func doSomething() {
        //            self.navigationController?.setNavigationBarHidden(false, animated: true)
        //            self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationItem.leftBarButtonItem = leftSideBackBarButton
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
  }

//MARK: IBAction Method
extension ForgotPasswordViewController{
    @IBAction func actionSend(_ sender: Any) {
        self.presenter?.callForgotPasswordAPI(email : "nik@gmail.com")
    }
}

extension ForgotPasswordViewController{
    func getForgotPasswordResponse(response : CommonResponse) {
        if response.responseCode == 200 {
            print(response)
        } else {
        }
         self.popVC()
    }
}
