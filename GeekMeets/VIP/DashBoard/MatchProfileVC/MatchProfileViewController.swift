//
//  MatchProfileViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 21/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreLocation
import SDWebImage

enum MatchProfileListCells {
    
    case PreferenceCell(obj : [PreferenceAnswer])
    case AboutCell(obj : String)
    case CompanyCell
    case SocialCell
    
    var cellHeight  : CGFloat {
        switch self {
            
        case .AboutCell, .CompanyCell, .SocialCell:
            return 50
        case .PreferenceCell:
            return 0
        }
    }
    
    var cellRowHeight  : CGFloat {
        switch self {
            
        case .AboutCell(let desc):
            return desc.heightWithConstrainedWidth(width: 400 * _widthRatio,font: fontPoppins(fontType: .Poppins_Medium, fontSize: .sizeNormalTextField)) + 50
        case .CompanyCell, .SocialCell:
            return UITableView.automaticDimension
        case .PreferenceCell(let data):
            return data.count != 0 ? 150 : 0
        }
    }
    
    var headerHeight: CGFloat {
        return 45
    }
    
    var cellID: String {
        switch self {
            
        case .PreferenceCell:
            return "PreferenceCell"
        case .AboutCell:
            return "ProfileAboutCell"
        case .CompanyCell:
            return "ProfileCompanyCell"
        case .SocialCell:
            return "ProfileSocialCell"
            
        }
    }
    
    var sectionTitle: String {
        switch self {
        case .PreferenceCell:
            return ""
        case .AboutCell:
            return "About"
        case .CompanyCell:
            return "Company"
        case .SocialCell:
            return "Social Media Links"
        }
    }
    
    var sectionImage : UIImage {
        switch self {
        case .PreferenceCell:
            return #imageLiteral(resourceName: "icn_about")
        case .AboutCell:
            return #imageLiteral(resourceName: "icn_about")
        case .CompanyCell:
            return #imageLiteral(resourceName: "icn_company")
        case .SocialCell:
            return #imageLiteral(resourceName: "icn_link")
        
        }
    }
}

struct MatchProfileData {
    
    var data : [PreferenceAnswer] = []
    var str = ""
    var cells: [MatchProfileListCells] {
        var cell: [MatchProfileListCells] = []
        
        
        cell.append(.PreferenceCell(obj: data))
        cell.append(.AboutCell(obj: str))
        cell.append(.CompanyCell)
        cell.append(.SocialCell)
        
        return cell
    }
}

protocol MatchProfileProtocol: class {
    func getUserProfileResponse(response : UserAuthResponseField)
    func getStoryListResponse(response: StoryResponse)
    func getBlockUserResponse(response : CommonResponse)
    func getBlockUserListResponse(response : BlockUser)
    func getReactEmojiResponse(response : MediaReaction)
    func getSwipeCardResponse(response : SwipeUser)
}

class MatchProfileViewController: UIViewController, MatchProfileProtocol {
    //var interactor : MatchProfileInteractorProtocol?
    var presenter : MatchProfilePresentationProtocol?
    
    // MARK: Object lifecycle
    
    @IBOutlet weak var tblProfileView: UITableView!
    @IBOutlet weak var MatchProfileCollView: UICollectionView!
    
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var pageControl: CustomImagePageControl!
    @IBOutlet weak var lblNameAge: UILabel!
    @IBOutlet weak var lblLiveIn: UILabel!
    @IBOutlet weak var lblDistance: GradientLabel!
    @IBOutlet weak var btnBlock: UIButton!
    @IBOutlet weak var btnViewStories: UIButton!
    
    var UserID : Int!
    var alertView: CustomAlertView!
    var customPickImageView: CustomOptionView!
    
    var objProfileData = MatchProfileData()
    var imageArray = [#imageLiteral(resourceName: "img_intro_2"), #imageLiteral(resourceName: "image_1"), #imageLiteral(resourceName: "Image 63"), #imageLiteral(resourceName: "Image 62")]
    var isFromHome : Bool = true
    var isFromLink : Bool = false
    var arrayDetails :  [UserDetail] = []
    
    var objMatchUserProfile : UserAuthResponseField!
    var tiIsBlocked : Int = 0
    var location:CLLocation?
    var objStoryArray : [StoryResponseArray]?
    var UserCode : String = ""
    
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
        let interactor = MatchProfileInteractor()
        let presenter = MatchProfilePresenter()
        
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
        
        getUserCurrentLocation()
    }
    
