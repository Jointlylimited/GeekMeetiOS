//
//  OneToOneChatVC.swift
//  xmppchat
//
//  Created by SOTSYS255 on 08/01/20.
//  Copyright © 2020 SOTSYS255. All rights reserved.
//

import UIKit
import RSKGrowingTextView
import IQKeyboardManagerSwift
//import OpalImagePicker
import Photos
import XMPPFramework
import AVKit
import SDWebImage
import MobileCoreServices
import PDFKit
import Alamofire

let THUMBNAIL_URL = "https://www.w3schools.com/howto/img_nature.jpg"

private let InputBarViewHeighConst: CGFloat = 60.0

let refreshQueue = DispatchQueue.init(label: "com.xmppChat.refreshViewQueue")

class OneToOneChatVC: UIViewController ,UIDocumentPickerDelegate , ChatUploadTaskDelegate , UINavigationControllerDelegate {

    lazy var lblNavTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var inputTextView: RSKGrowingTextView!
    @IBOutlet weak var viewInputBar: UIView!
    @IBOutlet weak var constaint_viewInputBar_bottom: NSLayoutConstraint!
    @IBOutlet weak var constaint_viewInputBar_Hieght: NSLayoutConstraint!
    @IBOutlet weak var inputToolBar: UIToolbar!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblFriendName: UILabel!
    @IBOutlet weak var btnInfo:UIButton!
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var btnBlock: UIButton!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var imgOnline: UIImageView!
    
    var alertView: CustomOptionView!
    var customAlertView: CustomAlertView!
    var customImagePickerView: CustomPickImageView!
    
    var objFriend: Model_ChatFriendList?
    
    var _userIDForRequestSend: String?
    
    var arrChatMsg:[Model_ChatMessage] = [Model_ChatMessage]()
    var arrUploadingTask: [Model_ChatMessage] = [Model_ChatMessage]()
    var arrDifferentDate = [Date]()
    
    var isBlock : Int? = 0
    var imagePicker: UIImagePickerController!
    var userName : String?
    var imageString : String?
    var arrBlockUserList = BlockUserListModel()
    var mediaType: MediaType = .image
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1
        self.SetupXmppCallback()
        self.setupTableView()
        
        //2
        self.SetTitleAndStatus()
        
        //3
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        //4
        inputTextView.font = ChatFont.inputFont!
        inputTextView.growingTextViewDelegate = self
        inputTextView.delegate = self
        
