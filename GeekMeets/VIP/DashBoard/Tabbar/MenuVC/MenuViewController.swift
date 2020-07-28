//
//  MenuViewController.swift
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
import CoreLocation

class MenuViewModel {
    let leftImage: UIImage?
    var label: String
    let rightImage: UIImage?
    
    init(leftImage: UIImage? = nil, label: String, rightImage: UIImage? = nil) {
        self.leftImage = leftImage
        self.label = label
        self.rightImage = rightImage
    }
}

protocol MenuProtocol: class {
    func getSignOutResponse(response : UserAuthResponse)
    func getLocationUpdateResponse(response : UserAuthResponse)
    func getPushStatusResponse(response : UserAuthResponse)
    func getMatchResponse(response : MatchUser)
    func getGeeksPlansResponse(response : BoostGeekResponse)
}

class MenuViewController: UIViewController, MenuProtocol {
    //var interactor : MenuInteractorProtocol?
    var presenter : MenuPresentationProtocol?
    
    @IBOutlet weak var tblMenuList: UITableView!
    @IBOutlet weak var RemainTimeView: UIView!
    @IBOutlet weak var lblRemainTime: UILabel!
    @IBOutlet weak var remainTimeViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var headerViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var lblUserNameAge: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var btnNotification: UIButton!
    
    var alertView: CustomAlertView!
    var arrMenuModel : [MenuViewModel] = []
    var genderArray : [String] = ["Male", "Female", "Others", "Prefer not to say"]
    
