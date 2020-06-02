//
//  SignUpVCViewController.swift
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
import CoreLocation

protocol SignUpVCProtocol: class {
    func displayAlert(strTitle : String, strMessage : String)
}

class SignUpVCViewController: UIViewController, SignUpVCProtocol {
    
    
    //var interactor : SignUpVCInteractorProtocol?
    var presenter : SignUpVCPresentationProtocol?
    
    @IBOutlet weak var tfEmailAddress: BottomBorderTF!
    @IBOutlet weak var tfPassword: BottomBorderTF!
    @IBOutlet weak var tfConfirmPassword: BottomBorderTF!
    @IBOutlet weak var tfMobileNumber: BottomBorderTF!
    @IBOutlet weak var btnContinue: GradientButton!
    @IBOutlet weak var btnCountrycode: UIButton!
    
    var termsChecked : String = "0"
    var authResponse : UserAuthResponseField!
    var socialType : Bool = false
    var location:CLLocation?
    var vLiveIn : String = ""
    
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
        let interactor = SignUpVCInteractor()
        let presenter = SignUpVCPresenter()
        
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func doSomething() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationItem.leftBarButtonItem = leftSideBackBarButton
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.getUserCurrentLocation()
        
        if UserDataModel.currentUser != nil && UserDataModel.SignUpUserResponse != nil {
            let user = UserDataModel.SignUpUserResponse
            self.tfEmailAddress.text = user?.email
            self.btnCountrycode.titleLabel?.text = "+1" //user?.vCountryCode
            self.tfMobileNumber.text = user?.phone
            
            self.tfPassword.isUserInteractionEnabled = false
            self.tfConfirmPassword.isUserInteractionEnabled = false
            
            self.tfPassword.placeholder = "Password needed"
            self.tfConfirmPassword.placeholder = "Confirm Password not needed"
        }
    }
    
    func setCountryPickerData(_ country : Country)
    {
        
        btnCountrycode.setTitle(country.dialingCode, for: .normal)
        //          btnCountryCode.setImage(country.flag?.resizeImage(targetSize:  CGSize(width: btnCountryCode.frame.height / 2, height: btnCountryCode.frame.height / 2)).withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    //MARK: IBAction Method
    func displayAlert(strTitle : String, strMessage : String) {
        self.showAlert(title: strTitle, message: strMessage)
    }
    @IBAction func actionContinue(_ sender: Any) {
        
        let params = RequestParameter.sharedInstance().signUpParam(vEmail: tfEmailAddress.text ?? "", vPassword: tfPassword?.text ?? "", vConfirmPassword : tfConfirmPassword.text ?? "", vCountryCode: btnCountrycode.titleLabel?.text ?? "", vPhone: tfMobileNumber.text ?? "", termsChecked : termsChecked, vSocialId : (UserDataModel.currentUser == nil || UserDataModel.currentUser?.tiIsSocialLogin == nil) ? "" : (UserDataModel.currentUser?.vSocialId!)!, vLiveIn : vLiveIn, fLatitude : self.location != nil ? "\(self.location?.coordinate.latitude ?? 0.0)" : "0.0", fLongitude: self.location != nil ? "\(self.location?.coordinate.longitude ?? 0.0)" : "0.0", tiIsSocialLogin : (UserDataModel.currentUser == nil || UserDataModel.currentUser?.tiIsSocialLogin == nil) ? "0" : "1")
        
        self.presenter?.callSignUpRequest(signUpParams: params)
    }
    
    
    @IBAction func actionSelectCountryCode(_ sender: Any) {
        CountryPickerWithSectionViewController.presentController(on: self) { (country: Country) in
            self.setCountryPickerData(country)
        }
    }
    @IBAction func btnPasswordShowHideClick(_ sender : UIButton)
    {
        sender.isSelected = !sender.isSelected
        tfPassword.isSecureTextEntry = !sender.isSelected
    }
    @IBAction func btnConfirmPasswordShowHideClick(_ sender : UIButton)
    {
        sender.isSelected = !sender.isSelected
        tfConfirmPassword.isSecureTextEntry = !sender.isSelected
    }
    @IBAction func btnAgreeDisagree(_ sender : UIButton)
    {
        sender.isSelected = !sender.isSelected
        self.termsChecked = sender.isSelected == true ? "1" : "0"
    }
    
    func getUserCurrentLocation() {
        LocationManager.sharedInstance.getLocation { (currLocation, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                self.showAccessPopup(title: kLocationAccessTitle, msg: kLocationAccessMsg)
                return
            }
            guard let _ = currLocation else {
                return
            }
            if error == nil {
                self.location = currLocation
                self.getAddressFromLatLon(pdblLatitude:(currLocation?.coordinate.latitude)!, withLongitude: (currLocation?.coordinate.longitude)!)
            }
        }
    }
    
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = pdblLatitude
        //21.228124
        let lon: Double = pdblLongitude
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                    return
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country)
                    print(pm.locality)
                    print(pm.subLocality)
                    print(pm.thoroughfare)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
                    var addressString : String = ""
//                    if pm.name != nil {
//                        addressString = addressString + pm.name! + ", "
//                    }
//                    if pm.subLocality != nil {
//                        addressString = addressString + pm.subLocality! + ", "
//                    }
//                    if pm.thoroughfare != nil {
//                        addressString = addressString + pm.thoroughfare! + ", "
//                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
//                    if pm.postalCode != nil {
//                        addressString = addressString + pm.postalCode! + " "
//                    }
                    self.vLiveIn = addressString
                    print(addressString)
                }
        })
        
    }
}

extension SignUpVCViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        if textField == self.tfPassword {
            if (textField.text?.count)! <= 20 {
                return true
            }
        }
        if textField == self.tfConfirmPassword {
            if (textField.text?.count)! <= 20 {
                return true
            }
        }
        return true
    }
    
    @objc func textFieldDidChange(textField : UITextField){
        
        if textField == self.tfPassword {
            if (textField.text?.count)! <= 20 {
                textField.isUserInteractionEnabled = true
            } else {
                textField.resignFirstResponder()
            }
        }
        if textField == self.tfConfirmPassword {
            if (textField.text?.count)! <= 20 {
                textField.isUserInteractionEnabled = true
            } else {
                textField.resignFirstResponder()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
