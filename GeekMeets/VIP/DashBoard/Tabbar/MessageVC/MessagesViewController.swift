//
//  MessagesViewController.swift
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

class MessageViewModel {
    let userImage: UIImage?
    var userName: String
    let msgTxt: String?
    let msgCount: String?
    let msgTime : String?
    
    init(userImage: UIImage? = nil, userName: String, msgTxt: String, msgCount: String, msgTime: String) {
        self.userImage = userImage
        self.userName = userName
        self.msgTxt = msgTxt
        self.msgCount = msgCount
        self.msgTime = msgTime
    }
}

class StoryViewModel {
    let userImage: UIImage?
    var userName: String
    
    init(userImage: UIImage? = nil, userName: String) {
        self.userImage = userImage
        self.userName = userName
    }
}

protocol MessagesProtocol: class {
    func getMatchResponse(response : MatchUser)
}

class MessagesViewController: UIViewController, MessagesProtocol {
    //var interactor : MessagesInteractorProtocol?
    var presenter : MessagesPresentationProtocol?
    
    // MARK: Object lifecycle
    
    @IBOutlet weak var tblMessageView: UITableView!
    @IBOutlet weak var StoryCollectionView: UICollectionView!
    @IBOutlet weak var lblNoUser: UILabel!
    
    @IBOutlet weak var lblNewMatches: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    
    var objStoryData : [StoryViewModel] = []
    var objMsgData : [MessageViewModel] = []
    
