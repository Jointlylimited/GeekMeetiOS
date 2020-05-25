//
//  ProfileViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 20/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SDWebImage

protocol ProfileDataDelegate {
    func profiledetails(data : UserProfileModel)
}
enum ProfileListCells {
    
    case AboutCell(obj : String)
    case CompanyCell
    case InterestCell(collapsed : Bool)
    case PhotosCell
    case SocialCell
    
    var cellHeight  : CGFloat {
        switch self {
            
        case .AboutCell, .CompanyCell, .InterestCell, .PhotosCell, .SocialCell:
            return 50
            
        }
    }
    
    var cellRowHeight  : CGFloat {
        switch self {
            
        case .AboutCell(let desc):
            return desc.heightWithConstrainedWidth(width: 400 * _widthRatio,font: fontPoppins(fontType: .Poppins_Medium, fontSize: .sizeNormalTextField)) + 120
        case .CompanyCell, .SocialCell:
            return UITableView.automaticDimension
        case .InterestCell(let collapsed):
            return collapsed == true ? UITableView.automaticDimension : 0
        case .PhotosCell:
            let width = ScreenSize.width/3
            return width
        }
    }
    
    var headerHeight: CGFloat {
        return 45
    }
    
    var cellID: String {
        switch self {
            
        case .AboutCell:
            return "ProfileAboutCell"
        case .CompanyCell:
            return "ProfileCompanyCell"
        case .InterestCell:
            return "ProfileInterestCell"
        case .PhotosCell:
            return "ProfilePhotosCell"
        case .SocialCell:
            return "ProfileSocialCell"
            
        }
    }
    
    var sectionTitle: String {
        switch self {
        case .AboutCell:
            return "About"
        case .CompanyCell:
            return "Company"
        case .InterestCell:
            return "Interests & Preferences"
        case .PhotosCell:
            return "Photos"
        case .SocialCell:
            return "Social Media Links"
        }
    }
    
    var sectionImage : UIImage {
        switch self {
        case .AboutCell:
            return #imageLiteral(resourceName: "icn_about")
        case .CompanyCell:
            return #imageLiteral(resourceName: "icn_company")
        case .InterestCell:
            return #imageLiteral(resourceName: "icn_interests & preferences")
        case .PhotosCell:
            return #imageLiteral(resourceName: "icn_photos")
        case .SocialCell:
            return #imageLiteral(resourceName: "icn_link")
        
        }
    }
}

struct ProfileData {
    
    var isCellCollpsed : Bool = false
    
    var cells: [ProfileListCells] {
        var cell: [ProfileListCells] = []
        let str = "Lady with fun loving personality and open- minded, Looking for Someone to hang out always open for hangout"
        cell.append(.AboutCell(obj:str))
        cell.append(.CompanyCell)
        cell.append(.InterestCell(collapsed : isCellCollpsed))
        cell.append(.PhotosCell)
        cell.append(.SocialCell)
        
        return cell
    }
}

protocol ProfileProtocol: class {
    
}

class ProfileViewController: UIViewController, ProfileProtocol {
    //var interactor : ProfileInteractorProtocol?
    var presenter : ProfilePresentationProtocol?
    
    @IBOutlet weak var tblProfile: UITableView!
    @IBOutlet weak var lblUserNameAge: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    // MARK: Object lifecycle
    
    var objProfileData = ProfileData()
    var imageArray : [UIImage] = [] // [#imageLiteral(resourceName: "img_intro_2"), #imageLiteral(resourceName: "image_1"), #imageLiteral(resourceName: "Image 63"), #imageLiteral(resourceName: "Image 62")]
    var genderArray : [String] = ["Male", "Female", "Others", "Prefer not to say"]
    
