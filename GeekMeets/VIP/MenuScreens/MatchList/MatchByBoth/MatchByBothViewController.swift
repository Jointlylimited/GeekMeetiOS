//
//  MatchByBothViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 11/08/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SubscriptionPurchseDelegate {
    func isPurchased(success : Bool)
}

protocol MatchByBothProtocol: class {
    func getMatchResponse(response : MatchUser)
    func getUnMatchResponse(response : CommonResponse)
}

class MatchByBothViewController: UIViewController, MatchByBothProtocol {
    //var interactor : MatchByBothInteractorProtocol?
    var presenter : MatchByBothPresentationProtocol?
    
    @IBOutlet weak var tblMatchList: UITableView!
    @IBOutlet weak var lblNoUser: UILabel!
    @IBOutlet weak var LikesCollectionView: UICollectionView!
    @IBOutlet weak var btnPurchase: GradientButton!
    
    var objMatchData : [SwipeUserFields] = []
    var parentNavigationController : UINavigationController?
    var arrFriends:[Model_ChatFriendList] = [Model_ChatFriendList]()
    var customAlertView: CustomAlertView!
    var otherXmppID : String? = ""
    
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
        let interactor = MatchByBothInteractor()
        let presenter = MatchByBothPresenter()
        
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
        self.setStoryMsgViewData()
    }
    
    func registerTableViewCell(){
        self.tblMatchList.register(UINib.init(nibName: Cells.MessageListCell, bundle: Bundle.main), forCellReuseIdentifier: Cells.MessageListCell)
        
        self.LikesCollectionView.register(UINib.init(nibName: Cells.MatchCollectionViewCell, bundle: Bundle.main), forCellWithReuseIdentifier: Cells.MatchCollectionViewCell)
        self.LikesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let layout = CustomImageLayout()
        layout.scrollDirection = .vertical
        self.LikesCollectionView.collectionViewLayout = layout
    }
    
    func setStoryMsgViewData(){
        self.presenter?.callMatchListAPI()
    }
    
    func getMessageListDetails(){
        self.arrFriends = SOXmpp.manager.arrFriendsList
        self.tblMatchList.reloadData()
    }
    
    func presentSubVC(){
        let subVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.ManageSubscriptionScreen) as! ManageSubscriptionViewController
        subVC.purchseDelegate = self
        subVC.modalTransitionStyle = .crossDissolve
        subVC.modalPresentationStyle = .overFullScreen
        self.presentVC(subVC)
    }
    
    @IBAction func btnPurchaseAction(_ sender: GradientButton) {
        presentSubVC()
    }
}

extension MatchByBothViewController : SubscriptionPurchseDelegate {
    func isPurchased(success : Bool){
        self.presenter?.callMatchListAPI()
    }
}

extension MatchByBothViewController {
    func getMatchResponse(response : MatchUser) {
        UserDataModel.setMatchesCount(count: response.responseData!.count)
        self.objMatchData = response.responseData!
        self.objMatchData = self.objMatchData.reversed()
        if self.objMatchData.count != 0 {
            self.tblMatchList.alpha = 1.0
            self.LikesCollectionView.alpha = 1.0
            self.lblNoUser.alpha = 0.0
        } else {
            self.tblMatchList.alpha = 0.0
            self.LikesCollectionView.alpha = 0.0
            self.lblNoUser.alpha = 1.0
        }
        
        if UserDataModel.currentUser?.tiIsSubscribed == 0 {
            self.btnPurchase.alpha = 1.0
        } else {
            self.btnPurchase.alpha = 0.0
        }
        self.getMessageListDetails()
        self.LikesCollectionView.reloadData()
    }
    
    func getUnMatchResponse(response : CommonResponse){
        if response.responseCode == 200 {
            self.presenter?.callMatchListAPI()
        }
    }
}

//MARK: UITableView Delegate & Datasource Methods
extension MatchByBothViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objMatchData.count != 0 ? self.objMatchData.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.MessageListCell)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? MessageListCell {
            
            cell.btnChat.alpha = 1.0
            
            if self.objMatchData.count != 0  {
                let data = self.objMatchData[indexPath.row]
                let url = URL(string:"\(data.vProfileImage!)")
                cell.userImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_round"))
                cell.userName.text = data.vProfileName
                cell.msgText.text = data.iMatchDateTime
                
                cell.clickOnChatBtn = {
                    let obj = GeekMeets_StoryBoard.Chat.instantiateViewController(withIdentifier: GeekMeets_ViewController.OneToOneChatScreen) as! OneToOneChatVC
                    
                    if self.arrFriends.count == 0 {
                        obj.objFriend?.jID = UserDataModel.currentUser?.vXmppUser ?? ""
                        obj._userIDForRequestSend = data.vOtherUserXmpp
                        obj.userName = data.vProfileName
                        obj.imageString = data.vProfileImage
                    } else {
                        let arr = self.arrFriends.filter({$0.jID.split("@").first! == data.vOtherUserXmpp})
                        if arr.count != 0 {
                            obj.objFriend = arr[0]
                        } else {
                            obj.objFriend?.jID = UserDataModel.currentUser?.vXmppUser ?? ""
                            obj._userIDForRequestSend = data.vOtherUserXmpp
                            obj.userName = data.vProfileName
                            obj.imageString = data.vProfileImage
                        }
                    }
                    obj.modalPresentationStyle = .fullScreen
                    self.parentNavigationController?.pushViewController(obj, animated: true)
                }
            }
            
