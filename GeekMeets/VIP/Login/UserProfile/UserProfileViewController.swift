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

protocol UserProfileProtocol: class {
    func displaySomething()
}

class UserProfileViewController: UIViewController, UserProfileProtocol,UIScrollViewDelegate {
    //var interactor : UserProfileInteractorProtocol?
    var presenter : UserProfilePresentationProtocol?
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfAge: UITextField!
    @IBOutlet weak var tfCompanyDetail: UITextField!
    @IBOutlet weak var tfAbout: UITextField!
    @IBOutlet weak var imgprofile: UIImageView!
    @IBOutlet weak var btnContinue: GradientButton!
    @IBOutlet weak var btnWork: UIButton!
    @IBOutlet weak var btnStudy: UIButton!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    @IBOutlet weak var btnPreferNottoSay: UIButton!
  
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

      scrollView.delegate = self
      self.navigationController?.isNavigationBarHidden = false
      self.navigationItem.leftBarButtonItem = leftSideBackBarButton
      tfName.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
      tfAge.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
      tfAbout.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
      tfCompanyDetail.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
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


    }
      
    @IBAction func btnCurrentStatusClicked(sender:UIButton){

        let buttonArray = [btnWork,btnStudy]

        buttonArray.forEach{

            $0?.isSelected = false
        }

        sender.isSelected = true


    }
  
  
  @IBAction func actionContinue(_ sender: Any) {
    
     self.presenter?.actionContinue()
  }
  func displaySomething() {
        //nameTextField.text = viewModel.name
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
       if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
          navigationController?.setNavigationBarHidden(true, animated: true)

       } else {
          navigationController?.setNavigationBarHidden(false, animated: true)
       }
    }
}


extension UserProfileViewController:  UINavigationControllerDelegate, UIImagePickerControllerDelegate {
 
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     let image = info[UIImagePickerController.InfoKey.originalImage]
    imgprofile.image = image as! UIImage
     picker.dismiss(animated: true, completion: nil);
     
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
