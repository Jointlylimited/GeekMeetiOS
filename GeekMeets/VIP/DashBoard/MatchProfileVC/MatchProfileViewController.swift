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

struct MatchProfileData {
  
  var cells: [ProfileListCells] {
    var cell: [ProfileListCells] = []
    let str = "Lady with fun loving personality and open- minded, Looking for Someone to hang out always open for hangout"
    cell.append(.AboutCell(obj: str))
    cell.append(.CompanyCell)
    cell.append(.SocialCell)
    
    return cell
  }
}

protocol MatchProfileProtocol: class {
    func getUserProfileResponse(response : UserAuthResponse)
    func getBlockUserResponse(response : CommonResponse)
    func getBlockUserListResponse(response : BlockUser)
    func getReactEmojiResponse(response : MediaReaction)
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
    
    var alertView: CustomAlertView!
    var customPickImageView: CustomOptionView!
    
    var objProfileData = MatchProfileData()
    var imageArray = [#imageLiteral(resourceName: "img_intro_2"), #imageLiteral(resourceName: "image_1"), #imageLiteral(resourceName: "Image 63"), #imageLiteral(resourceName: "Image 62")]
    var isFromHome : Bool = true
    var arrayDetails :  [UserDetail] = []
    
    var objMatchUserProfile : UserAuthResponseField!
    var tiIsBlocked : Int = 0
    var location:CLLocation?
    
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
//        getUserCurrentLocation()
//        self.presenter?.callUserProfileAPI(id: "70")
    }
    
    func setTheme(){
        self.profileView.frame = DeviceType.iPhone5orSE ? CGRect(x: 0, y: 0, w: ScreenSize.width, h: 400) : (DeviceType.iPhoneXRMax ||  DeviceType.iPhone678p ? CGRect(x: 0, y: 0, w: ScreenSize.width, h: 500) : CGRect(x: 0, y: 0, w: ScreenSize.width, h: 450))
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
        if isFromHome {
            self.dismissVC(completion: nil)
        } else {
            self.popVC()
        }
    }
    
    @IBAction func btnViewStoriesAction(_ sender: UIButton) {
        
        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.StoryContentScreen) as? ContentViewController
        controller!.modalTransitionStyle = .crossDissolve
        controller!.modalPresentationStyle = .overCurrentContext
        controller!.isFromMatchVC = true
        controller?.pages = self.arrayDetails
        self.presentVC(controller!)
    }
    
    @IBAction func btnMatchAction(_ sender: UIButton) {
        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.MatchScreen) as! MatchViewController
        controller.UserDetails = self.objMatchUserProfile
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .overCurrentContext
        self.presentVC(controller)
    }
    @IBAction func btnShareAction(_ sender: UIButton) {
        shareInviteApp(message: "Google", link: "htttp://google.com", controller: self)
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
        let userLocation = CLLocation(latitude: CLLocationDegrees(exactly: Float(self.objMatchUserProfile.fLatitude!)!)!, longitude: CLLocationDegrees(exactly: Float(self.objMatchUserProfile.fLongitude!)!)!)
        let distanceInMeters = location!.distance(from: userLocation)
        if(distanceInMeters <= 1609)
        {
            let s =   String(format: "%.2f", distanceInMeters)
            self.lblDistance.text = s + " mi"
        }
        else
        {
            let s =   String(format: "%.2f", distanceInMeters)
            self.lblDistance.text = s + " mi"

        }
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
                self.presenter?.callUserProfileAPI(id: "70")
            }
        }
    }
}

extension MatchProfileViewController {
    func getUserProfileResponse(response : UserAuthResponse){
        if response.responseCode == 200 {
            self.objMatchUserProfile = response.responseData!
            setProfileData()
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
            } else {
                self.tiIsBlocked = 0
            }
        }
    }
    
    func getBlockUserListResponse(response : BlockUser){
        if response.responseCode == 200 {
            AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle: "OK")
        }
    }
    
    func callReactEmojiAPI( iUserId: String, iMediaId: String, tiRactionType: String){
        self.presenter?.callReactEmojiAPI(iUserId: iUserId, iMediaId: iMediaId, tiRactionType: tiRactionType)
    }
    
    func getReactEmojiResponse(response : MediaReaction){
        if response.responseCode == 200 {
            self.presenter?.callUserProfileAPI(id: "\(self.objMatchUserProfile!.iUserId!)")
        }
    }
}
extension MatchProfileViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.objProfileData.cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //self.objMatchUserProfile != nil ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: objProfileData.cells[indexPath.section].cellID)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if objProfileData.cells[indexPath.section].cellID == "ProfileAboutCell" {
            if let cell = cell as? ProfileAboutCell  {
//                print("User Profile Details : \(self.objMatchUserProfile.txAbout!)")
//                cell.lblAbout.text = self.objMatchUserProfile.txAbout!
//                cell.lblCity.text = self.objMatchUserProfile.vLiveIn!
//                cell.lblGender.text = genderArray[(self.objMatchUserProfile.tiGender!)]
            }
        } else if objProfileData.cells[indexPath.section].cellID == "ProfileCompanyCell" {
            if let cell = cell as? ProfileCompanyCell  {
//                cell.lblCompanyDetail.text = self.objMatchUserProfile.txCompanyDetail
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
        
        return headerView
    }
}

