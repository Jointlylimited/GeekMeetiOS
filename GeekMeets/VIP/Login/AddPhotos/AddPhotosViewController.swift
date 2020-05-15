//
//  AddPhotosViewController.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 21/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Photos

protocol AddPhotosProtocol: class {
    func displayAlert(strTitle : String, strMessage : String)
}

class AddPhotosViewController: UIViewController, AddPhotosProtocol {
    //var interactor : AddPhotosInteractorProtocol?
    var presenter : AddPhotosPresentationProtocol?
    
    @IBOutlet weak var clnAddPhoto: UICollectionView!
    @IBOutlet weak var btnDone: GradientButton!
    
    //USER PHOTOS
    var imgsUserPhotosStr:[String] = []
    var imgsUserPhotos:[UIImage] = []
    var imgsUserPhotosDict:[NSDictionary] = []
    var signUpParams : Dictionary<String, String>?
    var imgProfile : UIImage?
    var location:CLLocation?
    
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
        let interactor = AddPhotosInteractor()
        let presenter = AddPhotosPresenter()
        
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
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = leftSideBackBarButton
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.getUserCurrentLocation()
        // Profile image set
        
        imgsUserPhotos.append(imgProfile!)
        imgsUserPhotosStr.append(signUpParams!["vProfileImage"]!)
    }

    //MARK: IBAction Method
    @IBAction func actionDone(_ sender: Any) {
       
        
        let photoJsonString = json(from: self.imgsUserPhotosDict)
        let params = RequestParameter.sharedInstance().signUpParam(vEmail: signUpParams!["vEmail"]!, vPassword: signUpParams!["vPassword"]!, vConfirmPassword : signUpParams!["vConfirmPassword"]!, vCountryCode: signUpParams!["vCountryCode"]!, vPhone: signUpParams!["vPhone"]!, termsChecked : signUpParams!["termsChecked"]!, vProfileImage: signUpParams!["vProfileImage"]!, vName: signUpParams!["vName"]!, dDob: signUpParams!["dDob"]!, tiAge: signUpParams!["tiAge"]!, tiGender: signUpParams!["tiGender"]!, iCurrentStatus: signUpParams!["iCurrentStatus"]!, txCompanyDetail: signUpParams!["txCompanyDetail"]!, txAbout: signUpParams!["txAbout"]!, photos: self.imgsUserPhotos.count > 0 ? photoJsonString! : "", vTimeOffset: vTimeOffset, vTimeZone: vTimeZone, vSocialId : signUpParams!["vSocialId"]!, fLatitude : self.location != nil ? "\(self.location?.coordinate.latitude ?? 0.0)" : "0.0", fLongitude: self.location != nil ? "\(self.location?.coordinate.longitude ?? 0.0)" : "0.0")
        
        self.presenter?.callUserSignUpAPI(signParams: params)
    }
    
    func json(from object:[NSDictionary]) -> String? {
            var yourString : String = ""
            do
            {
                if let postData : NSData = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
                {
                    yourString = NSString(data: postData as Data, encoding: String.Encoding.utf8.rawValue)! as String
                    return yourString
                }
            }
            catch
            {
                print(error)
            }
            return yourString
        }
        
        func displayAlert(strTitle : String, strMessage : String) {
            self.showAlert(title: strTitle, message: strMessage)
        }
        
        func getUserCurrentLocation() {
    //          LoaderView.sharedInstance.showLoader()
              LocationManager.sharedInstance.getLocation { (currLocation, error) in
                  if error != nil {
    //                  LoaderView.sharedInstance.hideLoader()
                      print(error?.localizedDescription ?? "")
                      self.showAccessPopup(title: kLocationAccessTitle, msg: kLocationAccessMsg)
                      return
                  }
                  guard let _ = currLocation else {
                      return
                  }
                  if error == nil {
    //                  LoaderView.sharedInstance.hideLoader()
                      self.location = currLocation
                    //UserDataModel.setUserLocation(location: self.location!)
                  }
              }
          }
}
extension AddPhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,OptionButtonsDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      if imgsUserPhotos.count == 20{
        return imgsUserPhotos.count
      }
      return imgsUserPhotos.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell : AddPhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPhotoCell", for: indexPath) as! AddPhotoCollectionViewCell
        //        cell.tutorialData = self.tutorialData[indexPath.row]
        cell.btnRemoveImg.isHidden = true
        cell.btnAddImg.isHidden = false
        cell.imgPhotos.isHidden = true
        if indexPath.row < imgsUserPhotos.count {
            cell.imgPhotos.isHidden = false
            cell.imgPhotos.image = imgsUserPhotos[indexPath.row] as UIImage
            cell.btnRemoveImg.isHidden = false
            cell.btnAddImg.isHidden = true
        }
        
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight = yourWidth
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    //DelegateMethod
    func closeFriendsTapped(at index: IndexPath) {
        Getimage()
    }
    
    func actionRemoveIMG(at index: IndexPath) {
        imgsUserPhotosStr.remove(at: index.row)
        imgsUserPhotos.remove(at: index.row)
        clnAddPhoto.reloadData()
    }
}

