//
//  NotificationListViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 15/05/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol NotificationListProtocol: class {
    func getNotificationListResponse(response : NotificationResponse)
    func getReadNotificationResponse(response: ViewNotification)
    func getClearAllNotificationResponse(response: ViewNotification)
    func getBadgeCountResponse(response : ViewNotification)
}

struct NotificationListModel {
    var objNotification : NotificationFields!
    var objResNotificationList : [NotificationFields]!
    var objNotificationList : [NotificationFields]!
}

class NotificationListViewController: UIViewController, NotificationListProtocol {
    //var interactor : NotificationListInteractorProtocol?
    var presenter : NotificationListPresentationProtocol?
    
    @IBOutlet weak var tblNotificationList: UITableView!
    @IBOutlet weak var lblNoNotification: UILabel!
    @IBOutlet weak var btnClearAll: UIButton!
    
    var objNotificationModel : [SocialMediaLinkModel] = []
    var loadMore = LoadMore()
    var arrNotification = NotificationListModel()
    
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
        let interactor = NotificationListInteractor()
        let presenter = NotificationListPresenter()
        
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
        self.registerTableViewCell()
    }

    func registerTableViewCell(){
        self.objNotificationModel = [SocialMediaLinkModel(image: #imageLiteral(resourceName: "match"), title: "Match", link: "Test match user"), SocialMediaLinkModel(image: #imageLiteral(resourceName: "noti_boosts"), title: "Notification", link: "Test notification"), SocialMediaLinkModel(image: #imageLiteral(resourceName: "noti_Subscription"), title: "Boost", link: "Test boost user")]
        self.tblNotificationList.register(UINib.init(nibName: Cells.NotificationListCell, bundle: Bundle.main), forCellReuseIdentifier: Cells.NotificationListCell)
        self.callAPI()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.popVC()
    }
    @IBAction func btnClearAllAction(_ sender: UIButton) {
        self.callReadNotiAPI(iNotificationId: "", tiType: "")
    }
}

//MARK: API Methods
extension NotificationListViewController {
    func callAPI(isPullToRefresh: Bool = false){
        if isPullToRefresh {
            LoaderView.sharedInstance.showLoader()
            loadMore.index = 0
        }
        loadMore.isLoading = true
        let index = loadMore.index > 0 ? self.arrNotification.objNotificationList.count : 0
        
        self.presenter?.callAPI(offset: index, limit: 10)
    }
    
    func getNotificationListResponse(response : NotificationResponse){
        loadMore.isLoading = false
        if response.responseCode == 200 {
            self.arrNotification.objResNotificationList = response.responseData?.arrayList
                if self.arrNotification.objResNotificationList.count == 0 {
                    self.lblNoNotification.alpha = 1.0
                    self.btnClearAll.alpha = 0.0
                } else {
                    self.lblNoNotification.alpha = 0.0
                    self.btnClearAll.alpha = 1.0
                }
            } else {
                self.lblNoNotification.alpha = 1.0
                self.btnClearAll.alpha = 0.0
            }
            
            guard let arrData = self.arrNotification.objResNotificationList else {
                return
            }
            if loadMore.index == 0 || self.arrNotification.objResNotificationList == nil {
                self.arrNotification.objNotificationList = []
            }
            
            arrData.forEach { (obj) in
                self.arrNotification.objNotificationList.append(obj)
            }
            
            loadMore.isAllLoaded = self.arrNotification.objNotificationList.count == response.responseData!.count// ?? 0
            if !loadMore.isAllLoaded {
                loadMore.index += 1
            } else {
                loadMore.index = 0
                LoaderView.sharedInstance.hideLoader()
            }
            let value = self.arrNotification.objNotificationList!.filter({($0.tiIsRead) != 1})
            if value.count != 0 {
                UserDataModel.setNotificationCount(count: value.count)
            } else {
                UserDataModel.setNotificationCount(count: 0)
        }
            self.tblNotificationList.reloadData()
    }
    
    func callReadNotiAPI(iNotificationId: String, tiType : String){
        self.presenter?.callReadAPI(iNotificationId: iNotificationId, tiType : tiType)
    }
    
    func getReadNotificationResponse(response: ViewNotification) {
        if response.responseCode == 200 {
            loadMore.index = 0
            callAPI()
        } else {
            AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle: "OK")
        }
    }
    func getClearAllNotificationResponse(response: ViewNotification) {
        self.objNotificationModel.removeAll()
        self.tblNotificationList.reloadData()
        self.popVC()
        AppSingleton.sharedInstance().showAlert(kClearNotification, okTitle: "OK")
    }
    
    func callBadgeCountAPI(){
        self.presenter?.callBadgeCountAPI()
    }
    
    func getBadgeCountResponse(response : ViewNotification) {
        if response.responseCode == 200 {
//            UserDataModel.setNotificationCount(count: (response.responseData?.budgeCount)!)
        } 
    }
}

//MARK: UITableView Delegate Methods
extension NotificationListViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNotification.objNotificationList != nil ? self.arrNotification.objNotificationList.count : 0 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.NotificationListCell)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? NotificationListCell {
            
            let data = self.arrNotification.objNotificationList[indexPath.row]
            let type = NotificationImages.filter({($0["type"]!) as! String == "\(data.tiType!)"})
            if type.count != 0 {
                cell.imageView?.image = type[0]["image"]! as? UIImage
            }
//            cell.imageView?.image = data.image
            cell.lblTitle.text = data.vTitle
            cell.lblDesc.text = data.txmessage
            cell.lblTime.text = Date(timeIntervalSince1970: Double(data.iCreatedAt!)!).agoStringFromTime()
            cell.selectionStyle = .none
            
            if data.tiIsRead == 0 {
                let formattedString = NSMutableAttributedString()
                formattedString.bold(data.txmessage!)
                cell.lblDesc.attributedText = formattedString
                cell.lblDesc.textColor = .black
            } else {
                let formattedString = NSMutableAttributedString()
                formattedString.normal(data.txmessage!)
                cell.lblDesc.attributedText = formattedString
                cell.lblDesc.textColor = .lightGray
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.arrNotification.objNotificationList[indexPath.row]
        if data.tiIsRead == 0 {
            self.callReadNotiAPI(iNotificationId: "\(data.iNotificationId!)", tiType: "\(data.tiType!)")
        }
        if data.tiType == 1 {
            let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.MatchScreen) as! MatchViewController
            controller.isFromNotification = true
            controller.OtherUserData = ["UserID": data.iOtherUserId!, "name" : data.vOtherProfileName!, "profileImage" : data.vOtherProfileImage!]
            controller.modalTransitionStyle = .crossDissolve
            controller.modalPresentationStyle = .overCurrentContext
            self.presentVC(controller)
        }
    }
}
