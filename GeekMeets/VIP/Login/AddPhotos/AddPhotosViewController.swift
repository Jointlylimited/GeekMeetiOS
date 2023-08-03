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
import OpalImagePicker

protocol AddPhotosProtocol: class {
    func displayAlert(strTitle : String, strMessage : String)
}

class AddPhotosViewController: UIViewController, AddPhotosProtocol {
    //var interactor : AddPhotosInteractorProtocol?
    var presenter : AddPhotosPresentationProtocol?
    
    @IBOutlet weak var clnAddPhoto: UICollectionView!
    @IBOutlet weak var btnDone: GradientButton!
    
    //USER PHOTOS
    var imgsUserPhotos:[UIImage] = []
    var imgsUserPhotosDict:[NSDictionary] = []
    var signUpParams : Dictionary<String, String>?
    var imgProfile : UIImage?
    var userPhotosModel : [UserPhotosModel] = []
    var opimagePicker = OpalImagePickerController()
    
    var thumbURlUpload: (path: String, name: String) {
        let folderName = user_Profile
        let timeStamp = Authentication.sharedInstance().GetCurrentTimeStamp()
        let imgExtension = ".jpeg"
        let path = "\(folderName)\(timeStamp)\(imgExtension)"
        return (path: path, name: "\(timeStamp)\(imgExtension)")
    }
    
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
        setTheme()
    }
    
    func setTheme() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = leftSideBackBarButton
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        // Profile image set
        userPhotosModel.append(UserPhotosModel(iMediaId: 1, vMedia: self.thumbURlUpload.name, vMediaPath: self.thumbURlUpload.path, tiMediaType: 1, tiImage: imgProfile, tiIsDefault: 1, reaction: []))
    }
    
    //MARK: IBAction Method
    @IBAction func actionDone(_ sender: Any) {
        
        if self.userPhotosModel.count == 0 {
            AppSingleton.sharedInstance().showAlert("Select at least one image.", okTitle: "OK")
            return
        }
        
        for photo in userPhotosModel {
            if  photo.tiImage != nil {
                self.imgsUserPhotosDict.append(["tiImage": photo.tiImage!, "vMedia": photo.vMedia!, "vMediaPath" : photo.vMediaPath!, "tiIsDefault": photo.tiIsDefault!])
            }
        }
        
        let params = RequestParameter.sharedInstance().signUpInfoParam(vProfileImage: signUpParams!["vProfileImage"]!, vName: signUpParams!["vName"]!, dDob: signUpParams!["dDob"]!, tiAge: signUpParams!["tiAge"]!, tiGender: signUpParams!["tiGender"]!, iCurrentStatus: signUpParams!["iCurrentStatus"]!, txCompanyDetail: signUpParams!["txCompanyDetail"]!, txAbout: signUpParams!["txAbout"]!, photos: self.imgsUserPhotosDict.count > 0 ? "photos" : "")
        
        self.presenter?.callUserSignUpAPI(signParams: params, images : imgsUserPhotosDict)
    }
    
    func displayAlert(strTitle : String, strMessage : String) {
        self.showAlert(title: strTitle, message: strMessage)
    }
}

