//
//  EditProfileViewController.swift
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
import Photos
import SDWebImage

protocol SocialMediaLinkDelegate {
    func updatedSocailLinkModel(model : UserAuthResponseField)
}

protocol SelectInterestAgeGenderDelegate {
    func getSelectedValue(index : Int, data : String)
    
}
enum EditProfileListCells {
    
    case InformationCell(obj : String)
    case InterestCell
    case PhotosCell
    case SocialCell
    case PrivacyCell
    
    var cellHeight  : CGFloat {
        switch self {
        case .InformationCell(let desc):
           return 50  //return */ desc.heightWithConstrainedWidth(width: 374 * _widthRatio,font: fontPoppins(fontType: .Poppins_Medium, fontSize: .sizeNormalTextField)) + 16
        case .InterestCell, .PhotosCell, .SocialCell, .PrivacyCell:
            return 50
            
        }
    }
    
    var cellRowHeight  : CGFloat {
        switch self {
            
        case .InformationCell(let desc):
            return desc.heightWithConstrainedWidth(width: 374 * _widthRatio,font: fontPoppins(fontType: .Poppins_Medium, fontSize: .sizeNormalTextField)) + 450//480
        case .InterestCell:
            return 130
        case .PhotosCell:
            return DeviceType.iPhone5orSE ? 330 : 390
        case .SocialCell:
            return 225
        case .PrivacyCell:
            return 230
        }
    }
    
    var headerHeight: CGFloat {
        switch self {
//        case .PrivacyCell:
//            return 90
        case .InformationCell, .InterestCell, .PhotosCell, .SocialCell, .PrivacyCell:
        return 45
        }
    }
    
    var cellID: String {
        switch self {
            
        case .InformationCell:
            return "EditInformationCell"
        case .InterestCell:
            return "EditInterestCell"
        case .PhotosCell:
            return "EditPhotosCell"
        case .SocialCell:
            return "EditSocialLinkCell"
        case .PrivacyCell:
            return "EditProfilePrivacyCell"
            
        }
    }
    
    var sectionTitle: String {
        switch self {
        case .InformationCell:
            return "Edit Information"
        case .InterestCell:
            return "Interests & Preferences"
        case .PhotosCell:
            return "Photos"
        case .SocialCell:
            return "Social Media Links"
        case .PrivacyCell:
            return "Profile Privacy Settings (only for subscribers)"
        }
    }
    
    var isHeaderAvailable : Bool {
        switch self {
        case .InterestCell, .SocialCell:
            return true
        case .InformationCell, .PhotosCell, .PrivacyCell:
            return false
        }
    }
}

struct EditProfileData {
  
  var cells: [EditProfileListCells] {
    var cell: [EditProfileListCells] = []
    
    let str = "Lady with fun loving personality and open- minded, Looking for Someone to hang out always open for hangout"
    cell.append(.InformationCell(obj: str))
    cell.append(.InterestCell)
    cell.append(.PhotosCell)
    cell.append(.SocialCell)
    cell.append(.PrivacyCell)
    
    return cell
  }
}

protocol EditProfileProtocol: class {
    func getEditProfileResponse(response: UserAuthResponse)
}

class EditProfileViewController: UIViewController, EditProfileProtocol {
    //var interactor : EditProfileInteractorProtocol?
    var presenter : EditProfilePresentationProtocol?
    
    @IBOutlet weak var tblEditProfileView: UITableView!
    @IBOutlet weak var PickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserNameAge: UILabel!
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var genderPickerView: UIView!
    
    var objEditProfileData = EditProfileData()
    var imageArray : [NSDictionary] = [] // [UIImage]  = []
    var userPhotosModel : [UserPhotosModel] = []
    var imagePicker: UIImagePickerController!
    var image : UIImage?
    