        self.scrollToBottomAnimated(animated: false)
        self.callBlockUserListAPI()
    }
    
    private func setupTableView() {
        tblChat.delegate = self
        tblChat.dataSource = self
        tblChat.tableFooterView = UIView.init(frame: .zero)
        tblChat.estimatedRowHeight = 44.0
        tblChat.rowHeight = UITableView.automaticDimension
        tblChat.separatorStyle = .none
    }
    
     //MARK:- =============== NAVIGATION TITLE  ====================
    private func SetTitleAndStatus() {
        
        print(self.objFriend)
        
        if self.objFriend == nil {

            self.lblFriendName.text = self.userName ?? ""
            let url = URL(string: "\(self.imageString ?? "")")
            self.imgProfile!.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "user_profile"))
            self.lblStatus.alpha = 0.0
        } else {
            
            guard self.objFriend != nil else {
                return
            }
            self.lblStatus.alpha = 1.0
            if let _vcard = SOXmpp.manager.GetVcard(of: self.objFriend!.xmppJID!) {
                self.lblFriendName.text = "\(_vcard.nickname ?? self.objFriend!.name)"
                self.lblStatus.text = "\(SOXmpp.manager._collectionFriendsStatus[objFriend!.jID] ?? "")"
                self.imgOnline.alpha = self.lblStatus.text == "online" ? 1.0 : 0.0
                self.objFriend!.vCard = _vcard
                let url = URL(string: "\(_vcard.url ?? "")")
                self.imgProfile!.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "user_profile"))
            } else {
                SOXmpp.manager.xmppvCardTempModule.fetchvCardTemp(for: self.objFriend!.xmppJID!, ignoreStorage: true)
                self.lblFriendName.text = self.objFriend!.name != "" ?  "\(self.objFriend!.name)" : self.objFriend!.jID
                self.lblStatus.text = "\(SOXmpp.manager._collectionFriendsStatus[objFriend!.jID] ?? "")"
                self.imgOnline.alpha = self.lblStatus.text == "online" ? 1.0 : 0.0
                let url = URL(string: "\(self.objFriend?.imagUrl ?? "")")
                self.imgProfile!.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "user_profile"))
            }
        }
    //    lblNavTitle.sizeToFit()
      //  navigationItem.titleView = lblNavTitle
        
        if UserDefaults.standard.value(forKey: "BlockUserStatus") != nil {
            if UserDefaults.standard.value(forKey: "BlockUserStatus") as! Int == 1 {
                isBlock = 1
                self.btnBlock?.setTitle(kTitleUnBlock, for: .normal)
            } else {
                isBlock = 0
                self.btnBlock?.setTitle(kTitleBlock, for: .normal)
            }
        } else {
            self.btnBlock?.setTitle(kTitleBlock, for: .normal)
        }
    }

    private func SetTypingStatus() {
        
        guard self.objFriend != nil else {
            return
        }
        
        guard SOXmpp.manager._arrTypingUsersIDs.contains(self.objFriend!.jID) else  {
            return
        }
        if objFriend == nil {
            self.lblFriendName.text = self.userName
            let url = URL(string: "\(self.imageString ?? "")")
            self.imgProfile!.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "user_profile"))
            return
            
        }
        if let _vcard = SOXmpp.manager.GetVcard(of: self.objFriend!.xmppJID!) {
           // lblNavTitle.text = "\(_vcard.nickname ?? objFriend!.name)" // \n Typing....
            self.lblFriendName.text = "\(_vcard.nickname ?? objFriend!.name)"
            self.lblStatus.text = "typing..."
            self.imgOnline.alpha = 1.0
        } else {
          //  lblNavTitle.text = "\(self.objFriend!.name)" // \n Typing....
            self.lblFriendName.text = "\(self.objFriend!.name)"
            self.lblStatus.text = "typing..."
            self.imgOnline.alpha = 1.0
        }
     //   lblNavTitle.sizeToFit()
     //   navigationItem.titleView = lblNavTitle
    }
    
    //MARK:-=============== XMPP METHODS ====================
    private func SetupXmppCallback() {
        
//        // user status
//        SOXmpp.manager._bFriendStatusUpdateCallback = { [weak self] in
//            DispatchQueue.main.async {
//                self?.SetTitleAndStatus()
//            }
//        }
        // user typing status
        SOXmpp.manager._bChangeTypingStatus = {  [weak self] status in
            DispatchQueue.main.async {
                if status {
                    self?.SetTypingStatus()
                } else {
                    self?.SetTitleAndStatus()
                }
            }
        }
        // load messages
        SOXmpp.manager._bUpdateChatList = { [weak self] msgObj in
            DispatchQueue.main.async {
                self?.loadMessages(msgObj: msgObj)
            }
        }
        
        // observer for user online or offline status
        NotificationCenter.default.addObserver(self, selector: #selector(xmppUserOnlineOfflineObserver), name: Notification_User_Online_Offline, object: nil)
        
        // observer for refresh chat
        NotificationCenter.default.addObserver(self, selector: #selector(refreshChat), name: Notification_RefreshChat, object: nil)
        
        AWSS3Manager.shared.activeUploads.forEach { $0.delegate = self }
        
        self.loadMessages(msgObj: nil)
    }

    @objc func xmppUserOnlineOfflineObserver(_ nofificat: Notification) {
        DispatchQueue.main.async {
            self.SetTitleAndStatus()
        }
    }
    
    @objc func refreshChat() {
        self.loadMessages(msgObj: nil)
    }
    
    
    func loadMessages(msgObj: Model_ChatMessage?) {
        
        guard self.objFriend != nil else {
            return
        }
        
        // 1
        // Reset unread count value
        SOXmpp.manager.ResetUnreadCount(of: objFriend!.jID)
        
        // 2
        // Update message if already exists
        if msgObj  != nil {
            if let _index = self.arrChatMsg.firstIndex(where: { $0.messageId == msgObj!.messageId } ) {
                self.arrChatMsg[_index] = msgObj!
                let indexPath = IndexPath.init(row: _index, section: 0)
                self.reloadIndexPath(indexPath: indexPath)
                SOXmpp.manager.sendReadMessageStatus(objMsg: msgObj!)
            } else {
                
                let messageJid = msgObj!.isOutgoing ? msgObj!.ToJID : msgObj!.FromJID
                guard messageJid?.bareJID.bare == objFriend?.jID else {
                    return
                }
                self.arrChatMsg.append(msgObj!)
                //self.GetDifferentDate()
                let indexPath = IndexPath.init(row: self.arrChatMsg.count - 1 , section: 0)
                
                self.tblChat.beginUpdates()
                self.tblChat.insertRows(at: [indexPath], with: .none)
                self.tblChat.endUpdates()
                
                self.tblChat.reloadData()
                self.view.layoutIfNeeded()
                DispatchQueue.main.async {
                    let point = CGPoint(x: 0, y: self.tblChat.contentSize.height + self.tblChat.contentInset.bottom - self.tblChat.frame.height)
                    if point.y >= 0{
                        self.tblChat.setContentOffset(point, animated: true)
                    }
                    self.tblChat.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
                SOXmpp.manager.sendReadMessageStatus(objMsg: msgObj!)
            }
        } else if let arr = SOXmpp.manager.xmpp_FetchArchiving(with: self.objFriend!.xmppJID!) {  // 3
            self.arrChatMsg = arr
            //self.GetDifferentDate()
            self.tblChat.reloadData()
            
            self.arrChatMsg.forEach { (item) in
                SOXmpp.manager.sendReadMessageStatus(objMsg: item)
            }
            
            self.scrollToBottomAnimated(animated: true)
        } else {
            //self.GetDifferentDate()
            self.tblChat.reloadData()
            self.scrollToBottomAnimated(animated: true)
        }
        
        self.fetchThumbnailForVideo()
        
    }
    
    private func GetDifferentDate() {
        
//        for item in arrChatMsg {
//            if arrDifferentDate.count == 0 {
//                arrDifferentDate.append(item.timestamp)
//            } else if arrDifferentDate.last!.compare(item.timestamp) == .orderedDescending {
//                arrDifferentDate.append(item.timestamp)
//            } else {
//                continue
//            }
//        }
        print(arrDifferentDate.count)
    }

    let refreshQueue = DispatchQueue.init(label: "com.xmppChat.refreshViewQueue")
    
    private func reloadIndexPath(indexPath: IndexPath) {
        if let visibleIndexpath = self.tblChat.indexPathsForVisibleRows , visibleIndexpath.contains(indexPath) {
            DispatchQueue.main.async {
                self.tblChat.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
    
    
    private func fetchThumbnailForVideo() {
        
        for (_,item) in arrChatMsg.enumerated() {
            
            //1
            guard item.msgType! == XMPP_Message_Type.video.rawValue else {
                continue
            }
            //2
            guard item.thumbLocalUrl == nil else {
                continue
            }
            //3
            var _url: URL!
            if let path = item.localPath,  let url = URL.init(string: path) {
                _url = url
            } else if let url = URL.init(string: item.thumbUrl) {
                 _url = url
            }
            if _url == nil {
                continue
            }
            //4
            self.getThumbnailImageFromVideoUrl(url: _url) {[weak self] (img) in
                guard img != nil else { return }
                let _data = img?.jpegData(compressionQuality: 1.0)
                
                let _path = Chat_Utility.Save_Media_ToDocumentDirectory(mediaType: .image, data: _data!).0
                
                if _path != nil {
                    item.thumbLocalUrl = _path!.absoluteString
                    XMPP_MessageArchiving_Custom.UpdateMessage(obj: item)
                    self?.updateMessage(with: item)
                }
            }
        } // end of for loop
    }// end of function
    
    
    //MARK:-=============== Send Button ====================
    private func GetChatMsgObject() -> Model_ChatMessage {
        
        //let filterData = SOXmpp.manager.arrFriendsList.filter { $0 == self.objFriend }
        
        if self.objFriend == nil {
            let JID = SOXmpp.manager.GetJabberID(of: self._userIDForRequestSend!)
            SOXmpp.manager.xmpp_SendFriendRequest(to: JID)
            self.objFriend = Model_ChatFriendList.init()
            self.objFriend?.xmppJID = JID
            self.objFriend?.jID = JID.bare
        }
        
        let randomNumer = Int64.random(in: 0 ..< 100000)
        let timeStamp:String = Chat_Utility.timeStamp()
        
        let obj = Model_ChatMessage.init()
        obj.fromAppID = SOXmpp.manager.UserID
        obj.ToAppID = self.objFriend!.xmppJID?.user!
        obj.FromJID = SOXmpp.manager.xmppStream.myJID
        obj.ToJID = self.objFriend!.xmppJID
        obj.strMsg = ""
        obj.body = ""
        obj._ID = "\(timeStamp)\(randomNumer)"
        obj.messageId = "\(timeStamp)\(randomNumer)"
        obj.messageDate = timeStamp
        obj.timestamp = Date()
        obj.isOutgoing = true
        obj.thumbUrl = self.objFriend?.imagUrl ?? ""
        obj.url = ""
        obj.isUploading = false
        obj.imgProfileURL = self.objFriend?.imagUrl ?? ""
        
        return obj
    }
    
    @IBAction func btnSend() {
        //self.inputTextView.resignFirstResponder()
        
        if !checkConnection() {
//            AppSingleton.sharedInstance().showAlert(kInternetDown, okTitle: "OK")
            return
        }
        
        if self.isBlock == 0 {
            guard let txt = self.inputTextView.text else { return }
            
            if txt.trimmingCharacters(in: .whitespaces).isEmpty {
                self.inputTextView.resignFirstResponder()
                return
            }
            
            self.inputTextView.text = ""
            
            let obj = self.GetChatMsgObject()
            obj.strMsg = txt
            obj.body = txt
            obj.msgType = XMPP_Message_Type.text.rawValue
            
            let jsonStr = Chat_Utility.getOneToOneMsgBody(objChat: obj)
            print(jsonStr)
            
            DispatchQueue.main.async {
                XMPP_MessageArchiving_Custom.InsertMessage(obj: obj)
                
                self.arrChatMsg.append(obj)
                //self.GetDifferentDate()
                self.tblChat.reloadData()
                self.scrollToBottomAnimated(animated: true)
            }
            
            SOXmpp.manager.xmpp_SendMessage(bodyData: jsonStr, objMsg: obj)
        } else {
            self.showAlertView()
        }
    }
    
    deinit {
        print("deinit")
    }
    
    private func addMediaMessage(with data: Data , mediaType: XMPP_Message_Type, image : UIImage) {
        
        if let localPath = Chat_Utility.Save_Media_ToDocumentDirectory(mediaType: mediaType, data: data).0 {

            let obj = self.GetChatMsgObject()
            obj.msgType = mediaType.rawValue
            obj.localPath = localPath.absoluteString
            obj.isUploading = true
            
            let objUploadTask = ChatUploadTask.init(objChat: obj, localPath: localPath)
            objUploadTask.image = image
            objUploadTask.delegate = self

            AWSS3Manager.shared.activeUploads.append(objUploadTask)

            DispatchQueue.main.async {
                XMPP_MessageArchiving_Custom.InsertMessage(obj: obj)

                self.arrChatMsg.append(obj)
                self.tblChat.reloadData()

                self.fetchThumbnailForVideo()
                self.scrollToBottomAnimated(animated: true)
            }

//            if AWSS3Manager.shared.index == 0 {
//                self.sendImage(image: image)
                AWSS3Manager.shared.sequenceUpload()
//            }
        } else {
            print("============== ERROR While saving Media to directory")
        }
    }
    
    private func addMediaMessageTEST(mediaType: XMPP_Message_Type , phAssetUrl: URL, image : UIImage? = nil) {

        let obj = self.GetChatMsgObject()
        obj.msgType = mediaType.rawValue
        obj.localPath = phAssetUrl.absoluteString
        
        obj.isUploading = true

        let objUploadTask = ChatUploadTask.init(objChat: obj, localPath: phAssetUrl)
        objUploadTask.delegate = self
        objUploadTask.image = generateThumb(from: phAssetUrl) != nil ? generateThumb(from: phAssetUrl) : image
        AWSS3Manager.shared.activeUploads.append(objUploadTask)

        DispatchQueue.main.async {

            XMPP_MessageArchiving_Custom.InsertMessage(obj: obj)

            self.arrChatMsg.append(obj)
            self.tblChat.reloadData()
            self.scrollToBottomAnimated(animated: true)
        }
        AWSS3Manager.shared.sequenceUpload()
    }
    
//    @objc func retryBtnAction(_ sender: UIButton) {
//        let objChat = self.arrChatMsg[sender.tag]
//        objChat.isUploading = true
//        objChat.isError = false
//
//        if objChat.isOutgoing {
//
//            let lastPath = URL(fileURLWithPath: objChat.localPath!).lastPathComponent
//            let _url = Chat_Utility.documentsPath.appendingPathComponent(lastPath)
//
//            let objUploadTask = ChatUploadTask.init(objChat: objChat, localPath: _url)
//            objUploadTask.delegate = self
//
//            AWSS3Manager.shared.activeUploads.append(objUploadTask)
//
//            XMPP_MessageArchiving_Custom.UpdateMessage(obj: objChat)
//
//            if AWSS3Manager.shared.index == 0 {
//                AWSS3Manager.shared.sequenceUpload()
//            }
//
//            self.updateMessage(with: objChat)
//        }
//
//    }
    
    private func updateMessage(with objChatMsg: Model_ChatMessage) {
        if let _index = self.arrChatMsg.firstIndex(where: { $0.messageId == objChatMsg.messageId } ) {
            self.arrChatMsg[_index] = objChatMsg
            let indexPath = IndexPath.init(row: _index, section: 0)
            self.reloadIndexPath(indexPath: indexPath)
        }
    }
    //MARK:- ===================== UPLOAD TASK DELEGATE ==========================
    
    func progress(progress: Double, objChatMsg: Model_ChatMessage) {
        print("========== progress == \(progress)")
    }
    func UploadCompleted(CompletionData: Any?, error: Error?, objChatMsg: Model_ChatMessage) {
        print("========== UploadCompleted == \(CompletionData ?? "")")
        self.updateMessage(with: objChatMsg)
    }
    
    //MARK:- ===================== ATTACHMENT ==========================
    @IBAction func attachmentBtnAction(_ sender: UIButton) {
        
        if !checkConnection() {
            AppSingleton.sharedInstance().showAlert(NoInternetConnection, okTitle: "OK")
            return
        }
        
        if self.isBlock == 0 {
            self.view.endEditing(true)
//            self.openImagePickerActionSheet()
            self.openImagePickerView()
        } else {
            self.showAlertView()
        }
//        let alertController = UIAlertController(title: nil, message: "Choose", preferredStyle: .actionSheet)
//
//        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (alert: UIAlertAction!) -> Void in
//            Chat_Utility.checkCameraAccess(view: self) { [weak self] (_ status) in
//                guard let `self` = self else { return }
//                if status {
//                    DispatchQueue.main.async {
//                        self.openCamera()
//                    }
//                }
//            }
//        })
//
//        let imageAction = UIAlertAction(title: "Images/Videos", style: .default, handler: { (alert: UIAlertAction!) -> Void in
//            Chat_Utility.checkGalleryAccess(view: self) { [weak self] (_ status) in
//                guard let `self` = self else { return }
//                if status {
//                    DispatchQueue.main.async {
//                        self.openImagerPicker()
//                    }
//                }
//            }
//
//        })
//
//        let documentAction = UIAlertAction(title: "Document", style: .default, handler: { (alert: UIAlertAction!) -> Void in
//            self.openDocumentPicker()
//        })
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
//          //  Do something here upon cancellation.
//        })
//
//        alertController.addAction(cameraAction)
//        alertController.addAction(imageAction)
//        alertController.addAction(documentAction)
//        alertController.addAction(cancelAction)
//
//        if let popoverController = alertController.popoverPresentationController {
//            popoverController.sourceView = sender
//            popoverController.sourceRect = sender.bounds
//        }
//
//        DispatchQueue.main.async {
//            self.present(alertController, animated: true, completion: nil)
//        }
    }
    
    func openImagePickerView(){
        customImagePickerView = CustomPickImageView.initAlertView()
        customImagePickerView.delegate = self
        customImagePickerView.frame = self.view.frame
        self.view.addSubview(customImagePickerView)
    }
    
    func openImagePickerActionSheet() {
           let camera = "Camera"
           let photoGallery = "Gallery"
            let video = "Video"
           let cancel = "Cancel"
           UIAlertController.showAlertWith(title: nil, message: nil, style: .actionSheet, buttons: [camera,photoGallery,video,cancel], controller: self) { (action) in
               if action == camera {
                   self.openCamera()
               } else if action == photoGallery {
                   self.openLibrary()
               } else if action == video {
                self.openVideo()
            }
           }
       }
    
    func openCamera()
    {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.mediaType = .image
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
                        self.mediaType = .image
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }
                } else {
    //                AppSingleton.sharedInstance().showAlert(kPhotosAccessMsg, okTitle: "OK")
                }
            }
        }
    
    func openVideo(){
        photoLibraryAccess { [weak self] (status, isGrant) in
            guard let `self` = self else {return}
            if isGrant {
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                    self.imagePicker = UIImagePickerController()
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
                    self.imagePicker.videoMaximumDuration = 30
                    self.mediaType = .video
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            } else {
                //                AppSingleton.sharedInstance().showAlert(kPhotosAccessMsg, okTitle: "OK")
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func openDocumentPicker() {
        let types: [String] = [kUTTypePDF as String]
        let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .fullScreen
        if #available(iOS 11.0, *) {
            documentPicker.allowsMultipleSelection = false
        }
        DispatchQueue.main.async {
            self.present(documentPicker, animated: true, completion: nil)
        }
    }
    
    let PHmanager = PHImageManager.default()

    func uploadImagesAndSend(assests: [PHAsset])  {

//        if indexOfAsset >= arrSelectedAssets.count {
//            indexOfAsset = 0
//            arrSelectedAssets.removeAll()
//            return
//        }
//
//        //1
//        let asset = arrSelectedAssets[indexOfAsset]
        
        //2
        
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        
        
        for asset in assests {
            
            if asset.mediaType == .image {
                    PHmanager.requestImageData(for: asset, options: options) { _data, _, _, _ in
                        
                            if let data = _data {
//                                self.addMediaMessage(with: data, mediaType: .image)
                            } else {
                                print("============== ERROR fetchin  Media Data ")
                            }
                    } // end of request call back
                        
//            } else if asset.mediaType == .video {
//
//                PHmanager.requestAVAsset(forVideo: asset, options: nil) { (avAsset, audioMix, info) in
//
//                    if let _mediaData = try? Data.init(contentsOf: (avAsset as! AVURLAsset).url) {
//                        let bcf = ByteCountFormatter()
//                        //bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
//                        bcf.countStyle = .file
//                        let string = bcf.string(fromByteCount: Int64(_mediaData.count))
//                        let fileSize = Double(string) ?? 0.0
//                        print("formatted result: \(string)")
//                        if fileSize > MAX_VIDEO_SIZE {
//                            print(" ======== Video upload ERROR===== VIDEO SIZE BIG")
//                        } else {
//                            self.addMediaMessage(with: _mediaData, mediaType: .video)
//                        }
//                    } else {
//                        print("============== ERROR fetchin  Media Data ")
//                    }
//                }// end of request
            } // end of else
        }
    }
    
    
    
    let ThumbnailQueue = DispatchQueue.init(label: "com.xmppDemo.ThumbnailQueue")
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        ThumbnailQueue.async {
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 1, timescale: 60) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
//        DispatchQueue.global(qos: .background).async {
//            let asset = AVAsset(url: url) //2
//            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
//            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
//            let thumnailTime = CMTimeMake(value: 1, timescale: 60) //5
//            do {
//                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
//                let thumbImage = UIImage(cgImage: cgThumbImage) //7
//                DispatchQueue.main.async { //8
//                    completion(thumbImage) //9
//                }
//            } catch {
//                print(error.localizedDescription) //10
//                DispatchQueue.main.async {
//                    completion(nil) //11
//                }
//            }
//        }
    }
    //MARK:- ===================== Document Picker  DELEGATE ==========================
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        DispatchQueue.main.async {
            controller.dismiss(animated: true, completion: nil)
            let _data = try? Data.init(contentsOf: url)
            if _data != nil {
//                self.addMediaMessage(with: _data!, mediaType: .document)
            } else {
                print("============== ERROR PickDocument Data")
            }
        }
    }
    //MARK:-=============== keyboard METHODS ====================
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardScreenFrame = keyboardRect.height
            if #available(iOS 11.0, *) {
                keyboardScreenFrame = keyboardScreenFrame - view.safeAreaInsets.bottom
            }
            let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double)
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: duration!, animations: {
                self.constaint_viewInputBar_bottom.constant = keyboardScreenFrame
                self.scrollToBottomAnimated(animated: true)
                self.view.layoutIfNeeded()
            });
        }
    }
    @objc func keyboardDidHide(_ notification: NSNotification) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
            self.constaint_viewInputBar_bottom.constant = 0.0
            self.scrollToBottomAnimated(animated: true)
            self.view.layoutIfNeeded()
        });
    }
    
    func scrollToBottomAnimated(animated: Bool) {
        if arrChatMsg.count == 0 {
            return
        }
        let lastCell = IndexPath.init(item: (arrChatMsg.count - 1), section: 0)
        //let bottomOffset = CGPoint(x: 0, y: self.tblChat.contentSize.height - self.tblChat.bounds.size.height)
        //self.tblChat.setContentOffset(bottomOffset, animated: animated)
        //self.tblChat.scrollToRow(at: lastCell, at: .bottom, animated: animated)
        self.scrollToIndexPath(indexPath: lastCell, animated: animated)
    }
    
    func scrollToIndexPath(indexPath: IndexPath ,animated: Bool) {
        self.view.layoutIfNeeded()
        if self.tblChat.numberOfRows(inSection: 0) <= indexPath.row {
            return
        }
        if self.tblChat.numberOfRows(inSection: 0) == 0 {
            return
        }
        let ContentHeight = self.tblChat.contentSize.height
        let isContentTooSmall = ContentHeight < self.tblChat.bounds.height
        
        if isContentTooSmall {
            print("isContentTooSmall to scroll")
            return
        }
        
        DispatchQueue.main.async {
            self.tblChat.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
        //self.tblChat.scrollRectToVisible(cell.frame, animated: animated)
    }
    
        func showOptionAlertView() {
            alertView = CustomOptionView.initAlertView(isblock : self.isBlock!)
            alertView.delegate = self
            alertView.frame = self.view.frame
            self.view.addSubview(alertView)
        }
    
    //MARK:- =====================ACTIONS==========================
    
    @IBAction func profileBtnAction(_ sender: UIButton) {
        self.showOptionAlertView()
    }
    
    @IBAction func buttonClickBack(_ sender: Any) {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init("NF_REFRESH_USER_CHAT"), object: nil)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.popVC()
    }
    
    @IBAction func btnBlockPressed(_ sender: Any) {
        self.showAlertView()
    }
    
    func showAlertView(){
        self.viewPopUp!.alpha = 0.0
        let dialogMessage = UIAlertController(title: appName, message: isBlock == 1 ? kUnblockStr : kBlockStr, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: isBlock == 1 ? kTitleUnBlock : kTitleBlock, style: .destructive, handler: { (action) -> Void in
            let userId = self.objFriend?.jID != nil ? (self.objFriend?.jID.split("@").first ?? "") : self._userIDForRequestSend ?? ""
            if(self.isBlock == 1){
                self.callBlock(userId: userId, tiStatus: 0)
            }else{
                self.callBlock(userId: userId, tiStatus: 1)
            }
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: kTitleCancel, style: .cancel) { (action) -> Void in
            
        }
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    @IBAction func btnReportUserPressed(_ sender: Any) {
        self.viewPopUp!.alpha = 0.0
         let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.ReportScreen) as! ReportViewController
            let techID = self.objFriend != nil ? self.objFriend?.jID.split("_").first!.components(separatedBy: CharacterSet.decimalDigits.inverted).last : _userIDForRequestSend?.split("_").first!.components(separatedBy: CharacterSet.decimalDigits.inverted).last
        controller.ReportFor = techID!
        self.pushVC(controller)

    }
    @IBAction func btnClearChatPressed(_ sender: Any) {
        self.viewPopUp!.alpha = 0.0
        let alertController = UIAlertController(title: appName, message: "Are you sure you want to clear this chat?", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Yes", style: .default) { (String) in
            self.deleteUser()
        }
        alertController.addAction(OKAction)
        
        let cancelAction = UIAlertAction(title: "No", style: .default) { (String) in
            
        }
        alertController.addAction(cancelAction)
        
        AppDelObj.window!.rootViewController!.present(alertController, animated: true, completion: nil)
    }
}