    var timer = Timer()
    var totalTime = 600
    var totalDay : Int!
    var totalHour : Int!
    var totalMin : Int!
    var totalSecond : Int!
    
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
        let interactor = MenuInteractor()
        let presenter = MenuPresenter()
        
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
        self.presenter?.callMatchListAPI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.presenter?.callMatchListAPI()
    }
    
    func setTheme() {
        self.navigationController?.isNavigationBarHidden = true
        self.lblVersion.text = "Version \(Bundle.main.releaseVersionNumber!) Build \(Bundle.main.buildVersionNumber!)"
        
        //Geeks Functionality
//        startTimer()
//        self.RemainTimeView.alpha = 0.0
//        self.remainTimeViewHeightConstant.constant = 0
//        self.profileView.frame = CGRect(x: 0, y: 0, w: ScreenSize.width, h: 250)
        
        //Profile Name & Image setup
        self.lblUserNameAge.text = "\(UserDataModel.currentUser?.vName ?? ""), \(UserDataModel.currentUser?.tiAge ?? 0)"
        if UserDataModel.currentUser?.vProfileImage != "" {
            let url = URL(string:"\(UserDataModel.currentUser!.vProfileImage!)")
            print(url!)
            self.imgProfile.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_round"))
        }
        
        if UserDataModel.getNotificationCount() != 0 {
            self.btnNotification.setImage(#imageLiteral(resourceName: "icn_notification"), for: .normal)
        } else {
            self.btnNotification.setImage(#imageLiteral(resourceName: "bell"), for: .normal)
        }
        
        self.btnEditProfile.underlineButton(text: "Edit Profile", font: UIFont(name: FontTypePoppins.Poppins_Regular.rawValue, size: 12)!, color: #colorLiteral(red: 0.5294117647, green: 0.1803921569, blue: 0.7647058824, alpha: 1))
        let matchCount = UserDataModel.getMatchesCount()
        arrMenuModel = [MenuViewModel(leftImage: #imageLiteral(resourceName: "icn_my_match"), label: "My Matches (\(matchCount))", rightImage: #imageLiteral(resourceName: "icn_arrow")),
                        MenuViewModel(leftImage: #imageLiteral(resourceName: "icn_manage_subscription"), label: "Manage Subscription", rightImage: #imageLiteral(resourceName: "icn_arrow")),
                        MenuViewModel(leftImage: #imageLiteral(resourceName: "icn_boosts_purple"), label: "Boosts (2)", rightImage: #imageLiteral(resourceName: "icn_arrow")),
                        MenuViewModel(leftImage: #imageLiteral(resourceName: "icn_top_geeks"), label: "Top Geeks (2)", rightImage: #imageLiteral(resourceName: "icn_arrow")),
                        MenuViewModel(leftImage: #imageLiteral(resourceName: "icn_user_purple"), label: "Account Settings", rightImage: #imageLiteral(resourceName: "icn_arrow")),
                        MenuViewModel(leftImage: #imageLiteral(resourceName: "icn_discovery"), label: "Discovery Settings", rightImage: #imageLiteral(resourceName: "icn_arrow")),
                        MenuViewModel(leftImage: #imageLiteral(resourceName: "icn_manage_subscription"), label: "Push Notification", rightImage: #imageLiteral(resourceName: "icn_off")),
                        MenuViewModel(leftImage: #imageLiteral(resourceName: "icn_location"), label: "Location", rightImage: #imageLiteral(resourceName: "icn_off")),
                        /*MenuViewModel(leftImage: #imageLiteral(resourceName: "icn_share"), label: "Share & Earn", rightImage: #imageLiteral(resourceName: "icn_arrow")),*/
            MenuViewModel(leftImage: #imageLiteral(resourceName: "icn_tips"), label: "Tips", rightImage: #imageLiteral(resourceName: "icn_arrow")),
            MenuViewModel(leftImage: #imageLiteral(resourceName: "icn_contact"), label: "Contact Us", rightImage: #imageLiteral(resourceName: "icn_arrow")),
            MenuViewModel(leftImage: #imageLiteral(resourceName: "icn_legal"), label: "Legal", rightImage: #imageLiteral(resourceName: "icn_arrow"))]
        self.tblMenuList.reloadData()
    }
    
    func startTimer() {
      timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
      
      if totalSecond != nil || totalMin != nil {
        if totalSecond != 0 {
          totalSecond -= 1
        }
        
//        if "\(totalSecond!)".firstCharacterAsString == "0" {
//          totalSecond = 60
//          totalMin -= 1
//        }
//
//        if "\(totalMin!)".firstCharacterAsString == "0" {
//          totalMin = 60
//          totalHour -= 1
//        }
        self.lblRemainTime.text = "\(totalMin!):\(totalSecond!) Remaining"
        
        if "\(totalMin!)".firstCharacterAsString == "0" && "\(totalSecond!)".firstCharacterAsString == "0" {
            totalMin = 0
            totalSecond = 0
            endTimer()
            self.lblRemainTime.text = "\(00):\(00) Remaining"
        }
        
      } else {
        endTimer()
        self.RemainTimeView.alpha = 0.0
        self.remainTimeViewHeightConstant.constant = 0
        self.profileView.frame = CGRect(x: 0, y: 0, w: ScreenSize.width, h: 250)
        timer.invalidate()
        self.tblMenuList.reloadData()
      }
    }
    
    func endTimer() {
      timer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    @IBAction func btnLogOutAction(_ sender: UIButton) {
        self.showAlertView()
    }
    @IBAction func btnEditProfileAction(_ sender: UIButton) {
        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.EditProfileScreen) as! EditProfileViewController
        self.pushVC(controller)
    }
    @IBAction func btnNotificationAction(_ sender: UIButton) {
        let controller = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.NotificationScreen)
        self.pushVC(controller)
    }
    
    func displayAlert(strTitle : String, strMessage : String) {
        self.showAlert(title: strTitle, message: strMessage)
    }
    
    func setPlansDetails(date : String){
        let Dateformatter = DateFormatter()
        Dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myTimeInterval = TimeInterval(Int((date))!)
        let date1 = Date(timeIntervalSince1970: TimeInterval(myTimeInterval))
        
        let dateStr1 = Dateformatter.string(from: date1)
        let dateStr2 = Dateformatter.string(from: Date())
        
        if dateStr1 != "" {
            (totalHour, totalMin, totalSecond) = timeGapBetweenDates(previousDate: dateStr1, currentDate: dateStr2)
        }
        if dateStr1.compare(dateStr2) == .orderedDescending  {
            startTimer()
        } else {
            //         viewTimer.isHidden = true
            //         viewMeeting.isHidden = false
        }
    }
}

extension MenuViewController {
    func getMatchResponse(response : MatchUser) {
        UserDataModel.setMatchesCount(count: response.responseData!.count)
        setTheme()
        self.presenter?.callGeeksPlansAPI()
    }
    
    func getGeeksPlansResponse(response : BoostGeekResponse){
        print(response)
        if response.responseCode == 200 {
            setPlansDetails(date: (response.responseData?.iExpireAt)!)
        } else {
            setTheme()
            self.RemainTimeView.alpha = 0.0
            self.remainTimeViewHeightConstant.constant = 0
            self.profileView.frame = CGRect(x: 0, y: 0, w: ScreenSize.width, h: 250)
        }
    }
}
//MARK: Tableview Delegate & Datasource Methods
extension MenuViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenuModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MenuCell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        let viewModel = arrMenuModel[indexPath.row]
        
        cell.btnLeft.setImage(viewModel.leftImage, for: .normal)
        cell.lblTitle.text = viewModel.label
        
        if indexPath.row == 6 {
            if UserDataModel.currentUser?.tiIsAcceptPush == 1 {
                cell.btnRight.setImage(#imageLiteral(resourceName: "icn_on"), for: .normal)
            } else {
                cell.btnRight.setImage(#imageLiteral(resourceName: "icn_off"), for: .normal)
            }
        } else if indexPath.row == 7 {
            if UserDataModel.currentUser?.tiIsLocationOn == 1 {
                cell.btnRight.setImage(#imageLiteral(resourceName: "icn_on"), for: .normal)
            } else {
                cell.btnRight.setImage(#imageLiteral(resourceName: "icn_off"), for: .normal)
            }
        } else {
            cell.btnRight.setImage(#imageLiteral(resourceName: "chevron-down (1)"), for: .normal)
        }
        
        cell.clickOnSwitchBtn = {
            if indexPath.row == 6 {
                if UserDataModel.currentUser?.tiIsAcceptPush == 1 {
                    self.presenter?.callPushStatusAPI(tiIsAcceptPush : "0")
                    cell.btnRight.isSelected = false
                } else {
                    self.presenter?.callPushStatusAPI(tiIsAcceptPush : "1")
                    cell.btnRight.isSelected = true
                }
            }
            if indexPath.row == 7 {
                if UserDataModel.currentUser?.tiIsLocationOn == 1 {
                    self.getUserCurrentLocation(tiIsLocationOn: "0")
                    cell.btnRight.isSelected = false
                } else {
                    self.getUserCurrentLocation(tiIsLocationOn: "1")
                    cell.btnRight.isSelected = true
                }
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let matchVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.MyMatchesScreen)
            self.pushVC(matchVC)
        } else if indexPath.row == 1 {
            let subVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.ManageSubscriptionScreen) as! ManageSubscriptionViewController
            subVC.modalTransitionStyle = .crossDissolve
            subVC.modalPresentationStyle = .overCurrentContext
            self.presentVC(subVC)
        } else if indexPath.row == 2 {
            let boostVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.BoostScreen) as! BoostViewController
            boostVC.modalTransitionStyle = .crossDissolve
            boostVC.modalPresentationStyle = .overCurrentContext
            self.presentVC(boostVC)
        } else if indexPath.row == 3 {
            let topVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.TopGeeksScreen) as! TopGeeksViewController
            topVC.modalTransitionStyle = .crossDissolve
            topVC.modalPresentationStyle = .overCurrentContext
            self.presentVC(topVC)
        } else if indexPath.row == 4 {
            let accVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.AccountSettingScreen)
            self.pushVC(accVC)
        } else if indexPath.row == 5 {
            let discVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.DiscoverySettingScreen) as? DiscoverySettingViewController
            discVC?.isFromMenu = false
            self.pushVC(discVC!)
        }  /*else if indexPath.row == 8 {
            let shareVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.Share_EarnScreen)
            self.pushVC(shareVC)
        }*/ else if indexPath.row == 8 {
            let tipsVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.TipsScreen) as! TipsViewController
            self.pushVC(tipsVC)
        } else if indexPath.row == 9 {
            let conVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.ContactUS_LegalScreen) as? ContactUS_LegalViewController
            conVC?.isForLegal = false
            self.pushVC(conVC!)
        } else if indexPath.row == 10 {
            let conVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.ContactUS_LegalScreen) as? ContactUS_LegalViewController
            conVC?.isForLegal = true
            self.pushVC(conVC!)
        }
    }
}

//MARK: API Methods
extension MenuViewController {
    
    func callSignoutAPI(){
        self.presenter?.callSignoutAPI()
    }
    
    func getSignOutResponse(response : UserAuthResponse){
        if response.responseCode == 200 {
            AppSingleton.sharedInstance().logout()
        } else {
            self.displayAlert(strTitle: "", strMessage: response.responseMessage!)
        }
    }
    
    func callUpdateLocationAPI(fLatitude : String, fLongitude : String, tiIsLocationOn : String){
        self.presenter?.callUpdateLocationAPI(fLatitude: fLatitude, fLongitude: fLongitude, tiIsLocationOn: tiIsLocationOn)
    }
    func getLocationUpdateResponse(response : UserAuthResponse){
        if response.responseCode == 200 {
            UserDataModel.currentUser?.tiIsLocationOn = response.responseData?.tiIsLocationOn
            self.tblMenuList.reloadData()
//            AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle: "OK")
        }
    }
    
    func getPushStatusResponse(response : UserAuthResponse){
        if response.responseCode == 200 {
            UserDataModel.currentUser?.tiIsAcceptPush = response.responseData?.tiIsAcceptPush
            self.tblMenuList.reloadData()
//            AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle: "OK")
        }
    }
    
    func showAlertView() {
        alertView = CustomAlertView.initAlertView(title: "Logout", message: "Are you sure you want to Logout?", btnRightStr: "Logout", btnCancelStr: "Cancel", btnCenter: "", isSingleButton: false)
        alertView.delegate = self
        alertView.frame = self.view.frame
        AppDelObj.window?.addSubview(alertView)
    }
    
    func getUserCurrentLocation(tiIsLocationOn : String) {
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
                self.callUpdateLocationAPI(fLatitude: String(Float((currLocation?.coordinate.latitude)!)), fLongitude: String(Float((currLocation?.coordinate.longitude)!)), tiIsLocationOn : tiIsLocationOn)
            }
        }
    }
}

//MARK: AlertView Delegate Methods
extension MenuViewController : AlertViewDelegate {
    func OkButtonAction(title : String) {
        alertView.alpha = 0.0
        self.callSignoutAPI()
    }
    
    func cancelButtonAction() {
        alertView.alpha = 0.0
    }
}
