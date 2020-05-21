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
            return 390
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
    var imageArray : [UIImage]  = [] //[#imageLiteral(resourceName: "img_intro_2"), #imageLiteral(resourceName: "image_1"), #imageLiteral(resourceName: "Image 63"), #imageLiteral(resourceName: "Image 62")]
    var imagePicker: UIImagePickerController!
    var image : UIImage?
    
    var userProfileModel : UserProfileModel?
    var isForProfile : Bool = true
    var objQuestionModel = QuestionaryModel()
    var customProfileView: RecommandedProfileView!
    var genderArray : [String] = ["Male", "Female", "Others", "Prefer not to say"]
    var delegate : ProfileDataDelegate!
    
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
            self.userProfileModel = UserProfileModel(vEmail: UserDataModel.currentUser?.vEmail, vProfileImage: UserDataModel.currentUser?.vProfileImage, vFullName: UserDataModel.currentUser?.vName, vAge: UserDataModel.currentUser?.tiAge ?? 0, vDoB : UserDataModel.currentUser?.dDob != "" ? UserDataModel.currentUser?.dDob?.strDateTODateStr(dateStr: UserDataModel.currentUser!.dDob!) : "", vAbout: UserDataModel.currentUser?.txAbout, vCity: UserDataModel.currentUser?.vLiveIn, vGender: self.genderArray[(UserDataModel.currentUser?.tiGender!)!], vGenderIndex: "0", vCompanyDetail: UserDataModel.currentUser?.txCompanyDetail, vInterestAge: "20-30", vInterestGender: "Male", vLikedSocialPlatform: "Whatsapp, Snapchat, Instagram", vPhotos: "", vInstagramLink: UserDataModel.currentUser?.vInstaLink, vSnapchatLink: UserDataModel.currentUser?.vSnapLink, vFacebookLink: UserDataModel.currentUser?.vFbLink, vShowAge: UserDataModel.currentUser?.tiIsShowAge, vShowDistance: UserDataModel.currentUser?.tiIsShowDistance, vShowContactNo: UserDataModel.currentUser?.tiIsShowContactNumber, vShowProfiletoLiked:UserDataModel.currentUser?.tiIsShowProfileToLikedUser, vProfileImg: nil, vProfileImageArray: [])
        }
        //ProfileImage setup
        if userProfileModel?.vProfileImage != "" {
            let url = URL(string:"\(fileUploadURL)\(user_Profile)\(userProfileModel!.vProfileImage!)")
            print(url!)
            self.imgProfile.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "user_profile"))
        }
        self.imageArray = userProfileModel!.vProfileImageArray != nil ? userProfileModel!.vProfileImageArray! : []
        self.objQuestionModel.arrQuestionnaire = callQuestionnaireApi()
        self.objQuestionModel.objQuestionnaire = QuestionnaireModel(dictionary: self.objQuestionModel.arrQuestionnaire[1])!
        self.tblEditProfileView.reloadData()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.popVC()
    }
    @IBAction func btnUpdateAction(_ sender: GradientButton) {
        
        let params = RequestParameter.sharedInstance().editProfileParam(vEmail: userProfileModel?.vEmail ?? "", vProfileImage: userProfileModel?.vProfileImage ?? "", vName: userProfileModel?.vFullName ?? "", dDob: userProfileModel?.vDoB?.inputDateStrToAPIDateStr(dateStr: userProfileModel!.vDoB!) ?? "", tiAge: "\(userProfileModel?.vAge ?? 0)", tiGender: userProfileModel?.vGenderIndex ?? "0", vLiveIn: userProfileModel?.vCity ?? "", txCompanyDetail: userProfileModel?.vCompanyDetail ?? "", txAbout: userProfileModel?.vAbout ?? "", photos: userProfileModel?.vPhotos ?? "", vInstaLink: userProfileModel?.vInstagramLink ?? "", vSnapLink: userProfileModel?.vSnapchatLink ?? "", vFbLink: userProfileModel?.vFacebookLink ?? "", tiIsShowAge: "\(userProfileModel?.vShowAge ?? 0)", tiIsShowDistance: "\(userProfileModel?.vShowDistance ?? 0)", tiIsShowContactNumber: "\(userProfileModel?.vShowContactNo ?? 0)", tiIsShowProfileToLikedUser: "\(userProfileModel?.vShowProfiletoLiked ?? 0)")
        self.presenter?.callEdirProfileAPI(params: params, images : self.imageArray)
    }
    @IBAction func btnDonePickerAction(_ sender: UIBarButtonItem) {
        
        if sender.tag == 0 {
            self.PickerView.alpha = 0.0
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let strDate = dateFormatter.string(from: datePicker.date)
            print(strDate)
            self.userProfileModel?.vDoB = strDate
            self.userProfileModel?.vAge = datePicker.date.age
        } else {
            self.genderPickerView.alpha = 0.0
        }
        self.tblEditProfileView.reloadData()
    }
    @IBAction func btnChooseProfileAction(_ sender: UIButton) {
        self.showSetProfileView()
//        self.isForProfile = true
//        self.openImagePickerActionSheet()
    }
    
    @objc func btnChangeAction(sender : UIButton){
        if sender.tag == 1 {
            let discVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.DiscoverySettingScreen) as! DiscoverySettingViewController
            discVC.userProfileModel = self.userProfileModel
            discVC.isFromMenu = false
            self.pushVC(discVC)
        } else {
            let socialVC = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.SocialMediaLink) as! SocialMediaLinkVC
            socialVC.userProfileModel = self.userProfileModel
            self.pushVC(socialVC)
        }
    }
    
    func showSetProfileView() {
        customProfileView = RecommandedProfileView.initAlertView()
        customProfileView.delegate = self
        customProfileView.frame = self.view.frame
        AppDelObj.window?.addSubview(customProfileView)
    }
    
    func getEditProfileResponse(response: UserAuthResponse){
        if response.responseCode == 200 {
            userProfileModel?.vProfileImg = self.imageArray[0]
            userProfileModel?.vProfileImageArray = self.imageArray
            UserDataModel.currentUser = response.responseData
            if self.delegate != nil {
                self.delegate.profiledetails(data : userProfileModel!)
            }
            self.popVC()
            AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle: "OK")
        }
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
            self.userProfileModel?.vInterestAge = data
        } else {
            self.userProfileModel?.vInterestGender = data
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
                
                cell.txtUserName.text = userProfileModel?.vFullName
                cell.txtAbout.text = userProfileModel?.vAbout
                
                cell.txtDoB.text = userProfileModel != nil ? userProfileModel?.vDoB : "02/01/1999"
                cell.txtCity.text = userProfileModel?.vCity
                cell.txtGender.text = userProfileModel?.vGender
                cell.txtCompanyDetail.text = userProfileModel?.vCompanyDetail
                cell.lblCharCount.text = "\(userProfileModel!.vAbout!.count)/\(300)"
                cell.btnChange.underlineButton(text: "Change", font: UIFont(name: FontTypePoppins.Poppins_Regular.rawValue, size: 12)!, color: #colorLiteral(red: 0.5294117647, green: 0.1803921569, blue: 0.7647058824, alpha: 1))
                
                cell.clickOnChangeGender = {
                    self.genderPickerView.alpha = 1.0
                }
            }
        } else if objEditProfileData.cells[indexPath.section].cellID == "EditInterestCell" {
            if let cell = cell as? EditInterestCell {
                
                let queVC = GeekMeets_StoryBoard.Questionnaire.instantiateViewController(withIdentifier: GeekMeets_ViewController.SelectAgeRange) as? SelectAgeRangeViewController
                queVC?.isFromSignUp = false
                
            }
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
                cell.txtFacebookLink.text = userProfileModel?.vFacebookLink
                cell.txtSnapchatLink.text = userProfileModel?.vSnapchatLink
                cell.txtInstagramLink.text = userProfileModel?.vInstagramLink
            }
        } else {
             if let cell = cell as? EditProfilePrivacyCell  {
                
                cell.btnSwichMode[0].isSelected = userProfileModel?.vShowAge == 1 ? true : false
                cell.btnSwichMode[1].isSelected = userProfileModel?.vShowDistance == 1 ? true : false
                cell.btnSwichMode[2].isSelected = userProfileModel?.vShowContactNo == 1 ? true : false
                cell.btnSwichMode[3].isSelected = userProfileModel?.vShowProfiletoLiked == 1 ? true : false
                
                cell.clickOnBtnSwitch = { (index) in
                    print(indexPath.row)
                    if cell.btnSwichMode[index!].tag == 0 {
                        cell.btnSwichMode[0].isSelected = !cell.btnSwichMode[0].isSelected
                        self.userProfileModel?.vShowAge = cell.btnSwichMode[0].isSelected == true ? 1 : 0
                    } else if cell.btnSwichMode[index!].tag == 1 {
                        cell.btnSwichMode[1].isSelected = !cell.btnSwichMode[1].isSelected
                        self.userProfileModel?.vShowDistance = cell.btnSwichMode[1].isSelected == true ? 1 : 0
                    } else if cell.btnSwichMode[index!].tag == 2 {
                        cell.btnSwichMode[2].isSelected = !cell.btnSwichMode[2].isSelected
                        self.userProfileModel?.vShowContactNo = cell.btnSwichMode[2].isSelected == true ? 1 : 0
                    } else {
                        cell.btnSwichMode[3].isSelected = !cell.btnSwichMode[3].isSelected
                        self.userProfileModel?.vShowProfiletoLiked = cell.btnSwichMode[3].isSelected == true ? 1 : 0
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
        return self.imageArray.count != 0 ? self.imageArray.count + 1 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PhotoEmojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.PhotoEmojiCell, for: indexPath) as! PhotoEmojiCell
        cell.emojiStackView.spacing = DeviceType.iPhone5orSE ? 2 : 10
        
        if indexPath.row < self.imageArray.count {
            cell.btnClose.alpha = 1.0
            cell.userImgView.image = imageArray[indexPath.row]
            cell.emojiStackView.alpha = 0
        } else {
            cell.userImgView.image = #imageLiteral(resourceName: "icn_add_photo")
            cell.emojiStackView.alpha = 0
            cell.btnClose.alpha  = 0
        }
        
        cell.clickOnImageButton = {
            self.isForProfile = false
            if self.image != nil {
                self.openImagePickerActionSheet()
            } else {
                self.openImagePickerActionSheet()
            }
            self.tblEditProfileView.reloadData()
        }
        
        cell.clickOnRemovePhoto = {
            if self.imageArray.count != 0 {
                self.imageArray.remove(at: indexPath.row)
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
            self.userProfileModel?.vFullName = textField.text
        } else if textField.tag == 2 {
            self.userProfileModel?.vCity = textField.text
        } else if textField.tag == 3 {
             self.userProfileModel?.vCompanyDetail = textField.text
        } else if textField.tag == 4 {
            self.userProfileModel?.vAbout = textField.text
        } else {
            
        }
        self.tblEditProfileView.reloadData()
    }
    
    @objc func textFieldDidChange(textField : UITextField){
        if (textField.text?.count)! < 300 {
            textField.isUserInteractionEnabled = true
        } else {
            textField.isUserInteractionEnabled = false
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
                if self.isForProfile {
                    self.image = image
                    self.imgProfile.image = image
                } else {
                    self.imageArray.append(image)
                    self.image = image
                    self.imgProfile.image = self.imageArray[0]
                    
                }
            }
            self.tblEditProfileView.reloadData()
        } else {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                if self.isForProfile {
                    self.imgProfile.image = image
                    self.image = image
                } else {
                    self.imageArray.append(image)
                    self.imgProfile.image = self.imageArray[0]
                    self.image = image
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
        return self.genderArray.count // self.objQuestionModel.objQuestionnaire.response_set!.response_option?.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let title = self.genderArray[row] // self.objQuestionModel.objQuestionnaire.response_set?.response_option?[row].name!
        return title
    }

    func pickerView(_ pickerView:UIPickerView,didSelectRow row: Int,inComponent component: Int){
        let title = self.genderArray[row] //self.objQuestionModel.objQuestionnaire.response_set?.response_option?[row].name!
        self.userProfileModel?.vGender = title
        self.userProfileModel?.vGenderIndex = "\(row == 3 ? 4 : row)"
        
    }
}