    var userProfileModel : UserAuthResponseField? //  UserProfileModel?
    var objQuestionModel = QuestionaryModel()
    var customProfileView: RecommandedProfileView!
    var genderArray : [String] = ["Male", "Female", "Others", "Prefer not to say"]
    var delegate : ProfileDataDelegate!
    var removePhotoStr = ""
    
    
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
        let interactor = EditProfileInteractor()
        let presenter = EditProfilePresenter()
        
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tblEditProfileView.reloadData()
    }
    
    func setTheme(){
        
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        
        self.datePicker.maximumDate = Date()
        self.lblUserNameAge.text = "\(UserDataModel.currentUser?.vName ?? ""), \(UserDataModel.currentUser?.tiAge ?? 0)"
        
        if self.userProfileModel == nil {
            self.userProfileModel = UserDataModel.currentUser
        }
        
        //ProfileImage setup
        if userProfileModel?.vProfileImage != "" {
        
            let url = URL(string:"\(fileUploadURL)\(user_Profile)\(userProfileModel!.vProfileImage!)")
            print(url!)
            self.imgProfile.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "user_profile"))
        }
        
        for photo in UserDataModel.currentUser!.photos! {
            let photoModel = UserPhotosModel(iMediaId: photo.iMediaId, vMedia: photo.vMedia, tiMediaType: photo.tiMediaType, tiImage: nil, tiIsDefault: photo.tiIsDefault)
            userPhotosModel.append(photoModel)
        }
        self.objQuestionModel.arrQuestionnaire = callQuestionnaireApi()
        self.objQuestionModel.objQuestionnaire = QuestionnaireModel(dictionary: self.objQuestionModel.arrQuestionnaire[1])!
        self.tblEditProfileView.reloadData()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func btnUpdateAction(_ sender: GradientButton) {
        if self.userPhotosModel.count == 0 {
            AppSingleton.sharedInstance().showAlert("Select at least one image.", okTitle: "OK")
            return
        }
        
        for photo in userPhotosModel {
            if  photo.tiImage != nil {
                self.imageArray.append(["tiImage": photo.tiImage!, "vMedia": photo.vMedia!, "tiIsDefault": photo.tiIsDefault!, "msgType" : photo.tiMediaType!])
            }
        }
        
        let params = RequestParameter.sharedInstance().editProfileParam(vEmail: userProfileModel?.vEmail ?? "", vProfileImage: userProfileModel?.vProfileImage ?? "", vName: userProfileModel?.vName ?? "", dDob: userProfileModel?.dDob ?? "", tiAge: "\(userProfileModel?.tiAge ?? 0)", tiGender: "\(userProfileModel?.tiGender ?? 0)", vLiveIn: userProfileModel?.vLiveIn ?? "", txCompanyDetail: userProfileModel?.txCompanyDetail ?? "", txAbout: userProfileModel?.txAbout ?? "", deletephotos : self.removePhotoStr, photos: "", vInstaLink: userProfileModel?.vInstaLink ?? "", vSnapLink: userProfileModel?.vSnapLink ?? "", vFbLink: userProfileModel?.vFbLink ?? "", tiIsShowAge: "\(userProfileModel?.tiIsShowAge ?? 0)", tiIsShowDistance: "\(userProfileModel?.tiIsShowDistance ?? 0)", tiIsShowContactNumber: "\(userProfileModel?.tiIsShowContactNumber ?? 0)", tiIsShowProfileToLikedUser: "\(userProfileModel?.tiIsShowProfileToLikedUser ?? 0)")
        self.presenter?.callEdirProfileAPI(params: params, images : self.imageArray)
    }
    @IBAction func btnDonePickerAction(_ sender: UIBarButtonItem) {
        
        if sender.tag == 0 {
            self.PickerView.alpha = 0.0
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let strDate = dateFormatter.string(from: datePicker.date)
            print(strDate)
            self.userProfileModel?.dDob = strDate.inputDateStrToAPIDateStr(dateStr: strDate)
            self.userProfileModel?.tiAge = datePicker.date.age
        } else {
            self.genderPickerView.alpha = 0.0
        }
        self.tblEditProfileView.reloadData()
    }
    @IBAction func btnChooseProfileAction(_ sender: UIButton) {
        self.showSetProfileView()
    }
    
    @objc func btnChangeAction(sender : UIButton){
        if sender.tag == 1 {
            let discVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.DiscoverySettingScreen) as! DiscoverySettingViewController
            discVC.isFromMenu = false
            self.pushVC(discVC)
        } else {
            let socialVC = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.SocialMediaLink) as! SocialMediaLinkVC
            socialVC.delegate = self
            socialVC.userProfileModel = self.userProfileModel
            
            self.pushVC(socialVC)
        }
    }
    
    func showSetProfileView() {
       
        let imgString = userProfileModel!.vProfileImage != "" ? userProfileModel!.vProfileImage! : ""
        customProfileView = RecommandedProfileView.initAlertView(imgString : imgString)
        customProfileView.delegate = self
        customProfileView.frame = self.view.frame
        AppDelObj.window?.addSubview(customProfileView)
    }
    
    func getEditProfileResponse(response: UserAuthResponse){
        if response.responseCode == 200 {
            UserDataModel.currentUser = response.responseData
            if self.delegate != nil {
            }
            self.popVC()
            AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle: "OK")
        }
    }
}