extension AddPhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,OptionButtonsDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if userPhotosModel.count == 20{
            return userPhotosModel.count
        }
        return userPhotosModel.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell : AddPhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPhotoCell", for: indexPath) as! AddPhotoCollectionViewCell
        //        cell.tutorialData = self.tutorialData[indexPath.row]
        cell.btnRemoveImg.isHidden = true
        cell.btnAddImg.isHidden = false
        cell.imgPhotos.isHidden = true
        if indexPath.row < userPhotosModel.count {
            cell.imgPhotos.isHidden = false
            cell.imgPhotos.image = userPhotosModel[indexPath.row].tiImage
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
        userPhotosModel.remove(at: index.row)
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
                }
            }else{
                if (picker.sourceType == UIImagePickerController.SourceType.camera) {
                    
                    let imgName = UUID().uuidString
                    let documentDirectory = NSTemporaryDirectory()
                    let localPath = documentDirectory.appending(imgName)
                    
                    let data = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!.jpegData(compressionQuality: 0.3)! as NSData
                    data.write(toFile: localPath, atomically: true)
                    let photoURL = URL.init(fileURLWithPath: localPath)
                    
                }else{
                    let imgString = (info[UIImagePickerController.InfoKey.imageURL] as! URL).lastPathComponent
                }
            }
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                imgTemp = image
            }
            self.clnAddPhoto.reloadData()
            
        } else {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                imgTemp = image
                if let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                    let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                    let assetResources = PHAssetResource.assetResources(for: result.firstObject!)
                    let file = assetResources.first!.originalFilename
                    print(assetResources.first!.originalFilename)
                }
            }
        }
        
        let imgData = NSData(data: (imgTemp).jpegData(compressionQuality: 1)!)
        var imageSize: Int = imgData.count
        print("actual size of image in KB: %f ", Double(imageSize) / 1000.0)
        
        if (Double(imageSize) / 1000.0) > 5000{
            let imgDataa = NSData(data: (imgTemp).jpegData(compressionQuality: 0.5)!)
            let image = UIImage(data: imgDataa as Data)
            let IsDefault = self.userPhotosModel.count == 0 ? 1 : 0
            self.userPhotosModel.append(UserPhotosModel(iMediaId: 1, vMedia: self.thumbURlUpload.name, vMediaPath: self.thumbURlUpload.path, tiMediaType: 1, tiImage: image, tiIsDefault: IsDefault, reaction: []))
        }else{
            let IsDefault = self.userPhotosModel.count == 0 ? 1 : 0
            self.userPhotosModel.append(UserPhotosModel(iMediaId: 1, vMedia: self.thumbURlUpload.name, vMediaPath: self.thumbURlUpload.path, tiMediaType: 1, tiImage: imgTemp, tiIsDefault: IsDefault, reaction: []))
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
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.allowsEditing = true
//            imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
            self.opimagePicker.imagePickerDelegate = self
            self.opimagePicker.maximumSelectionsAllowed = 10
            self.present(self.opimagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension AddPhotosViewController : OpalImagePickerControllerDelegate {
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        picker.dismiss(animated: true, completion: nil)
        for asset in assets {
            if #available(iOS 11.0, *) {
//                if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset{
                    if let fileName = asset.value(forKey: "filename") as? String{
                        print(fileName)
                    }
//                }
//                if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    
//                    let IsDefault = self.userPhotosModel.count == 0 ? 1 : 0
////                self.userPhotosModel.append(UserPhotosModel(iMediaId: 1, vMedia: self.thumbURlUpload.name, vMediaPath: self.thumbURlUpload.path, tiMediaType: 1, tiImage: asset.getUIImage(asset: asset), tiIsDefault: IsDefault, reaction: []))
//                    if IsDefault == 1 {
//                        self.imgProfile.image = self.userPhotosModel[0].tiImage
//                    }
//                }
                
                let imgData = NSData(data: (asset.getUIImage(asset: asset))!.jpegData(compressionQuality: 1)!)
                var imageSize: Int = imgData.count
                print("actual size of image in KB: %f ", Double(imageSize) / 1000.0)
                
                if (Double(imageSize) / 1000.0) > 5000{
                    let imgDataa = NSData(data: (asset.getUIImage(asset: asset))!.jpegData(compressionQuality: 0.5)!)
                    let image = UIImage(data: imgDataa as Data)
                    let IsDefault = self.userPhotosModel.count == 0 ? 1 : 0
                    self.userPhotosModel.append(UserPhotosModel(iMediaId: 1, vMedia: self.thumbURlUpload.name, vMediaPath: self.thumbURlUpload.path, tiMediaType: 1, tiImage: image, tiIsDefault: IsDefault, reaction: []))
                }else{
                    let IsDefault = self.userPhotosModel.count == 0 ? 1 : 0
                    self.userPhotosModel.append(UserPhotosModel(iMediaId: 1, vMedia: self.thumbURlUpload.name, vMediaPath: self.thumbURlUpload.path, tiMediaType: 1, tiImage: asset.getUIImage(asset: asset), tiIsDefault: IsDefault, reaction: []))
                }
                
                self.clnAddPhoto.reloadData()
            } else {
//                if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    
//                    let IsDefault = self.userPhotosModel.count == 0 ? 1 : 0
//                    self.userPhotosModel.append(UserPhotosModel(iMediaId: 1, vMedia: self.thumbURlUpload.name, vMediaPath: self.thumbURlUpload.path, tiMediaType: 1, tiImage: image, tiIsDefault: IsDefault, reaction: []))
//                    if IsDefault == 1 {
//                        self.imgProfile.image = self.userPhotosModel[0].tiImage
//                    }
////                    if let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
//                        let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
//                        let assetResources = PHAssetResource.assetResources(for: result.firstObject!)
//
//                        print(assetResources.first!.originalFilename)
//                    }
//                }
            }
        }
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