extension OneToOneChatVC : CustomOptionViewDelegate {
    func OptionButtonAction(index : Int){
        print(index)
        self.alertView.removeFromSuperview()
        if index == 0 {
            customAlertView = CustomAlertView.initAlertView(title: kUnMatchTitleStr, message: kUnMatchDesStr, btnRightStr: kUnMatchBtnStr, btnCancelStr: kTitleCancel, btnCenter: "", isSingleButton: false)
        } else if index == 1 {
            customAlertView = CustomAlertView.initAlertView(title: kClearTitleStr, message: kClearChatStr, btnRightStr: kClearBtnStr, btnCancelStr: kTitleCancel, btnCenter: "", isSingleButton: false)
        } else if index == 2 {
            customAlertView = CustomAlertView.initAlertView(title: kDelTitleStr, message: kDelStr, btnRightStr: kDelTitleStr, btnCancelStr: kTitleCancel, btnCenter: "", isSingleButton: false)
        } else if index == 3 {
            customAlertView = CustomAlertView.initAlertView(title: isBlock == 1 ? kUnblockStr : kBlockStr, message: isBlock == 1 ? kUnblockDesStr : kBlockDesStr, btnRightStr: isBlock == 1 ? kTitleUnBlock : kTitleBlock, btnCancelStr: kTitleCancel, btnCenter: "", isSingleButton: false)
        } else if index == 4 {
            let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.ReportScreen) as! ReportViewController
            let techID = self.objFriend != nil ? self.objFriend?.jID.split("_").first!.components(separatedBy: CharacterSet.decimalDigits.inverted).last : _userIDForRequestSend?.split("_").first!.components(separatedBy: CharacterSet.decimalDigits.inverted).last
            controller.ReportFor = techID!
            controller.tiReportType = 1
            controller.modalTransitionStyle = .crossDissolve
            controller.modalPresentationStyle = .overCurrentContext
            self.presentVC(controller)
            return
        } else {
            
        }
        customAlertView.delegate = self
        customAlertView.frame = self.view.frame
        AppDelObj.window?.addSubview(customAlertView)
        
    }
}

