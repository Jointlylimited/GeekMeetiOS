//
//  ChangePasswordViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 28/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ChangePasswordProtocol: class {
      func getChangePasswordResponse(response : CommonResponse)
      func displayAlert(_ success : Bool, message : String)
      func displayAlert(strTitle : String, strMessage : String)
}

class ChangePasswordViewController: UIViewController, ChangePasswordProtocol {
    //var interactor : ChangePasswordInteractorProtocol?
    var presenter : ChangePasswordPresentationProtocol?
    
    @IBOutlet weak var txtOldPassword : UITextField?
    @IBOutlet weak var txtNewPassword : UITextField?
    @IBOutlet weak var txtConfirmPassword : UITextField?
    var alertView: CustomAlertView!
    
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
        let interactor = ChangePasswordInteractor()
        let presenter = ChangePasswordPresenter()
        
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
    
    @IBAction func actionHideShow(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.tag == 1 {
            
            if sender.isSelected {
                txtOldPassword?.isSecureTextEntry = false
            } else {
                txtOldPassword?.isSecureTextEntry = true
            }
        } else  if sender.tag == 2 {
            if sender.isSelected {
                txtNewPassword?.isSecureTextEntry = false
            } else {
                txtNewPassword?.isSecureTextEntry = true
            }
        } else {
            if sender.isSelected {
                txtConfirmPassword?.isSecureTextEntry = false
            } else {
                txtConfirmPassword?.isSecureTextEntry = true
            }
        }
    }
    
    @IBAction func btnChangePasswordAction(_ sender: GradientButton) {
        self.presenter?.callChangePasswordAPI(vCurrentPassword: txtOldPassword!.text!, vNewPassword:  txtNewPassword!.text!, vConfirmPassword:  txtConfirmPassword!.text!)
    }
    
    func getChangePasswordResponse(response : CommonResponse) {
        if response.responseCode == 200 {
            AppSingleton.sharedInstance().logout()
            AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle: "OK")
        } else {
            AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle: "OK")
        }
    }
    
    func displayAlert(_ success: Bool, message: String) {
        alertView = CustomAlertView.initAlertView(title: "", message: message, btnRightStr: "", btnCancelStr: "", btnCenter: "OK", isSingleButton: true)
        alertView.delegate1 = self
        alertView.frame = self.view.frame
        self.view.addSubview(alertView)
    }
    
    func displayAlert(strTitle : String, strMessage : String) {
        self.showAlert(title: strTitle, message: strMessage)
    }
}

extension ChangePasswordViewController : AlertViewCentreButtonDelegate {
    
    func centerButtonAction() {
      alertView.isHidden = true
    }
}