    func setTheme(){
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        
        self.profileView.frame = DeviceType.iPhone5orSE ? CGRect(x: 0, y: 0, w: ScreenSize.width, h: 500) : (DeviceType.iPhoneXRMax ||  DeviceType.iPhone678p ? CGRect(x: 0, y: 0, w: ScreenSize.width, h: 650) : CGRect(x: 0, y: 0, w: ScreenSize.width, h: 550))
        self.arrayDetails = fetchUserData()
        self.registerCollectionViewCell()
        self.MatchProfileCollView.reloadData()
    }
    
    func registerCollectionViewCell(){
        self.MatchProfileCollView.register(UINib.init(nibName: Cells.ReactEmojiCollectionCell, bundle: Bundle.main), forCellWithReuseIdentifier: Cells.ReactEmojiCollectionCell)
        self.MatchProfileCollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let layout = CustomImageLayout()
        layout.scrollDirection = .vertical
        self.MatchProfileCollView.collectionViewLayout = layout
        
        let angle = CGFloat.pi/2
        pageControl.transform = CGAffineTransform(rotationAngle: angle)
        self.pageControl.numberOfPages = imageArray.count
        self.pageControl.currentPage = 0
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        if isFromLink {
            AppSingleton.sharedInstance().showHomeVC(fromMatch: false)
        } else {
            if isFromHome {
                self.dismissVC(completion: nil)
            } else {
                self.popVC()
            }
        }
    }
    
    @IBAction func btnViewStoriesAction(_ sender: UIButton) {
        if self.objStoryArray?.count != 0 {
            let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.StoryContentScreen) as? ContentViewController
            controller!.modalTransitionStyle = .crossDissolve
            controller!.modalPresentationStyle = .overCurrentContext
            controller!.isFromMatchVC = true
            controller?.pages = self.objStoryArray!
            self.presentVC(controller!)
        }
    }
    
    @IBAction func btnMatchAction(_ sender: UIButton) {
        self.callSwipeCardAPI(iProfileId: "\(self.UserID!)", tiSwipeType: "1")
    }
    @IBAction func btnShareAction(_ sender: UIButton) {
        let msg = "Hello User, \n\nUse my referral code \(self.objMatchUserProfile.vReferralCode!) to register yourself on the \(appName) app. \n\nThank you,\nJointly Team"
        shareInviteApp(message: msg, link: "jointly://path/\(self.objMatchUserProfile.vReferralCode!)", controller: self)
    }
    @IBAction func btnReportAction(_ sender: UIButton) {
        self.presenter?.gotoReportVC()
    }
    @IBAction func btnBlockAction(_ sender: UIButton) {
         self.showAlertView() //self.showPickImageView()
    }
    
    func setProfileData(){
        self.lblNameAge.text = "\(self.objMatchUserProfile.vName!), \(self.objMatchUserProfile.tiAge!)"
        self.lblLiveIn.text = self.objMatchUserProfile.vLiveIn
        self.pageControl.numberOfPages = self.objMatchUserProfile.photos!.count
        self.pageControl.currentPage = 0
        
        self.tblProfileView.reloadData()
        self.MatchProfileCollView.reloadData()
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
                self.presenter?.callUserProfileAPI(id: self.UserID != nil ? "\(self.UserID!)" : "78", code : self.UserCode)
            }
        }
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

//MARK: API Methods
extension MatchProfileViewController {
    func getUserProfileResponse(response : UserAuthResponseField){
        print(response)
        self.objMatchUserProfile = response
        self.objProfileData.data = response.preference!
        //            self.objProfileData.str = response.txAbout!
        setProfileData()
        self.presenter?.callStoryListAPI(id : self.UserID != nil ? self.UserID! : 78)
        
    }
    
    func getStoryListResponse(response: StoryResponse){
        if response.responseCode == 200 {
            self.presenter?.callBlockUserListAPI()
            self.objStoryArray = response.responseData
            if self.objStoryArray != nil && self.objStoryArray!.count != 0 {
                self.btnViewStories.alpha = 1
            } else {
                self.btnViewStories.alpha = 0
            }
        }
    }
    
    func callBlockUserAPI(){
        self.presenter?.callBlockUserAPI(iBlockTo: "\(self.objMatchUserProfile!.iUserId!)", tiIsBlocked: "\(tiIsBlocked)")
    }
    