//MARK: PickImageViewDelegate Delegate Methods
extension OneToOneChatVC : PickImageViewDelegate {
    func CameraButtonAction(){
        self.customImagePickerView.removeFromSuperview()
        openImagePickerActionSheet()
    }
    func GifButtonAction(){
        self.customImagePickerView.removeFromSuperview()
        photoLibraryAccess { [weak self] (status, isGrant) in
            guard let `self` = self else {return}
            if isGrant {
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                    self.imagePicker = UIImagePickerController()
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
                    self.imagePicker.allowsEditing = false
                    self.mediaType = .gif
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            } else {
                //                AppSingleton.sharedInstance().showAlert(kPhotosAccessMsg, okTitle: "OK")
            }
        }
    }
    func LocationButtonAction(){
        self.customImagePickerView.removeFromSuperview()
        self.getUserCurrentLocation()
    }
}

//MARK: AlertView Delegate Methods
extension OneToOneChatVC : AlertViewDelegate {
    func OkButtonAction(title : String) {
        customAlertView.alpha = 0.0
        if title == kUnMatchBtnStr {
            let userId = self.objFriend?.jID != nil ? (self.objFriend?.jID.split("@").first ?? "") : self._userIDForRequestSend ?? ""
            self.callUnMatchUserAPI(iProfileId: userId)
        } else if title == kClearBtnStr {
            self.deleteUser()
        } else if title == kDelTitleStr {
            self.deleteUser()
        } else if title == kTitleBlock || title == kTitleUnBlock {
            let userId = self.objFriend?.jID != nil ? (self.objFriend?.jID.split("@").first ?? "") : self._userIDForRequestSend ?? ""
            if(self.isBlock == 1){
                self.callBlock(userId: userId, tiStatus: 0)
            }else{
                self.callBlock(userId: userId, tiStatus: 1)
            }
        } else {
            
        }
    }
    
