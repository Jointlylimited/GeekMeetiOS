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
    
    @IBOutlet weak var lblCompanynsdSchoolDetail: UILabel!
    var signUpParams : Dictionary<String, String>?
    var selectedGender : String = "0"
    var currentStatus : String = "1"
    var imgString : String = ""
    var tiAge : Int = 0
    var imagePicker: UIImagePickerController!
    
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

    func doSomething() {
        
        if UserDataModel.SignUpUserResponse != nil {
            let user = UserDataModel.SignUpUserResponse
            self.tfName.text = "\(user?.firstName ?? "") \(user?.lastName ?? "")"
            self.tfDoB.text = user?.birthday
        }
        
        if UserDataModel.currentUser?.tiIsAdmin == 1 {
            let user = UserDataModel.currentUser
            self.tfName.text = "\(user!.vName!)"
        }
        
        var components = DateComponents()
        components.year = -18
        
        let minData = Calendar.current.date(byAdding: components, to: Date())
        self.datePicker.maximumDate = minData
        scrollView.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.leftBarButtonItem = leftSideBackBarButton
        imgprofile.setCornerRadius(radius: imgprofile.frame.size.width/2)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgprofile.isUserInteractionEnabled = true
        imgprofile.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        print( "Your action")
        Getimage()
    }
    
    @IBAction func btnSelectImageAction(_ sender: UIButton) {
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
        if currentStatus == "1"{
            lblCompanynsdSchoolDetail.text = "Enter Company Detail"
            tfCompanyDetail.placeholder = "Enter Company Name / Designation Name"
        } else{
            lblCompanynsdSchoolDetail.text = "Enter College/School Detail"
            tfCompanyDetail.placeholder = "Enter College/School Name"
        }
    }
    
    @IBAction func actionContinue(_ sender: Any) {
        
       let params = RequestParameter.sharedInstance().signUpInfoParam(vProfileImage: self.imgString, vName: tfName.text ?? "", dDob: tfDoB.text?.inputDateStrToAPIDateStr(dateStr: tfDoB.text!) ?? "", tiAge: "\(tiAge)", tiGender: selectedGender, iCurrentStatus: currentStatus, txCompanyDetail: tfCompanyDetail.text ?? "", txAbout: tfAbout.text ?? "", photos: "")
        
        self.presenter?.callSignUpRequest(signUpParams: params,profileimg: imgprofile.image!)
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
        picker.dismiss(animated: true, completion: nil)
        var imgTemp:UIImage = image as! UIImage
        if #available(iOS 11.0, *) {
            if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset{
                if let fileName = asset.value(forKey: "filename") as? String{
                    print(fileName)
                    self.imgString = fileName
                }
            }else{
                if (picker.sourceType == UIImagePickerController.SourceType.camera) {
                    
                    let imgName = UUID().uuidString
                    let documentDirectory = NSTemporaryDirectory()
                    let localPath = documentDirectory.appending(imgName)
                    
                    let data = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!.jpegData(compressionQuality: 0.3)! as NSData
                    data.write(toFile: localPath, atomically: true)
                    let photoURL = URL.init(fileURLWithPath: localPath)
                    self.imgString = localPath
                    
                }else{
                    let imgString = (info[UIImagePickerController.InfoKey.imageURL] as! URL).absoluteString
                    self.imgString = imgString
                    self.imgString = "IMG001.jpeg"
                }
            }
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                imgTemp = image
            }
            
        } else {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                imgTemp = image
                if let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                    let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                    let assetResources = PHAssetResource.assetResources(for: result.firstObject!)
                    
                    print(assetResources.first!.originalFilename)
                    self.imgString = assetResources.first!.originalFilename
                }
            }
        }
        
        let imgData = NSData(data: (imgTemp).jpegData(compressionQuality: 1)!)
        var imageSize: Int = imgData.count
        print("actual size of image in KB: %f ", Double(imageSize) / 1000.0)
        
        if (Double(imageSize) / 1000.0) > 5000{
            let imgDataa = NSData(data: (imgTemp).jpegData(compressionQuality: 0.5)!)
            let image = UIImage(data: imgDataa as Data)
            self.imgprofile.image = image
        }else{
            self.imgprofile.image = imgTemp
        }
    }
    func Getimage(){
        
        let camera = "Camera"
        let photoGallery = "Gallery"
        let cancel = "Cancel"
        UIAlertController.showAlertWith(title: nil, message: nil, style: .actionSheet, buttons: [camera,photoGallery,cancel], controller: self) { (action) in
            if action == camera {
                self.openCamera()
            } else if action == photoGallery {
                self.openGallery()
            }
        }
    }
    
    
    
    func openCamera()
    {
        cameraAccess { [weak self] (status, isGrant) in
            guard let `self` = self else {return}
            if isGrant {
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                    self.imagePicker = UIImagePickerController()
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = UIImagePickerController.SourceType.camera;
                    self.imagePicker.allowsEditing = true
                    self.imagePicker.cameraCaptureMode = .photo
                    self.imagePicker.cameraDevice = .front
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            } else {
                self.showAccessPopup(title: kCameraAccessTitle, msg: kCameraAccessMsg)
            }
        }
    }
    func openGallery()
    {
        photoLibraryAccess { [weak self] (status, isGrant) in
            guard let `self` = self else {return}
            if isGrant {
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                    self.imagePicker = UIImagePickerController()
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
                    self.imagePicker.allowsEditing = false
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            }
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
    
    func dateToTimeStamp() -> Int{
        let date = self
        
        let timeInterval = date.timeIntervalSince1970
        
        // convert to Integer
        let dateInt = Int(timeInterval)
        return dateInt
    }
}