extension EditProfileViewController : SocialMediaLinkDelegate {
    func updatedSocailLinkModel(model: UserAuthResponseField) {
        self.userProfileModel = model
        self.tblEditProfileView.reloadData()
    }
}
extension EditProfileViewController : RecommandedProfileViewDelegate {
    func SetProfileButtonAction() {
        self.customProfileView.alpha = 0.0
    }
    
    func NoButtonAction() {
        self.customProfileView.alpha = 0.0
    }
}

extension EditProfileViewController : SelectInterestAgeGenderDelegate {
    func getSelectedValue(index : Int, data : String){
        if index == 1 {
//            self.userProfileModel?.vInterestAge = data
        } else {
//            self.userProfileModel?.vInterestGender = data
        }
       self.tblEditProfileView.reloadData()
    }
}
extension EditProfileViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.objEditProfileData.cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: objEditProfileData.cells[indexPath.section].cellID)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if objEditProfileData.cells[indexPath.section].cellID == "EditInformationCell" {
            if let cell = cell as? EditInformationCell {
                
                cell.txtUserName.delegate = self
                cell.txtUserName.tag = 0
                cell.txtDoB.delegate = self
                cell.txtDoB.tag = 1
                cell.txtCity.delegate = self
                cell.txtCity.tag = 2
                cell.txtCompanyDetail.delegate = self
                cell.txtCompanyDetail.tag = 3
                cell.txtAbout.delegate = self
                cell.txtAbout.tag = 4
                
                cell.txtUserName.text = userProfileModel?.vName
                cell.txtAbout.text = userProfileModel?.txAbout
                
                cell.txtDoB.text = userProfileModel != nil ? userProfileModel?.dDob?.strDateTODateStr(dateStr: userProfileModel!.dDob!) : "02/01/1999"
                cell.txtCity.text = userProfileModel?.vLiveIn
                cell.txtGender.text = genderArray[(userProfileModel?.tiGender)!] //userProfileModel?.vGender
                cell.txtCompanyDetail.text = userProfileModel?.txCompanyDetail
                cell.lblCharCount.text = "\(userProfileModel!.txAbout!.count)/\(300)"
                cell.btnChange.underlineButton(text: "Change", font: UIFont(name: FontTypePoppins.Poppins_Regular.rawValue, size: 12)!, color: #colorLiteral(red: 0.5294117647, green: 0.1803921569, blue: 0.7647058824, alpha: 1))
                
                cell.clickOnChangeGender = {
                    self.genderPickerView.alpha = 1.0
                }
            }
        } else if objEditProfileData.cells[indexPath.section].cellID == "EditInterestCell" {
//            if let cell = cell as? EditInterestCell {
                
                let queVC = GeekMeets_StoryBoard.Questionnaire.instantiateViewController(withIdentifier: GeekMeets_ViewController.SelectAgeRange) as? SelectAgeRangeViewController
                queVC?.isFromSignUp = false
                
//            }
        } else if objEditProfileData.cells[indexPath.section].cellID == "EditPhotosCell" {
            if let cell = cell as? EditPhotosCell  {
                
                cell.AddPhotosCollView.register(UINib.init(nibName: Cells.PhotoEmojiCell, bundle: Bundle.main), forCellWithReuseIdentifier: Cells.PhotoEmojiCell)
                
                let layout = CustomImageLayout()
                layout.scrollDirection = .horizontal
                cell.AddPhotosCollView.collectionViewLayout = layout
                
                cell.AddPhotosCollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                cell.AddPhotosCollView.reloadData()
            }
        } else if objEditProfileData.cells[indexPath.section].cellID == "EditSocialLinkCell" {
            if let cell = cell as? EditSocialLinkCell {
                cell.txtFacebookLink.text = userProfileModel?.vFbLink
                cell.txtSnapchatLink.text = userProfileModel?.vSnapLink
                cell.txtInstagramLink.text = userProfileModel?.vInstaLink
            }
        } else {
             if let cell = cell as? EditProfilePrivacyCell  {
                
                cell.btnSwichMode[0].isSelected = userProfileModel?.tiIsShowAge == 1 ? true : false
                cell.btnSwichMode[1].isSelected = userProfileModel?.tiIsShowDistance == 1 ? true : false
                cell.btnSwichMode[2].isSelected = userProfileModel?.tiIsShowContactNumber == 1 ? true : false
                cell.btnSwichMode[3].isSelected = userProfileModel?.tiIsShowProfileToLikedUser == 1 ? true : false
                
                cell.clickOnBtnSwitch = { (index) in
                    print(indexPath.row)
                    if cell.btnSwichMode[index!].tag == 0 {
                        cell.btnSwichMode[0].isSelected = !cell.btnSwichMode[0].isSelected
                        self.userProfileModel?.tiIsShowAge = cell.btnSwichMode[0].isSelected == true ? 1 : 0
                    } else if cell.btnSwichMode[index!].tag == 1 {
                        cell.btnSwichMode[1].isSelected = !cell.btnSwichMode[1].isSelected
                        self.userProfileModel?.tiIsShowDistance = cell.btnSwichMode[1].isSelected == true ? 1 : 0
                    } else if cell.btnSwichMode[index!].tag == 2 {
                        cell.btnSwichMode[2].isSelected = !cell.btnSwichMode[2].isSelected
                        self.userProfileModel?.tiIsShowContactNumber = cell.btnSwichMode[2].isSelected == true ? 1 : 0
                    } else {
                        cell.btnSwichMode[3].isSelected = !cell.btnSwichMode[3].isSelected
                        self.userProfileModel?.tiIsShowProfileToLikedUser = cell.btnSwichMode[3].isSelected == true ? 1 : 0
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return objEditProfileData.cells[indexPath.section].cellRowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return objEditProfileData.cells[section].cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:UIView =  UIView()
        headerView.backgroundColor = .white
        
        let headerTitle = UILabel()
        headerTitle.frame = CGRect(x: 20, y: headerView.frame.origin.y + 10, w: ScreenSize.width - 60, h: 30)
        headerTitle.text = objEditProfileData.cells[section].sectionTitle
        headerTitle.lineBreakMode = .byWordWrapping
        headerTitle.textColor = .black
        headerTitle.font = UIFont(name: FontTypePoppins.Poppins_SemiBold.rawValue, size: 14)
        headerView.addSubview(headerTitle)
        
        if objEditProfileData.cells[section].isHeaderAvailable {
            let buttonClr = UIButton(frame: CGRect(x: ScreenSize.width - 100, y: headerView.frame.origin.y + 10, w: 100, h: 30))
            buttonClr.backgroundColor = .clear
            buttonClr.underlineButton(text: "Change", font: UIFont(name: FontTypePoppins.Poppins_Regular.rawValue, size: 12)!, color: #colorLiteral(red: 0.5294117647, green: 0.1803921569, blue: 0.7647058824, alpha: 1))
            buttonClr.tag = section
            buttonClr.addTarget(self, action: #selector(btnChangeAction(sender:)), for: .touchUpInside)
            headerView.addSubview(buttonClr)
        }
        return headerView
    }
}

extension EditProfileViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userPhotosModel.count != 0 ? self.userPhotosModel.count + 1 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PhotoEmojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.PhotoEmojiCell, for: indexPath) as! PhotoEmojiCell
        cell.emojiStackView.spacing = DeviceType.iPhone5orSE ? 2 : 10
        
            if indexPath.row < self.userPhotosModel.count {
                cell.btnClose.alpha = 1.0
                if userPhotosModel[indexPath.row].tiImage == nil {
                    let url = URL(string:"\(fileUploadURL)\(user_Profile)\(userPhotosModel[indexPath.row].vMedia!)")
                    print(url!)
                    cell.userImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "user_profile"))
                } else {
                    cell.userImgView.image = userPhotosModel[indexPath.row].tiImage
                }
                
                cell.emojiStackView.alpha = 0
            } else {
                cell.userImgView.image = #imageLiteral(resourceName: "icn_add_photo")
                cell.emojiStackView.alpha = 0
                cell.btnClose.alpha  = 0
            }

        cell.clickOnImageButton = {
            self.openImagePickerActionSheet()
        }
        
        cell.clickOnRemovePhoto = {
            if self.userPhotosModel.count != 0 {
                let mediaID = self.userPhotosModel[indexPath.row].iMediaId
                self.userPhotosModel.remove(at: indexPath.row)
                self.removePhotoStr = self.removePhotoStr != "" ? "\(self.removePhotoStr),\(mediaID!)" : "\(mediaID!)"
            }
            self.tblEditProfileView.reloadData()
        }
        return cell
    }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
             let width = ScreenSize.width/3
             return CGSize(width: width, height: width)
     }
}
extension EditProfileViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        self.PickerView.alpha = 0.0
        if textField.tag == 1 {
            textField.resignFirstResponder()
            self.PickerView.alpha = 1.0
            return false
        } else if textField.tag == 4 {
            if (textField.text?.count)! < 300 {
                return true
            }
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            self.userProfileModel?.vName = textField.text
        } else if textField.tag == 2 {
            self.userProfileModel?.vLiveIn = textField.text
        } else if textField.tag == 3 {
             self.userProfileModel?.txCompanyDetail = textField.text
        } else if textField.tag == 4 {
            self.userProfileModel?.txAbout = textField.text
        } else {
            
        }
        self.tblEditProfileView.reloadData()
    }
    
    @objc func textFieldDidChange(textField : UITextField){
        
        if textField.tag == 0 {
            self.userProfileModel?.vName = textField.text
        } else if textField.tag == 2 {
            self.userProfileModel?.vLiveIn = textField.text
        } else if textField.tag == 3 {
             self.userProfileModel?.txCompanyDetail = textField.text
        } else if textField.tag == 4 {
            if (textField.text?.count)! < 300 {
                textField.isUserInteractionEnabled = true
            } else {
                textField.isUserInteractionEnabled = false
            }
        } else {
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UIImagePickerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openImagePickerActionSheet() {
        let camera = "Camera"
        let photoGallery = "Gallery"
        let cancel = "Cancel"
        UIAlertController.showAlertWith(title: nil, message: nil, style: .actionSheet, buttons: [camera,photoGallery,cancel], controller: self) { (action) in
            if action == camera {
                self.openCamera()
            } else if action == photoGallery {
                self.openLibrary()
            }
        }
    }
    
    func openCamera(){
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
    
    func openLibrary(){
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if #available(iOS 11.0, *) {
            if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset{
                if let fileName = asset.value(forKey: "filename") as? String{
                    print(fileName)
                }
            }
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                
                let IsDefault = self.userPhotosModel.count == 0 ? 1 : 0
                self.userPhotosModel.append(UserPhotosModel(iMediaId: 1, vMedia: self.thumbURlUpload.path, tiMediaType: 1, tiImage: image, tiIsDefault: IsDefault))
                if IsDefault == 1 {
                    self.imgProfile.image = self.userPhotosModel[0].tiImage
                }
            }
            self.tblEditProfileView.reloadData()
        } else {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                
                let IsDefault = self.userPhotosModel.count == 0 ? 1 : 0
                self.userPhotosModel.append(UserPhotosModel(iMediaId: 1, vMedia: self.thumbURlUpload.path, tiMediaType: 1, tiImage: image, tiIsDefault: IsDefault))
                if IsDefault == 1 {
                    self.imgProfile.image = self.userPhotosModel[0].tiImage
                }
                if let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                    let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                    let assetResources = PHAssetResource.assetResources(for: result.firstObject!)
                    
                    print(assetResources.first!.originalFilename)
                }
            }
        }
    }
}

extension EditProfileViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.genderArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let title = self.genderArray[row]
        return title
    }

    func pickerView(_ pickerView:UIPickerView,didSelectRow row: Int,inComponent component: Int){
        self.userProfileModel?.tiGender = (row == 3 ? 4 : row)
    }
}