    func cancelButtonAction() {
        customAlertView.alpha = 0.0
    }
}

extension OneToOneChatVC {
    
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
                 let obj = self.GetChatMsgObject()
                 obj.msgType = XMPP_Message_Type.location.rawValue
                obj.strMsg = "\(String(Float((currLocation?.coordinate.latitude)!))),\(String(Float((currLocation?.coordinate.longitude)!)))"
                 obj.body = "\(String(Float((currLocation?.coordinate.latitude)!))),\(String(Float((currLocation?.coordinate.longitude)!)))"
                 let jsonStr = Chat_Utility.getOneToOneMsgBody(objChat: obj)
                 print(jsonStr)
                 
                 DispatchQueue.main.async {
                     XMPP_MessageArchiving_Custom.InsertMessage(obj: obj)
                     
                     self.arrChatMsg.append(obj)
                     //self.GetDifferentDate()
                     self.tblChat.reloadData()
                     self.scrollToBottomAnimated(animated: true)
                 }
                 
                 SOXmpp.manager.xmpp_SendMessage(bodyData: jsonStr, objMsg: obj)
               }
           }
       }
    
    func checkConnection()->Bool{
            
        if !NetworkReachabilityManager.init()!.isReachable{
            AppSingleton.sharedInstance().showAlert(NoInternetConnection, okTitle: "OK")
            return false
        }
        if !SOXmpp.manager.xmppStream.isConnected {
            AppSingleton.sharedInstance().showAlert("msgServerConnection", okTitle: "OK")
            return false
        }
        return true
    }
    
    func callUnMatchUserAPI(iProfileId : String){
        LoaderView.sharedInstance.showLoader()
        UserAPI.unMatch(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization, vXmppUser: iProfileId) { (response, error) in
            
            LoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.getUnMatchResponse(response: response!)
            } else if response?.responseCode == 400 {
                self.getUnMatchResponse(response: response!)
            }  else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.getUnMatchResponse(response: response!)
                }
            }
        }
    }
    
    func getUnMatchResponse(response : CommonResponse){
        if response.responseCode == 200 {
            self.deleteUser()
           self.navigationController?.popViewController(animated: true)
        }
    }
    func callBlock(userId:String,tiStatus:Int){
        DispatchQueue.main.async {
            LoaderView.sharedInstance.showLoader()
        }
        
        UserAPI.blockUsers(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization, vXmppUser: userId, tiIsBlocked: "\(tiStatus)") { (response, error) in
            DispatchQueue.main.async {
                LoaderView.sharedInstance.hideLoader()
            }
            if(error == nil){
                self.getBlockUserResponse(objSuccessResponse: response!)
            }else{
                AppSingleton.sharedInstance().showAlert((error?.localizedDescription)!, okTitle: "OK")
            }
        }
    }
    
    func deleteUser(){
        let JID = self.objFriend?.jID != nil ? (self.objFriend?.jID ?? "") : self._userIDForRequestSend ?? ""
        if JID != "" {
            SOXmpp.manager.xmpp_RemoveArchiving(withID: XMPPJID(string: JID)!)
            self.navigationController?.popViewController(animated: true)
        } else {
            AppSingleton.sharedInstance().showAlert("", okTitle: "OK")
        }
    }
    
    func getBlockUserResponse(objSuccessResponse: CommonResponse) {
        if(objSuccessResponse.responseCode == 200){
            
            let JID = self.objFriend?.jID != nil ? (self.objFriend?.jID.split("@").first ?? "") : self._userIDForRequestSend ?? ""
            print(JID)
            if(isBlock == 1){
                isBlock = 0
                self.btnBlock?.setTitle(kTitleBlock, for: .normal)
                SOXmpp.manager.xmpp_UnBlockUserWithJid(userId: JID)
            }else{
                isBlock = 1
                SOXmpp.manager.xmpp_BlockUser(withJid : JID)
                self.btnBlock?.setTitle(kTitleUnBlock, for: .normal)
            }
            UserDefaults.standard.set(isBlock, forKey: "BlockUserStatus")
            AppSingleton.sharedInstance().showAlert(objSuccessResponse.responseMessage!, okTitle: "OK")
        }else if(objSuccessResponse.responseCode == 203){
            AppSingleton.sharedInstance().logout()
        }else{
            AppSingleton.sharedInstance().showAlert(objSuccessResponse.responseMessage!, okTitle: "OK")
        }
    }
    
    func callBlockUserListAPI() {
        LoaderView.sharedInstance.showLoader()
        UserAPI.blockList(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization) { (response, error) in
            
            LoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.getBlockUserListResponse(response : response!)
            } else if response?.responseCode == 203 {
                AppSingleton.sharedInstance().logout()
            } else {
                if error != nil {
//                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.getBlockUserListResponse(response : response!)
                }
            }
        }
    }
        
         func getBlockUserListResponse(response : BlockUser) {
            if response.responseCode == 200 {
                self.arrBlockUserList.objUserList = response.responseData
                let userId = self.objFriend?.jID != nil ? (self.objFriend?.jID.split("@").first ?? "") : self._userIDForRequestSend ?? ""
                let arrBlockUser = self.arrBlockUserList.objUserList.filter { $0.iUserId! == userId }
                if arrBlockUser != nil && arrBlockUser.count != 0 {
                    isBlock = 1
                    SOXmpp.manager.xmpp_BlockUser(withJid : userId)
                    self.btnBlock?.setTitle(kTitleUnBlock, for: .normal)
                    UserDefaults.standard.set(isBlock, forKey: "BlockUserStatus")
                }
                
            } else {
    //            let msg = response.responseMessage ?? kSomethingWentWrong
    //            _ = ValidationToast.showStatusMessage(message: msg,withToastType: ToastType.error)
            }
        }
}