            if UserDataModel.currentUser?.tiIsSubscribed == 1 {
                cell.btnChat.alpha = 1
            } else {
                cell.btnChat.alpha = 0
            }
            cell.msgTime.alpha = 0.0
            cell.msgCount.alpha = 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.presenter?.callUnMatchUserAPI(iProfileId: "\(self.objMatchData[indexPath.row].vOtherUserXmpp!)")
            //whatever
            success(true)
        })
        let theImage: UIImage? = UIImage(named:"icn_unmatch")?.withRenderingMode(.alwaysOriginal)
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.8941176471, blue: 0.8941176471, alpha: 1)
        deleteAction.image = theImage
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

//MARK: UICollectionview Delegate & Datasource Methods
extension MatchByBothViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objMatchData.count != 0 ? self.objMatchData.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : MatchCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.MatchCollectionViewCell, for: indexPath) as! MatchCollectionViewCell
        let data = self.objMatchData[indexPath.row]
        cell.lblName.text = data.vProfileName
        let url = URL(string:"\(data.vProfileImage!)")
        cell.userImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_rect"))
        if UserDataModel.currentUser?.tiIsSubscribed == 0 {
            cell.userImgView.blurBackground()
            cell.btnUnMatch.alpha = 0.0
            cell.btnChat.alpha = 0.0
        } else {
            cell.btnUnMatch.alpha = 1.0
            cell.btnChat.alpha = 1.0
        }
        
        cell.clickOnChat = {
            let obj = GeekMeets_StoryBoard.Chat.instantiateViewController(withIdentifier: GeekMeets_ViewController.OneToOneChatScreen) as! OneToOneChatVC
            
            if self.arrFriends.count == 0 {
                obj.objFriend?.jID = UserDataModel.currentUser?.vXmppUser ?? ""
                obj._userIDForRequestSend = data.vOtherUserXmpp
                obj.userName = data.vProfileName
                obj.imageString = data.vProfileImage
            } else {
                let arr = self.arrFriends.filter({$0.jID.split("@").first! == data.vOtherUserXmpp})
                if arr.count != 0 {
                    obj.objFriend = arr[0]
                } else {
                    obj.objFriend?.jID = UserDataModel.currentUser?.vXmppUser ?? ""
                    obj._userIDForRequestSend = data.vOtherUserXmpp
                    obj.userName = data.vProfileName
                    obj.imageString = data.vProfileImage
                }
            }
            obj.modalPresentationStyle = .fullScreen
            self.parentNavigationController?.pushViewController(obj, animated: true)
        }
        
        cell.clickOnUnMatchButton = {
            self.otherXmppID = self.objMatchData[indexPath.row].vOtherUserXmpp!
            self.customAlertView = CustomAlertView.initAlertView(title: kUnMatchTitleStr, message: kUnMatchStr, btnRightStr: kUnMatchBtnStr, btnCancelStr: kTitleCancel, btnCenter: "", isSingleButton: false)
            self.customAlertView.delegate = self
            self.customAlertView.frame = ScreenSize.frame
            AppDelObj.window?.addSubview(self.customAlertView)
        }
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ScreenSize.width/2 - 12
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if UserDataModel.currentUser?.tiIsSubscribed == 0 {
            self.presentSubVC()
        } else {
            let obj = GeekMeets_StoryBoard.Chat.instantiateViewController(withIdentifier: GeekMeets_ViewController.OneToOneChatScreen) as! OneToOneChatVC
            let data = self.objMatchData[indexPath.row]
            if self.arrFriends.count == 0 {
                obj.objFriend?.jID = UserDataModel.currentUser?.vXmppUser ?? ""
                obj._userIDForRequestSend = data.vOtherUserXmpp
                obj.userName = data.vProfileName
                obj.imageString = data.vProfileImage
            } else {
                let arr = self.arrFriends.filter({$0.jID.split("@").first! == data.vOtherUserXmpp})
                if arr.count != 0 {
                    obj.objFriend = arr[0]
                } else {
                    obj.objFriend?.jID = UserDataModel.currentUser?.vXmppUser ?? ""
                    obj._userIDForRequestSend = data.vOtherUserXmpp
                    obj.userName = data.vProfileName
                    obj.imageString = data.vProfileImage
                }
            }
            obj.modalPresentationStyle = .fullScreen
            self.parentNavigationController?.pushViewController(obj, animated: true)
        }
    }
}

//MARK: AlertView Delegate Methods
extension MatchByBothViewController : AlertViewDelegate {
    func OkButtonAction(title : String) {
        customAlertView.alpha = 0.0
         self.presenter?.callUnMatchUserAPI(iProfileId: "\(self.otherXmppID!)")
    }
    func cancelButtonAction() {
        self.otherXmppID = ""
        customAlertView.alpha = 0.0
    }
}