    func getBlockUserResponse(response : CommonResponse){
        if response.responseCode == 200 {
            AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle: "OK")
            if tiIsBlocked == 0 {
                self.tiIsBlocked = 1
                self.btnBlock.setTitle("Unblock", for: .normal)
            } else {
                self.tiIsBlocked = 0
                self.btnBlock.setTitle("Block", for: .normal)
            }
        }
    }
    
    func getBlockUserListResponse(response : BlockUser){
        if response.responseCode == 200 {
            if self.objMatchUserProfile.iUserId != nil {
                let data = response.responseData?.filter({($0.iUserId) == self.objMatchUserProfile.iUserId!})
                if data!.count > 0 {
                    self.tiIsBlocked = 1
                    self.btnBlock.setTitle("Unblock", for: .normal)
                }
            }
        }
    }
    
    func callReactEmojiAPI( iUserId: String, iMediaId: String, tiRactionType: String){
        self.presenter?.callReactEmojiAPI(iUserId: iUserId, iMediaId: iMediaId, tiRactionType: tiRactionType)
    }
    
    func getReactEmojiResponse(response : MediaReaction){
        if response.responseCode == 200 {
            self.presenter?.callUserProfileAPI(id: self.UserID == nil ? "78" : "\(self.UserID!)", code : UserCode)
        }
    }
    
    func callSwipeCardAPI(iProfileId : String, tiSwipeType : String){
        self.presenter?.callSwipeCardAPI(iProfileId: iProfileId, tiSwipeType: tiSwipeType)
    }
    
    func getSwipeCardResponse(response : SwipeUser){
        if response.responseCode == 200 {
            if response.responseData?.tiSwipeType == 2 {
                let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.MatchScreen) as! MatchViewController
                controller.isFromProfile = true
                let data = self.objMatchUserProfile
                controller.CardUserDetails = SearchUserFields(iUserId: data?.iUserId, vName: data?.vName, vProfileImage: data?.vProfileImage, tiAge: 0, vLiveIn: "", fLatitude: "", fLongitude: "", storyTime: "", photos: [])
                controller.modalTransitionStyle = .crossDissolve
                controller.modalPresentationStyle = .overCurrentContext
                self.presentVC(controller)
            } else {
                AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle:"OK")
            }
        }
    }
}

//MARK: UITableView Delegate & Datasource Methods
extension MatchProfileViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.objProfileData.cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objMatchUserProfile != nil ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: objProfileData.cells[indexPath.section].cellID)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if objProfileData.cells[indexPath.section].cellID == "ProfileAboutCell" {
            if let cell = cell as? ProfileAboutCell  {
                cell.lblAbout.text = self.objMatchUserProfile.txAbout!
                cell.lblCity.text = self.objMatchUserProfile.vLiveIn!
                cell.lblGender.text = genderArray[(self.objMatchUserProfile.tiGender!)]
            }
        } else if objProfileData.cells[indexPath.section].cellID == "ProfileCompanyCell" {
            if let cell = cell as? ProfileCompanyCell  {
                cell.lblCompanyDetail.text = self.objMatchUserProfile.txCompanyDetail
            }
        } else if objProfileData.cells[indexPath.section].cellID == "PreferenceCell" {
            if let cell = cell as? PreferenceCell  {
                cell.RegisterCellView()
                cell.preferenceDetailsArray = self.objMatchUserProfile.preference!
            }
        }else {
            if let cell = cell as? ProfileSocialCell  {
                cell.clickOnBtn = { (index) in
                    print(index!)
                    if index == 0 {
                        guard let url = URL(string: "https://facebook.com/\(self.objMatchUserProfile.vName!)")  else { return }
                        self.openSocialPlatform(url: url)
                    } else if index == 1 {
                        guard let url = URL(string: "https://instagram.com/\(self.objMatchUserProfile.vName!)")  else { return }
                        self.openSocialPlatform(url: url)
                    } else {
                        guard let url = URL(string: "https://snapchat.com/\(self.objMatchUserProfile.vName!)")  else { return }
                        self.openSocialPlatform(url: url)
                    }
                }
            }
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
        
        return headerView
    }
}