//MARK:- ================== UITableViewDelegate  UITableViewDataSource ===================
extension OneToOneChatVC: UITableViewDelegate,UITableViewDataSource ,UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrChatMsg.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let chatMsg = self.arrChatMsg[indexPath.row]
        
        if chatMsg.isOutgoing {
            
            //UserProfileImage
            let imageStr = UserDataModel.currentUser?.vProfileImage
            let urlStr = "\(imageStr ?? "")"
            let url = URL(string: "\(urlStr)")
            
            switch XMPP_Message_Type.init(rawValue: chatMsg.msgType!) {
                
            case .text:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: ChatTextCell.reuseID_Outgoing, for: indexPath) as! ChatTextCell
                //                cell.imgAvatarView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "user_profile"))
                cell.delegate = self
                cell.ConfigureCell(with: chatMsg)
                
                return cell
                
            case .image ,.video, .gif:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: ChatMediaCell.reuseID_Outgoing, for: indexPath) as! ChatMediaCell
                cell.delegate = self
                //                cell.imgAvatarView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "user_profile"))
                cell.ConfigureCell(with: chatMsg)
                
                return cell
                
                
            case .document:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: ChatDocumentCell.reuserID_Incoming, for: indexPath) as! ChatDocumentCell
                cell.delegate = self
                cell.ConfigureCell(with: chatMsg)
                
                return cell
            case .location:
                let cell = tableView.dequeueReusableCell(withIdentifier: ChatLocationCell.reuserID_Outgoing, for: indexPath) as! ChatLocationCell
                cell.delegate = self
                cell.ConfigureCell(with: chatMsg)
                
                return cell
            default:
                return UITableViewCell()
            }
            
        } else {
            
            switch XMPP_Message_Type.init(rawValue: chatMsg.msgType!) {
                
            case .text:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: ChatTextCell.reuseID_Incoming, for: indexPath) as! ChatTextCell
//                cell.imgAvatarView.image = self.imgProfile.image
                cell.ConfigureCell(with: chatMsg)
                
                return cell
                
            case .image,.video, .gif:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: ChatMediaCell.reuseID_Incoming, for: indexPath) as! ChatMediaCell
