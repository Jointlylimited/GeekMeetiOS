//
//  UserProfileViewController.swift
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
import Photos

protocol UserProfileProtocol: class {
    func displayAlert(strTitle : String, strMessage : String)
}

class UserProfileViewController: UIViewController, UserProfileProtocol,UIScrollViewDelegate {
    //var interactor : UserProfileInteractorProtocol?
    var presenter : UserProfilePresentationProtocol?
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var tfName: BottomBorderTF!
    @IBOutlet weak var tfDoB: BottomBorderTF!
    @IBOutlet weak var tfCompanyDetail: BottomBorderTF!
    @IBOutlet weak var tfAbout: BottomBorderTF!
    @IBOutlet weak var imgprofile: UIImageView!
    @IBOutlet weak var btnContinue: GradientButton!
    @IBOutlet weak var btnWork: UIButton!
    @IBOutlet weak var btnStudy: UIButton!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    @IBOutlet weak var btnPreferNottoSay: UIButton!
    
    var signUpParams : Dictionary<String, String>?
    var selectedGender : String = "0"
    var currentStatus : String = "0"
    var imgString : String = ""
    var tiAge : Int = 0
    
    // MARK: DatePicker
    @IBOutlet weak var PickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
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
        let interactor = UserProfileInteractor()
        let presenter = UserProfilePresenter()
        
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
        
        self.datePicker.maximumDate = Date()
        scrollView.delegate = self
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = leftSideBackBarButton
        imgprofile.setCornerRadius(radius: imgprofile.frame.size.width/2)
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgprofile.isUserInteractionEnabled = true
        imgprofile.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        print( "Your action")
        Getimage()
    }
    
    
    @IBAction func btnSelectGender(sender:UIButton){
        
        let buttonArray = [btnMale,btnFemale,btnOther,btnPreferNottoSay]
        
        buttonArray.forEach{
            
            $0?.isSelected = false
        }
        
        sender.isSelected = true
        selectedGender = "\(sender.tag)"
        
    }
    
    @IBAction func btnCurrentStatusClicked(sender:UIButton){
        
        let buttonArray = [btnWork,btnStudy]
        
        buttonArray.forEach{
            
            $0?.isSelected = false
        }
        
        sender.isSelected = true
        currentStatus = "\(sender.tag)"
        
    }
    
    
    @IBAction func actionContinue(_ sender: Any) {
        
        let params = RequestParameter.sharedInstance().signUpParam(vEmail: signUpParams!["vEmail"]!, vPassword: signUpParams!["vPassword"]!, vConfirmPassword : signUpParams!["vConfirmPassword"]!, vCountryCode: signUpParams!["vCountryCode"]!, vPhone: signUpParams!["vPhone"]!, termsChecked : signUpParams!["termsChecked"]!, vProfileImage: self.imgString, vName: tfName.text ?? "", dDob: tfDoB.text ?? "", tiAge: "\(tiAge)", tiGender: selectedGender, iCurrentStatus: currentStatus, txCompanyDetail: tfCompanyDetail.text ?? "", txAbout: tfAbout.text ?? "", photos: "", vTimeOffset: "", vTimeZone: "")
        
        self.presenter?.callSignUpRequest(signUpParams: params)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
            
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    @IBAction func btnDonePickerAction(_ sender: UIBarButtonItem) {
        self.PickerView.alpha = 0.0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let strDate = dateFormatter.string(from: datePicker.date)
        tfDoB.text = strDate
        tiAge = datePicker.date.age
    }
    func displayAlert(strTitle : String, strMessage : String) {
        self.showAlert(title: strTitle, message: strMessage)
    }
    
    func hideKeyboard() {
        tfName?.resignFirstResponder()
        tfCompanyDetail?.resignFirstResponder()
        tfAbout?.resignFirstResponder()
    }
}


extension UserProfileViewController:  UINavigationControllerDelegate, UIImagePickerControllerDelegate {
 
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     let image = info[UIImagePickerController.InfoKey.originalImage]
//    imgprofile.image = image as! UIImage
//     picker.dismiss(animated: true, completion: nil);
     picker.dismiss(animated: true, completion: nil)
     if #available(iOS 11.0, *) {
         if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset{
             if let fileName = asset.value(forKey: "filename") as? String{
                 print(fileName)
                 self.imgString = fileName
             }
         }else{
                self.imgString = info[UIImagePickerController.InfoKey.imageURL] as! String
          
              }
         if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
             self.imgprofile.image = image
              
           
         }
     } else {
         if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                 self.imgprofile.image = image
             if let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                 let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                 let assetResources = PHAssetResource.assetResources(for: result.firstObject!)
                 
                 print(assetResources.first!.originalFilename)
                 self.imgString = assetResources.first!.originalFilename
             }
         }
     }
  }
  
  func Getimage(){
    let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
           alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
               self.openCamera()
           }))

           alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
               self.openGallery()
           }))

           alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

           self.present(alert, animated: true, completion: nil)
    
  }
  
  
  
  func openCamera()
  {
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
          let imagePicker = UIImagePickerController()
          imagePicker.delegate = self
          imagePicker.sourceType = UIImagePickerController.SourceType.camera
          imagePicker.allowsEditing = false
          self.present(imagePicker, animated: true, completion: nil)
      }
      else
      {
          let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
        
      }
  }
  func openGallery()
  {
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
          let imagePicker = UIImagePickerController()
          imagePicker.delegate = self
          imagePicker.allowsEditing = false
          imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
          self.present(imagePicker, animated: true, completion: nil)
      }
      else
      {
          let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
      }
  }

}

extension UserProfileViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField != tfDoB {
                   self.PickerView.alpha = 0.0
                   
               } else {
                   self.PickerView.alpha = 1.0
                   self.hideKeyboard()
                   return false
               }
        self.PickerView.alpha = 1.0
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension Date {
    var age: Int { Calendar.current.dateComponents([.year], from: self, to: Date()).year! }
}
