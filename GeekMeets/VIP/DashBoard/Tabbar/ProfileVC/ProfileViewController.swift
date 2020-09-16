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
            return desc.heightWithConstrainedWidth(width: 374 * _widthRatio,font: fontPoppins(fontType: .Poppins_Medium, fontSize: .sizeNormalTextField)) + 70
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
    var str = ""
    
    var cells: [ProfileListCells] {
        var cell: [ProfileListCells] = []
        
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
    var imageArray : [UIImage] = []
    var genderArray : [String] = ["Male", "Female", "Others", "Prefer not to say"]
    
    var userProfileModel : UserAuthResponseField?
    
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
        self.objProfileData.str = UserDataModel.currentUser!.txAbout ?? "About"
        //ProfileImage setup
        if userProfileModel?.vProfileImage != "" {
            let url = URL(string:"\(userProfileModel!.vProfileImage!)")
            print(url!)
            self.imgProfile.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_round"))
        }
        self.tblProfile.reloadData()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func btnEditProfileAction(_ sender: UIButton) {
        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.EditProfileScreen) as! EditProfileViewController
        controller.delegate = self
        self.pushVC(controller)
    }
    
    func openSocialPlatform(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

//MARK: ProfileData Delegate Methods
extension ProfileViewController : ProfileDataDelegate{
    func profiledetails(data : UserProfileModel){
        setProfileData()
    }
}

//MARK: Tableview Delegate & Datasource Methods
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
                cell.lblAbout.text = userProfileModel?.txAbout
                cell.lblCity.text = userProfileModel?.vLiveIn
                cell.lblGender.text = genderArray[userProfileModel!.tiGender!]
            }
        } else if objProfileData.cells[indexPath.section].cellID == "ProfileCompanyCell" {
            if let cell = cell as? ProfileCompanyCell  {
                cell.lblCompanyDetail.text = userProfileModel?.txCompanyDetail
            }
        } else if objProfileData.cells[indexPath.section].cellID == "ProfileInterestCell" {
            if let cell = cell as? ProfileInterestCell  {
                cell.clickOnBtnNext = { (title) in
                    let intVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.Interest_PreferenceScreen) as? Interest_PreferenceViewController
                    let response = UserDataModel.UserPreferenceResponse?.responseData
                    
                    if title == "Yourself" {
                        intVC?.header_title = title!
                        intVC?.objDiscoverData = [response![0], response![4], response![11], response![17], response![19], response![23], response![24], response![25], response![26], response![27], response![28]]
                    } else if title == "Your Desired Partner" {
                        intVC?.header_title = title!
                        intVC?.objDiscoverData = [response![1], response![3], response![5], response![7], response![9], response![12]]
                        
                    } else {
                        intVC?.header_title = title!
                        intVC?.objDiscoverData = [response![13], response![14], response![15], response![16], response![17], response![18], response![22], response![29]]
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
        } else if objProfileData.cells[indexPath.section].cellID == "ProfileSocialCell" {
            if let cell = cell as? ProfileSocialCell  {
                cell.clickOnBtn = { (index) in
                    print(index!)
                    if index == 0 {
                        guard let url = URL(string: "https://facebook.com/\(self.userProfileModel!.vName!)")  else { return }
                        self.openSocialPlatform(url: url)
                    } else if index == 1 {
                        guard let url = URL(string: "https://instagram.com/\(self.userProfileModel!.vName!)")  else { return }
                        self.openSocialPlatform(url: url)
                    } else {
                        guard let url = URL(string: "https://snapchat.com/\(self.userProfileModel!.vName!)")  else { return }
                        self.openSocialPlatform(url: url)
                    }
                }
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
        headerTitle.font = UIFont(name: FontTypePoppins.Poppins_SemiBold.rawValue, size: 14)
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

//MARK: UICollectionview Delegate & Datasource Methods
extension ProfileViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count != 0 ? self.imageArray.count : (UserDataModel.currentUser?.photos != nil ? (UserDataModel.currentUser?.photos!.count)! : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PhotoEmojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.PhotoEmojiCell, for: indexPath) as! PhotoEmojiCell
        cell.emojiStackView.alpha = 0.0
        if UserDataModel.currentUser?.photos == nil || UserDataModel.currentUser?.photos?.count == 0 {
            cell.userImgView.image = imageArray[indexPath.row]
        } else {
            let photos = UserDataModel.currentUser!.photos!
            let url = URL(string:"\(photos[indexPath.row].vMedia!)")
            cell.userImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_rect"))
            print(url!)
            let photoString = photos[indexPath.row]
            
            if photoString.reaction?.count != 0 {
                if photoString.reaction!.count == 3 {
                    cell.btnKiss.setTitle((photoString.reaction?.count != 0 && photoString.reaction![2].vCount != "0") ? photoString.reaction![2].vCount : "0", for: .normal)
                    cell.btnLove.setTitle((photoString.reaction?.count != 0 && photoString.reaction![1].vCount != "0") ? photoString.reaction![1].vCount : "0", for: .normal)
                    cell.btnLoveSmile.setTitle((photoString.reaction?.count != 0 && photoString.reaction![0].vCount != "0") ? photoString.reaction![0].vCount : "0", for: .normal)
                }
                if photoString.reaction!.count == 2 {
                    cell.btnKiss.setTitle("0", for: .normal)
                    cell.btnLoveSmile.setTitle((photoString.reaction?.count != 0 && photoString.reaction![1].vCount != "0") ? photoString.reaction![1].vCount : "0", for: .normal)
                    cell.btnLove.setTitle((photoString.reaction?.count != 0 && photoString.reaction![0].vCount != "0") ? photoString.reaction![0].vCount : "0", for: .normal)
                }
                if photoString.reaction!.count == 1  {
                    cell.btnKiss.setTitle("0", for: .normal)
                    cell.btnLoveSmile.setTitle("0", for: .normal)
                    cell.btnLove.setTitle((photoString.reaction?.count != 0 && photoString.reaction![0].vCount != "0") ? photoString.reaction![0].vCount : "0", for: .normal)
                }
            } else {
                cell.btnKiss.setTitle("0", for: .normal)
                cell.btnLove.setTitle("0", for: .normal)
                cell.btnLoveSmile.setTitle("0", for: .normal)
            }
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