//                 cell.imgAvatarView.image = self.imgProfile.image
                cell.ConfigureCell(with: chatMsg)
                
                return cell
                
           
            case .document:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: ChatDocumentCell.reuserID_Incoming, for: indexPath) as! ChatDocumentCell
                cell.ConfigureCell(with: chatMsg)
                
                return cell
            case .location:
                let cell = tableView.dequeueReusableCell(withIdentifier: ChatLocationCell.reuserID_Incoming, for: indexPath) as! ChatLocationCell
                cell.ConfigureCell(with: chatMsg)
                
                return cell
            default:
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let msgType = XMPP_Message_Type.init(rawValue: arrChatMsg[indexPath.row].msgType!)
        
        switch msgType {
        case .video:
            var _url: URL?
            if arrChatMsg[indexPath.row].url.count > 0  {
                let localPath = URL.init(string: arrChatMsg[indexPath.row].url)
                _url = URL(string:"\(fileUploadURL)\(localPath!)")
                print(_url)
            }
            guard let url = _url else { return }
            let player = AVPlayer.init(url: url)
            let controller = AVPlayerViewController.init()
            controller.player = player
            
            DispatchQueue.main.async {
                self.present(controller, animated: true) {
                    controller.player?.play()
                }
            }
            break
            
        case .image:
            LoaderView.sharedInstance.showLoader()
            let objVC = self.storyboard?.instantiateViewController(withIdentifier: "FullScreenImageViewController") as! FullScreenImageViewController
            objVC.chatMsg = arrChatMsg[indexPath.row]
            objVC.modalTransitionStyle = .crossDissolve
            objVC.modalPresentationStyle = .overCurrentContext
            DispatchQueue.main.async {
                self.present(objVC, animated: true, completion: nil)
            }
            break
            
        case .gif:
            LoaderView.sharedInstance.showLoader()
            let objVC = self.storyboard?.instantiateViewController(withIdentifier: "FullScreenImageViewController") as! FullScreenImageViewController
            objVC.chatMsg = arrChatMsg[indexPath.row]
            objVC.modalTransitionStyle = .crossDissolve
            objVC.modalPresentationStyle = .overCurrentContext
            
            DispatchQueue.main.async {
                self.present(objVC, animated: true, completion: nil)
            }
            break
        case .document:
            //            let pdfViewController = PDFViewController()
            //            let urlRequest = NSURLRequest(url: URL.init(string: arrChatMsg[indexPath.row].url)!)
            //            pdfViewController.webView.loadRequest(urlRequest as URLRequest)
            //            let navigationController = UINavigationController(rootViewController: pdfViewController)
            //            pdfViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissController(_:)))
            //            // Present the document.
            //            pdfViewController.navigationItem.title = "PDF Viewer"
            //            navigationController.modalPresentationStyle = .fullScreen
            //            DispatchQueue.main.async {
            //                self.present(navigationController, animated: true, completion: nil)
            //            }
            break
            
        case .location:
            let objVC = self.storyboard?.instantiateViewController(withIdentifier: "FullScreenMapViewController") as! FullScreenMapViewController
            objVC.chatMsg = arrChatMsg[indexPath.row]
            objVC.modalTransitionStyle = .crossDissolve
            objVC.modalPresentationStyle = .overCurrentContext
            DispatchQueue.main.async {
                self.present(objVC, animated: true, completion: nil)
            }
            break
        default:
            break
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let msgType = XMPP_Message_Type.init(rawValue: self.arrChatMsg[indexPath.row].msgType!)!
//        if msgType == .image || msgType == .video {
//            return 150
//        }
        return UITableView.automaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //self.inputTextView.resignFirstResponder()
        //print(scrollView.contentOffset.y)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print(scrollView.contentOffset.y)
    }
    
    @objc private func dismissController(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
//    private func getViewAndHeighForHeader(indexPath: IndexPath) ->(UIView?,CGFloat) {
//        
//    }
}
//MARK:-===================== Protocol ChatMessage Retry ==========
extension OneToOneChatVC: ProtocolChatMessageRetry {
    func UnsendBtnPressed(for objChat: Model_ChatMessage) {
        if objChat.isOutgoing {
            SOXmpp.manager.xmpp_RemoveSingleObject(withMessageId: objChat.messageId, withToUserId: self.objFriend!.jID, obj: objChat)
            self.loadMessages(msgObj: nil)
        }
    }
    
