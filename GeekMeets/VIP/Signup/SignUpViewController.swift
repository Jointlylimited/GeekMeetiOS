//
//  SignUpViewController.swift
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

protocol SignUpProtocol: class {
    func displayAlert(strTitle : String, strMessage : String)
}

class SignUpViewController: UIViewController, SignUpProtocol {
    //var interactor : SignUpInteractorProtocol?
    var presenter : SignUpPresentationProtocol?
    
    @IBOutlet weak var txtUserName : UITextField?
    @IBOutlet weak var txtFirstName : UITextField?
    @IBOutlet weak var txtLastName : UITextField?
    @IBOutlet weak var txtEmail : UITextField?
    @IBOutlet weak var txtPassword : UITextField?
    @IBOutlet weak var txtConfirmPassword : UITextField?
    
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
        let interactor = SignUpInteractor()
        let presenter = SignUpPresenter()
        
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
         
        if ez.isDebug {
            txtUserName?.text = "ht14"
            txtFirstName?.text = "ht14"
            txtLastName?.text = "ht14"
            txtEmail?.text = "ht14@gmail.com"
            txtPassword?.text = "12345678"
            txtConfirmPassword?.text = "12345678"
        }
    }
    
    @IBAction func actionSignUp() {
        
        let img1 = UIImage(named: "image_1")
        let img2 = UIImage(named: "image_2")
        let img3 = UIImage(named: "image_3")
                
//        let params = RequestParameter.sharedInstance().signUpParam(vUserName: (txtUserName?.text)!, vFirstName: (txtFirstName?.text)!, vLastName: (txtLastName?.text)!, vEmailId: (txtEmail?.text)!, vPassword: (txtPassword?.text)!, images: nil)
//        self.presenter?.callSignUpRequest(signUpParams: params)
    }
    
    @IBAction func actionCheckData() {
        self.presenter?.callCheckData()
    }
    
    func displayAlert(strTitle : String, strMessage : String) {
        self.showAlert(title: strTitle, message: strMessage)
    }
    
    @IBAction func actionBack() {
        self.popVC()
    }
}