    var arrAllFriends:[Model_ChatFriendList] = [Model_ChatFriendList]()
    var arrFriends:[Model_ChatFriendList] = [Model_ChatFriendList]()
    var objMatchData : [SwipeUserFields] = []
    
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
        let interactor = MessagesInteractor()
        let presenter = MessagesPresenter()
        
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
        setStoryMsgViewData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerTableViewCell()
        self.updateAndSortFriendList()
    }
    
    func registerTableViewCell(){
        self.tblMessageView.register(UINib.init(nibName: Cells.MessageListCell, bundle: Bundle.main), forCellReuseIdentifier: Cells.MessageListCell)
        self.StoryCollectionView.register(UINib.init(nibName: Cells.StoryCollectionCell, bundle: Bundle.main), forCellWithReuseIdentifier: Cells.StoryCollectionCell)
        
        self.StoryCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let layout1 = CustomImageLayout()
        layout1.scrollDirection = .horizontal
        self.StoryCollectionView.collectionViewLayout = layout1
        
        self.presenter?.callMatchListAPI()
    }
    
    func setStoryMsgViewData(){
        self.objMsgData = [MessageViewModel(userImage: #imageLiteral(resourceName: "image_1"), userName: "Linda Parker", msgTxt: "Hi ! there whats up?", msgCount: "2", msgTime: "11:23 pm"),MessageViewModel(userImage: #imageLiteral(resourceName: "img_intro_1"), userName: "Sophia", msgTxt: "Hi ! there whats up?", msgCount: "2", msgTime: "11:23 pm"), MessageViewModel(userImage: #imageLiteral(resourceName: "image_1"), userName: "Sonia Mehta", msgTxt: "Hi ! there whats up?", msgCount: "2", msgTime: "11:23 pm"), MessageViewModel(userImage: #imageLiteral(resourceName: "image_1"), userName: "Andrew Jackson", msgTxt: "Hi ! there whats up?", msgCount: "2", msgTime: "11:23 pm"), MessageViewModel(userImage: #imageLiteral(resourceName: "image_1"), userName: "Vina Parker", msgTxt: "Hi ! there whats up?", msgCount: "2", msgTime: "11:23 pm"),MessageViewModel(userImage: #imageLiteral(resourceName: "img_intro_1"), userName: "Lily Ray", msgTxt: "Hi ! there whats up?", msgCount: "2", msgTime: "11:23 pm")]
        
        self.objStoryData = [StoryViewModel(userImage: #imageLiteral(resourceName: "image_1"), userName: "Linda Parker"), StoryViewModel(userImage: #imageLiteral(resourceName: "image_1"), userName: "Sophia"), StoryViewModel(userImage: #imageLiteral(resourceName: "image_1"), userName: "Sonia Mehta"), StoryViewModel(userImage: #imageLiteral(resourceName: "image_1"), userName: "Andrew Jackson"),StoryViewModel(userImage: #imageLiteral(resourceName: "image_1"), userName: "Lily Ray"), StoryViewModel(userImage: #imageLiteral(resourceName: "image_1"), userName: "Vina Parker")]
        
        //1
        self.setupTableView()
        
        //2
        self.setupXmppCallBackAndNotificationMethods()
    }
    
        private func setupXmppCallBackAndNotificationMethods() {
            
            //4
            self.arrFriends = SOXmpp.manager.arrFriendsList
            
            //5
            SOXmpp.manager.isChatListPresent = true
            
            //6
            SOXmpp.manager._bFriendListUpdateCallback = { [weak self] in
                DispatchQueue.main.async {
                    self?.arrFriends = SOXmpp.manager.arrFriendsList
                    self?.updateAndSortFriendList()
                }
            }
            
            //7
            // observer for user online or offline status
            NotificationCenter.default.addObserver(self, selector: #selector(xmppUserOnlineOfflineObserver), name: Notification_User_Online_Offline, object: nil)
            //8
            // observer for xmpp server connection
            NotificationCenter.default.addObserver(self, selector: #selector(xmppServerConnectionObserver(_:)), name: NotificationXmppServerConnection, object: nil)
        }
        
        
        @objc func xmppServerConnectionObserver(_ nofificat: Notification) {
            let alert = UIAlertController.init(title: "Error", message: "Connection issue",preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        @objc func xmppUserOnlineOfflineObserver(_ nofificat: Notification) {
            DispatchQueue.main.async {
                self.arrFriends = SOXmpp.manager.arrFriendsList
                self.updateAndSortFriendList()
            }
        }
        
        private func setupTableView() {
//            TblList.delegate = self
//            TblList.dataSource = self
            self.tblMessageView.tableFooterView = UIView.init(frame: .zero)
            self.tblMessageView.estimatedRowHeight = 44.0
            self.tblMessageView.rowHeight = UITableView.automaticDimension
        }
        
        
        private func updateAndSortFriendList() {
                
            for (i,friend) in self.arrFriends.enumerated() {
                
                guard let arr = SOXmpp.manager.xmpp_FetchArchiving(with: friend.xmppJID!) else {
                    print("no last message of friend \(friend.jID)")
                    continue
                }
                self.arrFriends[i].objMessage = arr.last
            }
            self.arrFriends = self.arrFriends.sorted(by: { (obj1, obj2) -> Bool in
                return obj1.objMessage != nil
            })
            self.arrFriends = self.arrFriends.sorted(by: { (obj1, obj2) -> Bool in
                if obj1.objMessage == nil || obj2.objMessage == nil {
                    return false
                } else {
                    return obj1.objMessage!.timestamp.compare(obj2.objMessage!.timestamp) == .orderedDescending
                }
            })
            
            self.arrAllFriends = self.arrFriends
            self.updateNoDataLabel()
        }
        
    func updateNoDataLabel(){
        if self.objMatchData.count != 0 {
            self.tblMessageView.alpha = 1.0
            self.btnSearch.alpha = 1.0
            self.lblNoUser.alpha = 0.0
        } else {
            self.tblMessageView.alpha = 0.0
            self.btnSearch.alpha = 0.0
            self.lblNoUser.alpha = 1.0
            self.lblNoUser.text = "No matches found"
            return
        }
        
        if self.arrFriends.count != 0  {
            self.lblNoUser.alpha = 0.0
            self.tblMessageView.reloadData()
        } else {
            self.lblNoUser.alpha = 1.0
            self.lblNoUser.text = "No messages found"
            self.tblMessageView.reloadData()
        }
        
        print(self.arrFriends)
    }
    
    @IBAction func btnSearchAction(_ sender: UIButton) {
        let searchVC = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.SearchScreen) as? SearchProfileViewController
        searchVC?.objMsgData = self.objMatchData
        searchVC?.isFromDiscover = false
        self.pushVC(searchVC!)
    }
}

extension MessagesViewController {
    func getMatchResponse(response : MatchUser) {
        if response.responseCode == 200 {
            print(response.responseData)
            self.objMatchData = response.responseData!
            self.lblNewMatches.text = "New Matches (\(self.objMatchData.count))"
            self.updateNoDataLabel()
            self.StoryCollectionView.reloadData()
            self.tblMessageView.reloadData()
        }
    }
}

//MARK: Tableview Delegate & Datasource Methods
extension MessagesViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFriends.count != 0 ? arrFriends.count : 0 // self.objMsgData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MessageListCell = tableView.dequeueReusableCell(withIdentifier: Cells.MessageListCell, for: indexPath) as! MessageListCell
        cell.btnChat.alpha = 0.0
        cell.selectionStyle = .none
        let objfriend = arrFriends[indexPath.row]
        
        print(arrFriends.count)
        print(objfriend)
        // user name
        if objfriend.vCard != nil {
            cell.userName.text = objfriend.vCard!.nickname ?? ""
            
            // user image
            let url = URL(string:"\(objfriend.vCard?.url ?? "")")
            print(url)
            cell.userImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_round"))
        } else {
            cell.userName.text = objfriend.name == "" ? objfriend.jID : objfriend.name
            
            
            // user image
            let url = URL(string:"\(objfriend.imagUrl)")
            print(url)
            cell.userImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_round"))
        }
        // user status or msg time
        // last msg
        cell.msgText.text = ""
        cell.msgTime.text = ""
        
        if objfriend.objMessage != nil {
            
            let msgType = XMPP_Message_Type.init(rawValue: objfriend.objMessage!.msgType!)
            
            switch msgType {
            case .image,.video, .gif:
                cell.msgText.text = "Media message......."
            case .document:
                cell.msgText.text = "Document message......."
            case .location:
                cell.msgText.text = "Location message......."
            default:
                cell.msgText.text = "\(objfriend.objMessage!.strMsg ?? "")"
            }
            
            cell.msgTime.text = SOXmpp.manager.DurationStringFromTimestamp(objfriend.objMessage!.timestamp)
        }
        
        // count
        cell.msgCount.text = ""
        if let unreadCount = SOXmpp.manager.GetUnreadCound(of: arrFriends[indexPath.row].jID) , unreadCount > 0 {
            cell.msgCount.text = "\(unreadCount)"
            cell.msgCount.alpha = 1.0
            let formattedString = NSMutableAttributedString()
            formattedString.bold(cell.msgText.text!)
            cell.msgText.attributedText = formattedString
            cell.msgText.textColor = .black
        } else {
            cell.msgCount.alpha = 0.0
            let formattedString = NSMutableAttributedString()
            formattedString.normal(cell.msgText.text!)
            cell.msgText.attributedText = formattedString
            cell.msgText.textColor = .lightGray
        }
        
        cell.clickOnChatBtn = {
            let obj = GeekMeets_StoryBoard.Chat.instantiateViewController(withIdentifier: GeekMeets_ViewController.OneToOneChatScreen) as! OneToOneChatVC
            obj.objFriend = self.arrFriends[indexPath.row]
            obj.modalPresentationStyle = .fullScreen
            self.pushVC(obj)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let obj = GeekMeets_StoryBoard.Chat.instantiateViewController(withIdentifier: GeekMeets_ViewController.OneToOneChatScreen) as! OneToOneChatVC
        obj.objFriend = self.arrFriends[indexPath.row]
        obj.modalPresentationStyle = .fullScreen
        self.pushVC(obj)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:UIView =  UIView()
        headerView.backgroundColor = .white
        
        let headerTitle = UILabel()
        headerTitle.frame = CGRect(x: 20, y: headerView.frame.origin.y + headerView.frame.height/2, w: ScreenSize.width - 60, h: 30)
        headerTitle.text = self.arrFriends.count != 0 ? "Chats" : ""
        headerTitle.textColor = .black
        headerTitle.font = UIFont(name: "Poppins-SemiBold", size: 14)
        headerView.addSubview(headerTitle)
        
        return headerView
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            if self.arrFriends.count != 0 {
                let jid = self.arrFriends[indexPath.row].jID
                SOXmpp.manager.xmpp_RemoveFriend(withJid: jid)
                DispatchQueue.main.async {
                    self.setupXmppCallBackAndNotificationMethods()
                    self.updateAndSortFriendList()
                    
                }
            }
            success(true)
        })
        let theImage: UIImage? = UIImage(named:"icn_trash")?.withRenderingMode(.alwaysOriginal)
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.8941176471, blue: 0.8941176471, alpha: 1)
        deleteAction.image = theImage
        
        let volAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
        })
        let volImage: UIImage? = UIImage(named:"icn_volume")?.withRenderingMode(.alwaysOriginal)
        volAction.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.937254902, blue: 0.9960784314, alpha: 1)
        volAction.image = volImage
        
        return UISwipeActionsConfiguration(actions: [deleteAction, volAction])
    }
}

//MARK: Collectionview Delegate & Datasource Methods
extension MessagesViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objMatchData.count != 0 ? self.objMatchData.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : StoryCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.StoryCollectionCell, for: indexPath) as! StoryCollectionCell
        let data = self.objMatchData[indexPath.row]
        let url = URL(string:"\(data.vProfileImage!)")
        cell.userImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_round"))
        cell.userName.text = data.vUserName
        
        cell.viewBorder.alpha = 0.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 130)
    }
}