    func RetryBtnPressed(for objChat: Model_ChatMessage) {
        
        objChat.isUploading = true
        objChat.isError = false
        
        switch XMPP_Message_Type.init(rawValue: objChat.msgType!) {
        case .text, .location:
            if objChat.isOutgoing {
                
            }
            break
        default:
            if objChat.isOutgoing {
                if objChat.msgStatus != 1 && objChat.msgStatus != 2 && objChat.msgStatus != 3 {
                    let lastPath = URL(fileURLWithPath: objChat.localPath!).lastPathComponent
                    let _url = Chat_Utility.documentsPath.appendingPathComponent(lastPath)
                    
                    let objUploadTask = ChatUploadTask.init(objChat: objChat, localPath: _url)
                    objUploadTask.delegate = self
                    AWSS3Manager.shared.activeUploads.append(objUploadTask)
                    XMPP_MessageArchiving_Custom.UpdateMessage(obj: objChat)
                    self.updateMessage(with: objChat)
                    
                    if AWSS3Manager.shared.index == 0 {
                        AWSS3Manager.shared.sequenceUpload()
                    }
                }
            }
        }
        
//        if objChat.isOutgoing {
//
//            let lastPath = URL(fileURLWithPath: objChat.localPath!).lastPathComponent
//            let _url = Chat_Utility.documentsPath.appendingPathComponent(lastPath)
//
//            let objUploadTask = ChatUploadTask.init(objChat: objChat, localPath: _url)
//            objUploadTask.delegate = self
//            AWSS3Manager.shared.activeUploads.append(objUploadTask)
//            XMPP_MessageArchiving_Custom.UpdateMessage(obj: objChat)
//            self.updateMessage(with: objChat)
//
//            if AWSS3Manager.shared.index == 0 {
//                AWSS3Manager.shared.sequenceUpload()
//            }
//        }
    }
}

//MARK:-===================== UITextViewDelegate & TypingNotification ==========
extension OneToOneChatVC : RSKGrowingTextViewDelegate , UITextViewDelegate {
    
    @objc func stopTypingNotification() {
        guard self.objFriend != nil else {
            return
        }
        SOXmpp.manager.xmpp_SendTypingNotification(to: self.objFriend!.xmppJID!, isTyping: false)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count > 0 {
            guard self.objFriend != nil else {
                return
            }
            SOXmpp.manager.xmpp_SendTypingNotification(to: self.objFriend!.xmppJID!, isTyping: true)
        }
        
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.stopTypingNotification), object: textView)
        self.perform(#selector(self.stopTypingNotification), with: textView, afterDelay: 1)
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.stopTypingNotification()
    }
    
    func growingTextView(_ textView: RSKGrowingTextView, willChangeHeightFrom growingTextViewHeightBegin: CGFloat, to growingTextViewHeightEnd: CGFloat) {
        if growingTextViewHeightEnd < InputBarViewHeighConst {
            self.setViewInputBarHieght(height: InputBarViewHeighConst)
        } else {
            let height = (growingTextViewHeightBegin + 30.0)
            self.setViewInputBarHieght(height: height)
        }
    }
    func growingTextView(_ textView: RSKGrowingTextView, didChangeHeightFrom growingTextViewHeightBegin: CGFloat, to growingTextViewHeightEnd: CGFloat) {
        if growingTextViewHeightEnd < InputBarViewHeighConst {
            self.setViewInputBarHieght(height: InputBarViewHeighConst)
        } else {
            let height = (growingTextViewHeightBegin + 30.0)
            self.setViewInputBarHieght(height: height)
        }
    }
    
    private func setViewInputBarHieght(height: CGFloat) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.constaint_viewInputBar_Hieght.constant = height
            self.view.layoutIfNeeded()
        }
    }
}


extension OneToOneChatVC: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if(isBlock == 1){
            
        } else {
            if self.mediaType == .image {
               guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                //  guard let pickedImage = info[.editedImage] as? UIImage else {
                      print(" ERROR === UIImagePickerController  while getting editedImage ")
                      return
                  }
                  let _data = pickedImage.jpegData(compressionQuality: 1.0)
                  self.addMediaMessage(with: _data!, mediaType: .image, image : pickedImage)

            } else if self.mediaType == .video {
                guard let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
                //  guard let pickedImage = info[.editedImage] as? UIImage else {
                      print(" ERROR === UIImagePickerController  while getting VIDEO")
                      return
                }
                let _data = videoURL.getVideoData()
                self.addMediaMessageTEST(mediaType: .video, phAssetUrl: videoURL, image: nil)
//                  self.addMediaMessage(with: _data!, mediaType: .image, image : pickedImage)
            } else {
                guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                    //  guard let pickedImage = info[.editedImage] as? UIImage else {
                    print(" ERROR === UIImagePickerConroller  while getting GIF")
                    return
                }
                if #available(iOS 11.0, *) {
                    guard let videoURL = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
                        //  guard let pickedImage = info[.editedImage] as? UIImage else {
                        print(" ERROR === UIImagePickerConroller  while getting GIF")
                        return
                    }
                    self.addMediaMessageTEST(mediaType: .gif, phAssetUrl: videoURL, image: pickedImage)
                } else {
                    // Fallback on earlier versions
                }
                
//                let _data = videoURL.getVideoData()
                
            }
        }
    }
    func generateThumb(from videoURL: URL) -> UIImage? {
        return videoURL.getVideoThumbImage()
    }
}


//extension PHAsset {
//
//    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
//        if self.mediaType == .image {
//            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
//            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
//                return true
//            }
//            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
//                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
//            })
//            PHImageManager.default().requestImage(for: self, targetSize: .zero, contentMode: .default, options: nil) { (img, info) in
//
//            }
//        } else if self.mediaType == .video {
//            let options: PHVideoRequestOptions = PHVideoRequestOptions()
//            options.version = .original
//            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
//                if let urlAsset = asset as? AVURLAsset {
//                    let localVideoUrl: URL = urlAsset.url as URL
//                    completionHandler(localVideoUrl)
//                } else {
//                    completionHandler(nil)
//                }
//            })
//        }
//    }
//}