    var userProfileModel : UserAuthResponseField?// : UserProfileModel?
    
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
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter()
        
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
        setProfileData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProfileData()
    }
    func setProfileData(){
        
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        
        self.lblUserNameAge.text = "\(UserDataModel.currentUser!.vName ?? ""), \(UserDataModel.currentUser!.tiAge ?? 25)"
        self.userProfileModel = UserDataModel.currentUser
            
        //ProfileImage setup
        if userProfileModel?.vProfileImage != "" {
            let url = URL(string:"\(fileUploadURL)\(user_Profile)\(userProfileModel!.vProfileImage!)")
            print(url!)
            self.imgProfile.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "user_profile"))
        }
        self.tblProfile.reloadData()
    }
    
    @IBAction func btnEditProfileAction(_ sender: UIButton) {
        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.EditProfileScreen) as! EditProfileViewController
        controller.delegate = self
//        controller.userProfileModel = self.userProfileModel
        self.pushVC(controller)
    }
}

extension ProfileViewController : ProfileDataDelegate{
    func profiledetails(data : UserProfileModel){
//        self.userProfileModel = data
        setProfileData()
    }
}
extension ProfileViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.objProfileData.cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: objProfileData.cells[indexPath.section].cellID)
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if objProfileData.cells[indexPath.section].cellID == "ProfileAboutCell" {
            if let cell = cell as? ProfileAboutCell  {
                cell.lblAbout.text = userProfileModel?.txAbout // userProfileModel?.vAbout
                cell.lblCity.text = userProfileModel?.vLiveIn // userProfileModel?.vCity
                cell.lblGender.text = genderArray[userProfileModel!.tiGender!] // userProfileModel?.vGender
            }
        } else if objProfileData.cells[indexPath.section].cellID == "ProfileCompanyCell" {
            if let cell = cell as? ProfileCompanyCell  {
                cell.lblCompanyDetail.text = userProfileModel?.txCompanyDetail // userProfileModel?.vCompanyDetail
            }
        } else if objProfileData.cells[indexPath.section].cellID == "ProfileInterestCell" {
            if let cell = cell as? ProfileInterestCell  {
                cell.clickOnBtnNext = { (title) in
                    let intVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.Interest_PreferenceScreen) as? Interest_PreferenceViewController
                    
                    if title == "Yourself" {
                        intVC?.header_title = title!
                        intVC?.objDiscoverData =  [CommonCellModel(title: Interest_PreferenceData.Ethernity.Title, description: "African American/African", isDescAvailable: true), CommonCellModel(title: Interest_PreferenceData.Height.Title, description: "5.2", isDescAvailable: true), CommonCellModel(title: Interest_PreferenceData.BodyType.Title, description: "Fit", isDescAvailable: true), CommonCellModel(title: Interest_PreferenceData.Indoor_Outdoor.Title, description: "I love inddors", isDescAvailable: true), CommonCellModel(title: Interest_PreferenceData.Morning_Night.Title, description: "Night", isDescAvailable: true)]
                    } else if title == "Your Desired Partner" {
                        intVC?.header_title = title!
                        intVC?.objDiscoverData =  [CommonCellModel(title: Interest_PreferenceData.Ethernity.Title, description: "African American/African", isDescAvailable: true), CommonCellModel(title: Interest_PreferenceData.Height.Title, description: "5.2", isDescAvailable: true), CommonCellModel(title: Interest_PreferenceData.BodyType.Title, description: "Fit", isDescAvailable: true), CommonCellModel(title: Interest_PreferenceData.Indoor_Outdoor.Title, description: "I love inddors", isDescAvailable: true), CommonCellModel(title: Interest_PreferenceData.Morning_Night.Title, description: "Night", isDescAvailable: true)]
                        
                    } else {
                        intVC?.header_title = title!
                        intVC?.objDiscoverData =  [CommonCellModel(title: Interest_PreferenceData.Ethernity.Title, description: "African American/African", isDescAvailable: true), CommonCellModel(title: Interest_PreferenceData.Height.Title, description: "5.2", isDescAvailable: true), CommonCellModel(title: Interest_PreferenceData.BodyType.Title, description: "Fit", isDescAvailable: true), CommonCellModel(title: Interest_PreferenceData.Indoor_Outdoor.Title, description: "I love inddors", isDescAvailable: true), CommonCellModel(title: Interest_PreferenceData.Morning_Night.Title, description: "Night", isDescAvailable: true)]
                    }
                    
                    self.pushVC(intVC!)
                }
            }
        } else if objProfileData.cells[indexPath.section].cellID == "ProfilePhotosCell" {
            if let cell = cell as? ProfilePhotosCell  {
                
                cell.photoCollectionView.register(UINib.init(nibName: Cells.PhotoEmojiCell, bundle: Bundle.main), forCellWithReuseIdentifier: Cells.PhotoEmojiCell)
                
                let layout = CustomImageLayout()
                layout.scrollDirection = .horizontal
                cell.photoCollectionView.collectionViewLayout = layout
                
                cell.photoCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                cell.photoCollectionView.reloadData()
            }
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return objProfileData.cells[indexPath.section].cellRowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return objProfileData.cells[section].cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:UIView =  UIView()
        headerView.backgroundColor = .white
        
        let myCustomView = UIImageView()
        myCustomView.frame = CGRect(x: headerView.frame.origin.x + 20, y: headerView.frame.origin.y + 10, w: 30, h: 30)
        let myImage: UIImage = objProfileData.cells[section].sectionImage
        myCustomView.image = myImage
        headerView.addSubview(myCustomView)
        
        let headerTitle = UILabel()
        headerTitle.frame = CGRect(x: headerView.frame.origin.x + 60, y: headerView.frame.origin.y + 10, w: ScreenSize.width - 60, h: 30)
        headerTitle.text = objProfileData.cells[section].sectionTitle
        headerTitle.textColor = .black
        headerTitle.font = UIFont(name: "Poppins-SemiBold", size: 14)
        headerView.addSubview(headerTitle)
        
        if section == 2 {
            let expandImg = UIImageView()
            expandImg.frame = CGRect(x: ScreenSize.width - 40, y: headerView.frame.origin.y + 25, w: 10, h: 8)
            let myImg: UIImage = objProfileData.isCellCollpsed ? #imageLiteral(resourceName: "icn_up") : #imageLiteral(resourceName: "icn_down")
            expandImg.image = myImg
            headerView.addSubview(expandImg)
            
            let tapGestre = UITapGestureRecognizer(target: self, action: #selector(headerSelectionAction))
            headerView.isUserInteractionEnabled = true
            headerView.addGestureRecognizer(tapGestre)
        }
        return headerView
    }
    
    @objc func headerSelectionAction() {
        if objProfileData.isCellCollpsed == true {
            objProfileData.isCellCollpsed = false
        } else {
            objProfileData.isCellCollpsed = true
        }
        self.tblProfile.reloadData()
    }
}

extension ProfileViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count != 0 ? self.imageArray.count : (UserDataModel.currentUser?.photos != nil ? (UserDataModel.currentUser?.photos!.count)! : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PhotoEmojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.PhotoEmojiCell, for: indexPath) as! PhotoEmojiCell
        
         if UserDataModel.currentUser?.photos == nil || UserDataModel.currentUser?.photos?.count == 0 {
            cell.userImgView.image = imageArray[indexPath.row]
         } else {
            let photos = UserDataModel.currentUser!.photos!
            let url = URL(string:"\(fileUploadURL)\(user_Profile)\(photos[indexPath.row].vMedia!)")
            cell.userImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "user_profile"))
            print(url!)
        }
        cell.emojiStackView.spacing = DeviceType.iPhone5orSE ? 2 : 10
        cell.btnClose.alpha = 0.0
        cell.btnChooseImage.alpha = 0.0
        return cell
    }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
             let width = ScreenSize.width/3 + 10
             return CGSize(width: width, height: width)
     }
}