extension AddPhotosViewController:  UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage]
             picker.dismiss(animated: true, completion: nil)
            var imgTemp:UIImage = image as! UIImage
        if #available(iOS 11.0, *) {
            if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset{
                if let fileName = asset.value(forKey: "filename") as? String{
                    print(fileName)
                    imgsUserPhotosStr.append(fileName)
                    let dict = ["vMedia":fileName, "tiMediaType":1, "fHeight":asset.pixelHeight, "fWidth": asset.pixelWidth] as [String : Any]
                    imgsUserPhotosDict.append(dict as NSDictionary)
                }
            }else{
              if (picker.sourceType == UIImagePickerController.SourceType.camera) {

                      let imgName = UUID().uuidString
                      let documentDirectory = NSTemporaryDirectory()
                      let localPath = documentDirectory.appending(imgName)

                let data = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!.jpegData(compressionQuality: 0.3)! as NSData
                      data.write(toFile: localPath, atomically: true)
                      let photoURL = URL.init(fileURLWithPath: localPath)
                      imgsUserPhotosStr.append(localPath)

                  }else{
                    let imgString = (info[UIImagePickerController.InfoKey.imageURL] as! URL).lastPathComponent
                    imgsUserPhotosStr.append(imgString)
                    }
              }
             
          
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                self.imgsUserPhotos.append(image)
              imgTemp = image
            }
            self.clnAddPhoto.reloadData()
        } else {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                self.imgsUserPhotos.append(image)
                  imgTemp = image
                if let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                    let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                    let assetResources = PHAssetResource.assetResources(for: result.firstObject!)
                    let file = assetResources.first!.originalFilename
                    print(assetResources.first!.originalFilename)
                    imgsUserPhotosStr.append(file)
                   
                    let dict = ["vMedia":file, "tiMediaType":1, "fHeight":image.size.height, "fWidth": image.size.width] as [String : Any]
                    imgsUserPhotosDict.append(dict as NSDictionary)
                }
            }
        }
      
      
      
      let imgData = NSData(data: (imgTemp).jpegData(compressionQuality: 1)!)
         var imageSize: Int = imgData.count
         print("actual size of image in KB: %f ", Double(imageSize) / 1000.0)
         
         if (Double(imageSize) / 1000.0) > 5000{
           let imgDataa = NSData(data: (imgTemp).jpegData(compressionQuality: 0.5)!)
           let image = UIImage(data: imgDataa as Data)
            self.imgsUserPhotos.append(image!)
         }else{
           self.imgsUserPhotos.append(imgTemp)
         }
      
      
      
        clnAddPhoto.reloadData()
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
            imagePicker.allowsEditing = true
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
            imagePicker.allowsEditing = true
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
