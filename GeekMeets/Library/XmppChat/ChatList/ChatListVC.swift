//
//  ChatListVC.swift
//  xmppchat
//
//  Created by SOTSYS255 on 06/01/20.
//  Copyright © 2020 SOTSYS255. All rights reserved.
//

import UIKit
import SDWebImage
import Reachability

class ChatListVC: UIViewController {

    @IBOutlet weak var TblList: UITableView!
    @IBOutlet weak var txtSearchField: UITextField!
    @IBOutlet weak var lblNoUser: UILabel!
    
    var isfromSideMenu : Bool = false
    
    var arrAllFriends:[Model_ChatFriendList] = [Model_ChatFriendList]()
    var arrFriends:[Model_ChatFriendList] = [Model_ChatFriendList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNoUser.alpha = 0.0
//        //1
//        self.navigationItem.title = "Message"
//
//        //2
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(NewChatDialog))
//        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Logout", style: .done, target: self, action: #selector(logout))
        //3
        self.setupTableView()
        
        //4
        self.setupXmppCallBackAndNotificationMethods()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateAndSortFriendList()
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
        TblList.delegate = self
        TblList.dataSource = self
        TblList.tableFooterView = UIView.init(frame: .zero)
        TblList.estimatedRowHeight = 44.0
        TblList.rowHeight = UITableView.automaticDimension
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
//        DispatchQueue.main.async {
//            if self.arrFriends.count != 0 {
//                self.lblNoUser.alpha = 0.0
//                self.TblList.alpha = 1.0
//                self.TblList.reloadData()
//            } else {
//                self.lblNoUser.alpha = 1.0
//                self.TblList.alpha = 0.0
//            }
//        }
    }
    
    func updateNoDataLabel(){
        if self.arrFriends.count != 0 {
            self.lblNoUser.alpha = 0.0
            self.TblList.alpha = 1.0
            self.TblList.reloadData()
        } else {
            self.lblNoUser.alpha = 1.0
            self.TblList.alpha = 0.0
        }
    }
    
    @objc func NewChatDialog()  {
        
        let alertController = UIAlertController(title: "Enter user id", message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter user id"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Canelled")
        }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            let _id = alertController.textFields?.first?.text
            guard let strID = _id , strID.count > 0 else { return }
            self.startNewChat(With: strID)
        }
        // Add the actions, the order here does not matter
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        // Present to user
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func logout()  {
        //UserDefaults.standard.removeObject(forKey: kLoggedInUserDATA)
        //UserDefaults.standard.removeObject(forKey: kisUserLoggedIn)
        SOXmpp.manager.disconnect()
        //AppDelegate.shared.setLoginVCAsRoot()
    }
    
    private func startNewChat(With userID: String) {
        
        DispatchQueue.main.async {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "OneToOneChatVC") as! OneToOneChatVC
            obj._userIDForRequestSend = userID
            obj.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
}


extension ChatListVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFriends.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : Cell_ChatList = tableView.dequeueReusableCell(withIdentifier: "Cell_ChatList", for: indexPath) as! Cell_ChatList
        
        let objfriend = arrFriends[indexPath.row]
        
        print(arrFriends.count)
        print(objfriend)
        // user name
        if objfriend.vCard != nil {
            cell.lblUser.text = objfriend.vCard!.nickname ?? ""
            
            // user image
            let url = URL(string:"\(objfriend.vCard?.url ?? "")")
            print(url)
            cell.imgUser.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "user_placeholder"))
        } else {
            cell.lblUser.text = objfriend.name == "" ? objfriend.jID : objfriend.name
            
            
            // user image
            let url = URL(string:"\(objfriend.imagUrl)")
            print(url)
            cell.imgUser.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "user_placeholder"))
        }
        // user status or msg time
        // last msg
        cell.lblLastMsg.text = ""
        cell.lblStatus.text = ""
        
        if objfriend.objMessage != nil {
            
            let msgType = XMPP_Message_Type.init(rawValue: objfriend.objMessage!.msgType!)
            
            switch msgType {
            case .image,.video:
                cell.lblLastMsg.text = "Media message......."
            case .document:
                cell.lblLastMsg.text = "Document message......."
            default:
                cell.lblLastMsg.text = "\(objfriend.objMessage!.strMsg ?? "")"
            }
            
            cell.lblStatus.text = SOXmpp.manager.DurationStringFromTimestamp( objfriend.objMessage!.timestamp)
        }
        
        // count
        cell.lblCount.text = ""
        if let unreadCount = SOXmpp.manager.GetUnreadCound(of: arrFriends[indexPath.row].jID) , unreadCount > 0 {
            cell.lblCount.text = "\(unreadCount)"
            cell.lblCount.alpha = 1.0
        } else {
            cell.lblCount.alpha = 0.0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "OneToOneChatVC") as! OneToOneChatVC
        obj.objFriend = arrFriends[indexPath.row]
        obj.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(obj, animated: true)
            //self.present(obj, animated: true, completion: nil)
        }
    }
    
}


//MARK:- Textfield Delegate
extension ChatListVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtSearchField {
            textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
            self.arrFriends.removeAll()
            return true
        }
        return false
    }
    
    @objc func textFieldDidChange(textField : UITextField){
        
        if textField.text == "" {
            self.arrFriends = self.arrAllFriends
            print(self.arrFriends.count)
        } else {
            self.arrFriends.removeAll()
            for data in self.arrAllFriends {
                print(self.arrFriends.count)
            
                if (data.name.lowercased().contains(textField.text!)) {
                        if arrFriends.count == 0 {
                            self.arrFriends.append(data)
                        }
                        let fil_array = arrFriends.filter({$0.jID == data.jID})
                        if  fil_array.count == 0 {
                            self.arrFriends.append(data)
                        }
                    }
            }
        }
        self.TblList.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