//MARK: UICollectionView Delegate & Datasource Methods
extension MatchProfileViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.objMatchUserProfile != nil && self.objMatchUserProfile.photos!.count != 0) ? self.objMatchUserProfile.photos!.count : 0 //imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : ReactEmojiCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.ReactEmojiCollectionCell, for: indexPath) as! ReactEmojiCollectionCell
        
        let photoString = self.objMatchUserProfile.photos![indexPath.row]
        cell.ReactEmojiView.alpha = cell.btnLike.isSelected ? 1.0 : 0.0
        
        if (self.objMatchUserProfile != nil && photoString.reaction != nil) {
            print(photoString.reaction!)
            if photoString.reaction?.count != 0 {
                if photoString.reaction!.count == 3 {
                    cell.btnKissValue.setTitle((photoString.reaction?.count != 0 && photoString.reaction![2].vCount != "0") ? photoString.reaction![2].vCount : "0", for: .normal)
                    cell.btnLoveSmileValue.setTitle((photoString.reaction?.count != 0 && photoString.reaction![1].vCount != "0") ? photoString.reaction![1].vCount : "0", for: .normal)
                    cell.btnLoveValue.setTitle((photoString.reaction?.count != 0 && photoString.reaction![0].vCount != "0") ? photoString.reaction![0].vCount : "0", for: .normal)
                }
                if photoString.reaction!.count == 2 {
                    cell.btnLoveSmileValue.setTitle((photoString.reaction?.count != 0 && photoString.reaction![1].vCount != "0") ? photoString.reaction![1].vCount : "0", for: .normal)
                    cell.btnLoveValue.setTitle((photoString.reaction?.count != 0 && photoString.reaction![0].vCount != "0") ? photoString.reaction![0].vCount : "0", for: .normal)
                }
                if photoString.reaction!.count == 1  {
                    cell.btnLoveValue.setTitle((photoString.reaction?.count != 0 && photoString.reaction![0].vCount != "0") ? photoString.reaction![0].vCount : "0", for: .normal)
                }
            } else {
                cell.btnKissValue.setTitle("0", for: .normal)
                cell.btnLoveValue.setTitle("0", for: .normal)
                cell.btnLoveSmileValue.setTitle("0", for: .normal)
            }
            if photoString.vMedia != "" {
                let url = URL(string:"\(photoString.vMedia!)")
                print(url!)
                cell.userImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_rect"))
            }
        } else {
            cell.userImgView.image = imageArray[indexPath.row]
        }
        
        cell.clickOnLikeBtn = {
            if cell.btnLike.isSelected {
                cell.btnLike.isSelected = false
                cell.ReactEmojiView.alpha = 0.0
            } else {
                cell.btnLike.isSelected = true
                cell.ReactEmojiView.alpha = 1.0
            }
        }
        
        cell.clickOnbtnKiss = {
            self.callReactEmojiAPI(iUserId: "\(self.objMatchUserProfile!.iUserId!)", iMediaId: "\(photoString.iMediaId!)", tiRactionType: "2")
            cell.btnLike.isSelected = false
            cell.ReactEmojiView.alpha = 0.0
        }
        
        cell.clickOnbtnLove = {
            self.callReactEmojiAPI(iUserId: "\(self.objMatchUserProfile!.iUserId!)", iMediaId: "\(photoString.iMediaId!)", tiRactionType: "0")
            cell.btnLike.isSelected = false
            cell.ReactEmojiView.alpha = 0.0
        }
        
        cell.clickOnbtnLoveSmile = {
            self.callReactEmojiAPI(iUserId: "\(self.objMatchUserProfile!.iUserId!)", iMediaId: "\(photoString.iMediaId!)", tiRactionType: "1")
            cell.btnLike.isSelected = false
            cell.ReactEmojiView.alpha = 0.0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Parallax visible cells
        let center = CGPoint(x: (scrollView.frame.width / 2), y: scrollView.contentOffset.y + (scrollView.frame.width / 2))
        if let ip = MatchProfileCollView.indexPathForItem(at: center) {
            self.pageControl.currentPage = ip.row
        }
    }
}

//MARK: AlertView Delegate Methods
extension MatchProfileViewController {
    func showAlertView() {
        alertView = CustomAlertView.initAlertView(title: tiIsBlocked == 0 ? kBlockStr : kUnblockStr, message: tiIsBlocked == 0 ? kBlockDesStr : kUnblockDesStr, btnRightStr: tiIsBlocked == 0 ? "Block" : "Unblock", btnCancelStr: "Cancel", btnCenter: "", isSingleButton: false)
      alertView.delegate = self
      alertView.frame = self.view.frame
      self.view.addSubview(alertView)
    }
    
    func showPickImageView() {
      customPickImageView = CustomOptionView.initAlertView()
      customPickImageView.frame = self.view.frame
      self.view.addSubview(customPickImageView)
    }
}

extension MatchProfileViewController : AlertViewDelegate {
    func OkButtonAction() {
        alertView.removeFromSuperview()
        self.callBlockUserAPI()
    }
    
    func cancelButtonAction() {
        alertView.removeFromSuperview()
    }
}