extension MatchProfileViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count //(self.objMatchUserProfile != nil && self.objMatchUserProfile.photos!.count != 0) ? self.objMatchUserProfile.photos!.count : 0 //imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : ReactEmojiCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.ReactEmojiCollectionCell, for: indexPath) as! ReactEmojiCollectionCell
        
//        let photoString = self.objMatchUserProfile.photos![indexPath.row]
        cell.ReactEmojiView.alpha = cell.btnLike.isSelected ? 1.0 : 0.0
        cell.userImgView.image = imageArray[indexPath.row]
        
        /*if (self.objMatchUserProfile != nil && self.objMatchUserProfile.photos!.count != 0) {
            
            if photoString.reaction![0].responseData != nil {
                cell.btnKissValue.setTitle((photoString.reaction?.count != 0 && photoString.reaction![0].responseData!.count != 0) ? photoString.reaction![0].responseData![2].vCount : "0", for: .normal)
                cell.btnLoveValue.setTitle((photoString.reaction?.count != 0 && photoString.reaction![0].responseData!.count != 0) ? photoString.reaction![0].responseData![0].vCount : "0", for: .normal)
                cell.btnLoveSmileValue.setTitle((photoString.reaction?.count != 0 && photoString.reaction![0].responseData!.count != 0) != 0 ? photoString.reaction![0].responseData![1].vCount : "0", for: .normal)
            }
            
            if photoString.vMedia != "" {
                let url = URL(string:"\(fileUploadURL)\(user_Profile)\(photoString.vMedia!)")
                print(url!)
                cell.userImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "icn_user"))
            }
        } else {
            cell.userImgView.image = imageArray[indexPath.row]
        }*/
        
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
//            self.callReactEmojiAPI(iUserId: "\(self.objMatchUserProfile!.iUserId!)", iMediaId: "\(photoString.iMediaId!)", tiRactionType: "2")
            cell.btnKissValue.setTitle(String(Int(cell.btnKissValue.titleLabel!.text!)! + 1), for: .normal)
            cell.btnLike.isSelected = false
            cell.ReactEmojiView.alpha = 0.0
        }
        
        cell.clickOnbtnLove = {
//            self.callReactEmojiAPI(iUserId: "\(self.objMatchUserProfile!.iUserId!)", iMediaId: "\(photoString.iMediaId!)", tiRactionType: "0")
            cell.btnLoveValue.setTitle(String(Int(cell.btnLoveValue.titleLabel!.text!)! + 1), for: .normal)
            cell.btnLike.isSelected = false
            cell.ReactEmojiView.alpha = 0.0
        }
        
        cell.clickOnbtnLoveSmile = {
//            self.callReactEmojiAPI(iUserId: "\(self.objMatchUserProfile!.iUserId!)", iMediaId: "\(photoString.iMediaId!)", tiRactionType: "1")
            cell.btnLoveSmileValue.setTitle(String(Int(cell.btnLoveSmileValue.titleLabel!.text!)! + 1), for: .normal)
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

extension MatchProfileViewController {
    func showAlertView() {
      alertView = CustomAlertView.initAlertView(title: "Are you sure you want to block?", message: "User will not able to see your profile after blocking", btnRightStr: "Block", btnCancelStr: "Cancel", btnCenter: "", isSingleButton: false)
      alertView.delegate = self
      alertView.frame = self.view.frame
      self.view.addSubview(alertView)
    }
    
    func showPickImageView() {
      customPickImageView = CustomOptionView.initAlertView()
//      customPickImageView.delegate = self
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
//        self.presenter?.callBlockUserListAPI()
    }
}

//extension MatchProfileViewController : PickImageViewDelegate {
//    
//    func CameraButtonAction(){
//        customPickImageView.removeFromSuperview()
//    }
//    
//    func GifButtonAction(){
//         customPickImageView.removeFromSuperview()
//    }
//    
//    func LocationButtonAction(){
//         customPickImageView.removeFromSuperview()
//    }
//}
