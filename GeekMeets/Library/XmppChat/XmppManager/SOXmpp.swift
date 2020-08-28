//
//  SOXmpp.swift
//  xmppchat
//
//  Created by SOTSYS255 on 31/12/19.
//  Copyright © 2019 SOTSYS255. All rights reserved.
//

import Foundation
import XMPPFramework
import KissXML
import CoreData
import CFNetwork

private let Xmpp_Host = "dev1.spaceo.in" //Live : "3.129.31.9"  // Local : 172.16.18.97
private let Xmpp_Port: UInt16 = 5222

private let Xmpp_MyDomain: String = "@localhost"
private let Xmpp_UserIDPrefix: String = "" //"spaceo_lib_"

typealias BlockCompletionBool = (Bool)->Void
typealias BlockCompletionVoid = ()->Void

let NotificationXmppServerConnection: Notification.Name = Notification.Name.init(rawValue: "NotificationXmppServerConnection")
let Notification_User_Online_Offline: Notification.Name = Notification.Name.init(rawValue: "Notification_User_Online_Offline")
let Notification_RefreshChat: Notification.Name = Notification.Name.init(rawValue: "Notification_RefreshChat")
let Notification_RefreshChatAfterDelete: Notification.Name = Notification.Name.init(rawValue: "Notification_RefreshChatAfterDelete")

final class SOXmpp: NSObject {
    
    private override init() {
        super.init()
        self.setupStream()
    }
    static let manager: SOXmpp = SOXmpp()
    
    //MARK:- =====================variables===================
    var xmppStream: XMPPStream!
    var xmppReconnect: XMPPReconnect!
    var xmppRoster: XMPPRoster!
    var xmppRosterStorage: XMPPRosterCoreDataStorage!
    var xmppvCardStorage: XMPPvCardCoreDataStorage!
    var xmppvCardTempModule: XMPPvCardTempModule!
    var xmppvCardAvatarModule: XMPPvCardAvatarModule!
    var xmppCapabilities: XMPPCapabilities!
    var xmppCapabilitiesStorage: XMPPCapabilitiesCoreDataStorage!
    var xmppMessageArchivingCoreDataStorage: XMPPMessageArchivingCoreDataStorage!
    var xmppCoreDataStorage: XMPPCoreDataStorage!
    var xmppMessageArchivingModule: XMPPMessageArchiving!
    var xmppMessageDeliveryRecipts: XMPPMessageDeliveryReceipts!
    var xmppPrivacy: XMPPPrivacy!
    var xmppTracker: XMPPIDTracker!
    var xmppLastActivity: XMPPLastActivity!
    var xmppDelayedDelivery: XMPPDelayedDelivery!
    var xmppMAM: XMPPMessageArchiveManagement!
    
    var xmppMUC: XMPPMUC!
    var xmppRoom: XMPPRoom!
    var xmppRoomHybridStorage: XMPPRoomHybridStorage!
    
    var xmppBlocking: XMPPBlocking?
    
    var customCertEvaluation: Bool = false
    var isXmppConnected: Bool = false
    
    var password: String?
    var UserID: String?
    
    var UserName: String = ""
    var profileImageUrl: String = ""
    
    var registerData:[String: String] = [:]
    
    // callback for login
    var _bLoginCallback: BlockCompletionBool?
    // callback for registration
    var _bRegistrationCallback: BlockCompletionBool?
    
    // callback to update chat list
    var _bUpdateChatList:((Model_ChatMessage?) -> Void)?
    // callback for friend list
    var _bFriendListUpdateCallback:(() -> Void)?
    
    // callback for user status // online / offline etc
    var _bFriendStatusUpdateCallback:(() -> Void)?
    
    // callback for user typing status
    var _bChangeTypingStatus:BlockCompletionBool?
    
    private var _bChatStartingWithVcard:((XMPPvCardTemp,XMPPJID) -> Void)?
    
    var isChatListPresent: Bool = false {
        didSet {
             self._bFriendListUpdateCallback?()
        }
    }
    
    var _collectionFriendsStatus:[String: String] = [:]
    var _arrTypingUsersIDs:[String] = [String]()
    var _unreadMessageCount:[String: Int] = [:]
    var arrFriendsList:[Model_ChatFriendList] = [Model_ChatFriendList]()
    
    ////////////////////////////////////////////////
    //MARK:- Core Data
    
    func managedObjectContext_roster() -> NSManagedObjectContext {
        return xmppRosterStorage.mainThreadManagedObjectContext
    }
    func managedObjectContext_capabilities() -> NSManagedObjectContext {
       return xmppCapabilitiesStorage.mainThreadManagedObjectContext
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK:- Private ===============SETUP STREAM & Connect
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func setupStream()  {
        
        assert(xmppStream == nil, "Method setupStream invoked multiple times")
        // Setup xmpp stream
        //
        // The XMPPStream is the base class for all activity.
        // Everything else plugs into the xmppStream, such as modules/extensions and delegates.
        
        xmppStream = XMPPStream.init()
        
        #if !TARGET_IPHONE_SIMULATOR
                    // Want xmpp to run in the background?
                    //
                    // P.S. - The simulator doesn't support backgrounding yet.
                    //        When you try to set the associated property on the simulator, it simply fails.
                    //        And when you background an app on the simulator,
                    //        it just queues network traffic til the app is foregrounded again.
                    //        We are patiently waiting for a fix from Apple.
                    //        If you do enableBackgroundingOnSocket on the simulator,
                    //        you will simply see an error message from the xmpp stack when it fails to set the property.
                    
            xmppStream.enableBackgroundingOnSocket = true
        #endif
        
        // Setup reconnect
               //
               // The XMPPReconnect module monitors for "accidental disconnections" and
               // automatically reconnects the stream for you.
               // There's a bunch more information in the XMPPReconnect header file.
        
        xmppReconnect = XMPPReconnect.init()

        
        // Setup roster
        //
        // The XMPPRoster handles the xmpp protocol stuff related to the roster.
        // The storage for the roster is abstracted.
        // So you can use any storage mechanism you want.
        // You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
        // or setup your own using raw SQLite, or create your own storage mechanism.
        // You can do it however you like! It's your application.
        // But you do need to provide the roster with some storage facility.
        xmppRosterStorage = XMPPRosterCoreDataStorage.init()
        
        xmppRoster = XMPPRoster.init(rosterStorage: xmppRosterStorage)
        xmppRoster.autoFetchRoster = true
        xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = true
        xmppRosterStorage.autoRemovePreviousDatabaseFile = true
        xmppRosterStorage.autoRecreateDatabaseFile = true
        //auto accept after rejected problem
        
        
        
        //XMPPJID
        
        // Setup vCard support
        //
        // The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
        // The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
        
        self.xmppvCardStorage = XMPPvCardCoreDataStorage.sharedInstance()
        
        self.xmppvCardTempModule = XMPPvCardTempModule.init(vCardStorage: xmppvCardStorage)
        
        
        self.xmppvCardAvatarModule = XMPPvCardAvatarModule.init(vCardTempModule: xmppvCardTempModule)
        
        
        // Setup capabilities
        //
        // The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
        // Basically, when other clients broadcast their presence on the network
        // they include information about what capabilities their client supports (audio, video, file transfer, etc).
        // But as you can imagine, this list starts to get pretty big.
        // This is where the hashing stuff comes into play.
        // Most people running the same version of the same client are going to have the same list of capabilities.
        // So the protocol defines a standardized way to hash the list of capabilities.
        // Clients then broadcast the tiny hash instead of the big list.
        // The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
        // and also persistently storing the hashes so lookups aren't needed in the future.
        //
        // Similarly to the roster, the storage of the module is abstracted.
        // You are strongly encouraged to persist caps information across sessions.
        //
        // The XMPPCapabilitiesCoreDataStorage is an ideal solution.
        // It can also be shared amongst multiple streams to further reduce hash lookups.
        
        self.xmppCapabilitiesStorage = XMPPCapabilitiesCoreDataStorage.sharedInstance()
        self.xmppCapabilities = XMPPCapabilities.init(capabilitiesStorage: xmppCapabilitiesStorage)
        
        self.xmppCapabilities.autoFetchHashedCapabilities = true
        self.xmppCapabilities.autoFetchNonHashedCapabilities = false;
        
        self.xmppCoreDataStorage = XMPPCoreDataStorage.init(databaseFilename: "XmppChatDB", storeOptions: [:])
        
        //self.xmppMessageArchivingCoreDataStorage = XMPPMessageArchivingCoreDataStorage.sharedInstance()
        
//        self.xmppMessageArchivingModule = XMPPMessageArchiving.init(dispatchQueue: .main)
//        self.xmppMessageArchivingModule.clientSideMessageArchivingOnly = false
//        self.xmppMessageArchivingModule.xmppMessageArchivingStorage
        
        self.xmppMessageDeliveryRecipts = XMPPMessageDeliveryReceipts.init(dispatchQueue: .main)

        self.xmppMessageDeliveryRecipts.autoSendMessageDeliveryReceipts = true;
        self.xmppMessageDeliveryRecipts.autoSendMessageDeliveryRequests = true;

        
        // xmppMAM
        xmppMAM = XMPPMessageArchiveManagement.init(dispatchQueue: .main)
        xmppMAM.activate(self.xmppStream)
        
        //privacy list
        self.xmppPrivacy = XMPPPrivacy.init(dispatchQueue: .main)
        //Activate xmpp modules
        self.xmppPrivacy.activate(self.xmppStream)
        //Delegate XMPPPrivacy
        self.xmppPrivacy.addDelegate(self, delegateQueue: .main)
        self.xmppPrivacy.retrieveList(withName: "Block_List")
        self.xmppMUC = XMPPMUC.init(dispatchQueue: .main)
        
        // last seen activity
        xmppLastActivity = XMPPLastActivity.init(dispatchQueue: .main)
        self.xmppLastActivity.addDelegate(self, delegateQueue: .main)
        self.xmppLastActivity.activate(self.xmppStream)
        
        
        // Activate xmpp modules
        
        self.xmppReconnect.activate(self.xmppStream)
        self.xmppRoster.activate(self.xmppStream)
        self.xmppvCardTempModule.activate(self.xmppStream)
        self.xmppvCardAvatarModule.activate(self.xmppStream)
        self.xmppCapabilities.activate(self.xmppStream)
        //self.xmppMessageArchivingModule.activate(self.xmppStream)
        
        self.xmppMUC.activate(self.xmppStream)
        //Group [Start]
        self.xmppMessageDeliveryRecipts.activate(self.xmppStream)
        
        // Add ourself as a delegate to anything we may be interested in
        
        self.xmppStream.addDelegate(self, delegateQueue: .main)
        self.xmppReconnect.addDelegate(self, delegateQueue: .main)
        
        self.xmppRoster.addDelegate(self, delegateQueue: .main)
        self.xmppvCardTempModule.addDelegate(self, delegateQueue: .main)
        
        self.xmppMAM.addDelegate(self, delegateQueue: .main)
        
        //Group [Start]
        self.xmppMUC.addDelegate(self, delegateQueue: .main)
        //Group [End]
        
        // Optional:
        //
        // Replace me with the proper domain and port.
        // The example below is setup for a typical google talk account.
        //
        // If you don't supply a hostName, then it will be automatically resolved using the JID (below).
        // For example, if you supply a JID like 'user@quack.com/rsrc'
        // then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
        //
        // If you don't specify a hostPort, then the default (5222) will be used.
        
        
        self.xmppStream.hostName =  Xmpp_Host
        self.xmppStream.hostPort = Xmpp_Port
        
        
        // You may need to alter these settings depending on the server you're connecting to
        customCertEvaluation = true;
        
        NotificationCenter.default.addObserver(self, selector: #selector(appInBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appInForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillTerminate), name: UIApplication.willTerminateNotification, object: nil)
        
    }
    
    @objc func appInForeground() {
        NotificationCenter.default.post(name: Notification_RefreshChat, object: nil, userInfo: nil)
        Model_SOXmppLogin.loginToXmpp()
    }
    @objc func appInBackground() {
        SOXmpp.manager.disconnect()
        //AWSS3Manager.shared.CancelAllDownloadAndUploadTask()
    }
    @objc func appWillTerminate() {
        SOXmpp.manager.disconnect()
        //AWSS3Manager.shared.CancelAllDownloadAndUploadTask()
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willTerminateNotification, object: nil)
    }
    
    func connect() -> Bool {
        
        xmppTracker = XMPPIDTracker.init(dispatchQueue: .main)
        
        if (!xmppStream.isDisconnected) {
            printMsg(with: "connect : xmppStream already connected ")
            return true;
        }
        if self.UserID == nil ||  self.password == nil {
            printMsg(with: "connect : UserID or password cannot be blank")
            return false;
        }
        // If you don't want to use the Settings view to set the JID,
        // uncomment the section below to hard code a JID and password.
        //
        // myJID = @"user@gmail.com/xmppframework";
        // myPassword = @"";
        let JID = "\(self.UserID!)\(Xmpp_MyDomain)"
        
        xmppStream.myJID = XMPPJID.init(string: JID)
        
        do {
            try xmppStream.connect(withTimeout: 30.0)
        } catch let error {
            printMsg(with: "connect: \(error.localizedDescription)")
            return false
        }
        
        return true;
    }
    
    func disconnect() {
        if !self.xmppStream.isConnected {
            return
        }
        self.goOffline()
        xmppStream.disconnect()
        //xmppTracker.removeAllIDs()
        xmppTracker = nil;
        self.printMsg(with: "xmpp disconnect")
    }
    
    func goOnline() {
        let presence = XMPPPresence.init() // type="available" is implicit
        self.xmppStream.send(presence)
    }
    
    func goOffline() {
        let presence = XMPPPresence.init(name: XMPPPresence.PresenceType.unavailable.rawValue) // unavailable
        let priority = XMLElement.init(name: "priority", stringValue: "24")
        presence.addChild(priority) // [presence addChild:priority];
        self.xmppStream.send(presence)
    }
    
    //MARK:- =========================== XMPP LOGIN AND REGISTER ==============
    private func authenticateUser() {
        do {
            try self.xmppStream.authenticate(withPassword: self.password!)
        } catch let error {
            print(error.localizedDescription)
            print("Error authenticate: \(error)");
        }
    }
    
    func Login(objLogin:Model_SOXmppLogin,completion:@escaping BlockCompletionBool) {
        
        self.UserID = "\(Xmpp_UserIDPrefix)\(objLogin.userID)"
        self.password = "\(Xmpp_UserIDPrefix)\(objLogin.password)"
        self.UserName = objLogin.userName ?? ""
        self.profileImageUrl = objLogin.userImage ?? ""
        
        if xmppStream == nil {
            //setup stream
            self.setupStream()
        }
        self._bLoginCallback = completion
        //connect
        let status = self.connect()
        
        if status && xmppStream.isAuthenticated && self._bLoginCallback != nil {
            self._bLoginCallback!(true)
        } else {
            self._bLoginCallback!(false)
        }
    }
    
    func xmpp_RegisterUserWithDetail(objLogin:Model_SOXmppLogin, completion:@escaping BlockCompletionBool) {
      
        self.UserID = "\(Xmpp_UserIDPrefix)\(objLogin.userID)"
        self.password = "\(Xmpp_UserIDPrefix)\(objLogin.password)"
        self.UserName = objLogin.userName ?? ""
        self.profileImageUrl = objLogin.userImage ?? ""
        
        if xmppStream == nil {
            //setup stream
            self.setupStream()
        }
        self._bRegistrationCallback = completion
        //connect
        _ = self.connect()
        
    }
    
    //MARK:- =========================== GENERAL METHODS ==============
    private func printMsg(with description: String) {
        print("========================= XMPP MESSAGE ==================")
        print(description)
        print("=========================================================")
    }
    
    func GetJabberID(of _id: String) -> XMPPJID {
        return  XMPPJID.init(string: "\(Xmpp_UserIDPrefix)\(_id)\(Xmpp_MyDomain)")!
    }
    func GetVcard(of _id: XMPPJID) -> XMPPvCardTemp? {
        return  self.xmppvCardStorage.vCardTemp(for: _id, xmppStream: self.xmppStream)
    }
    
    func GetUnreadCound(of _id: String) -> Int? {
        let finalID = "\(self.xmppStream.myJID!.bare)_\(_id)"
        if self._unreadMessageCount.keys.contains(finalID) {
            return self._unreadMessageCount[finalID]
        }
        return nil
    }
    
    func SetUnreadCount(of _id: String) {
        let finalID = "\(self.xmppStream.myJID!.bare)_\(_id)"
        if let unreadCount = self.GetUnreadCound(of: _id) {
            self._unreadMessageCount[finalID] = unreadCount + 1
        } else {
            self._unreadMessageCount[finalID] = 1
        }
        UserDefaults.standard.setValue(self._unreadMessageCount, forKey: kxmppUnreadMessageCount)
    }
    
    func ResetUnreadCount(of _id: String) {
        
        let finalID = "\(self.xmppStream.myJID!.bare)_\(_id)"
        
        _unreadMessageCount[finalID] = 0
        UserDefaults.standard.setValue(SOXmpp.manager._unreadMessageCount, forKey: kxmppUnreadMessageCount)
    }
    
//    func StartNewChat(with _userID: String , complition: @escaping ((Model_ChatFriendList) -> Void)) {
//
//        let requestUserJID = self.GetJabberID(of: "\(_userID)")
//
//        if let _vcard = self.GetVcard(of: requestUserJID) {
//            var friend = Model_ChatFriendList.init(_vCard: _vcard)
//            friend.xmppJID = requestUserJID
//            complition(friend)
//        } else {
//            self._bChatStartingWithVcard = { _vcard, _jid in
//                if _jid.bare == requestUserJID.bare {
//                    self._bChatStartingWithVcard = nil
//                    var friend = Model_ChatFriendList.init(_vCard: _vcard)
//                    friend.xmppJID = _jid
//                    complition(friend)
//                }
//            }
//            self.xmppvCardTempModule.fetchvCardTemp(for: requestUserJID, ignoreStorage: true)
//        }
//
//    }
    
}

//MARK:- ===================== XMPPStreamDelegate ==================
extension SOXmpp: XMPPStreamDelegate {
    
    
    func xmppStream(_ sender: XMPPStream, socketDidConnect socket: GCDAsyncSocket) {
        print("======================socketDidConnect")
    }
    func xmppStream(_ sender: XMPPStream, willSecureWithSettings settings: NSMutableDictionary) {
        let expectedCertName = xmppStream.myJID!.domain
        if !expectedCertName.isEmpty
        {
            settings.setObject(expectedCertName, forKey:(kCFStreamSSLPeerName as NSString))
        }
        
        if (customCertEvaluation)
        {
            settings.setObject(true, forKey:(GCDAsyncSocketManuallyEvaluateTrust as NSString))
        }

    }
    
    func xmppStream(_ sender: XMPPStream, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        let bgQueue = DispatchQueue.global(qos: .background)
        bgQueue.async {
            var result:SecTrustResultType = .deny
            let status: OSStatus = SecTrustEvaluate(trust, &result)
            if (status == noErr && (result == SecTrustResultType.proceed || result == .unspecified)) {
                completionHandler(true);
            }
            else {
                completionHandler(false);
            }
        }
    }
    
    func xmppStreamDidSecure(_ sender: XMPPStream) {
        
    }
    
    //MARK:- ===================== XMPP Connect &  Disconnect ==================
    func xmppStreamDidConnect(_ sender: XMPPStream) {
        isXmppConnected = true
        printMsg(with: "XMPP Stream Did Connect")
        
        self.authenticateUser()
    }
    
    func xmppStreamDidDisconnect(_ sender: XMPPStream, withError error: Error?) {
//        if (!isXmppConnected)
//        {
            printMsg(with: "XMPPStream Unable to connect to server. Check xmppStream.hostName")
//        }
        //NotificationCenter.default.post(name: NotificationXmppServerConnection, object: nil, userInfo: nil)
    }
    
    func xmppStreamConnectDidTimeout(_ sender: XMPPStream) {
        printMsg(with: "xmppStreamConnectDidTimeout")
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
        
        printMsg(with: "User authenticated successfully")
        
        self.goOnline()
        
        self.xmpp_UpdateMyvCard()
        
        if self._bLoginCallback != nil {
            self._bLoginCallback!(true)
        }
        
        if self._bRegistrationCallback != nil {
            self._bRegistrationCallback!(true)
        }
    
        
    }
    
    func xmppStream(_ sender: XMPPStream, didNotAuthenticate error: DDXMLElement) {
        printMsg(with: "User authentication failed.....")
        print(error.description)
        print("Error didNotAuthenticate: \(error)");
        
        if self._bRegistrationCallback != nil {
            var elements = [XMLElement]()
            elements.append(XMLElement.init(name: "username", stringValue: self.UserID!))
            elements.append(XMLElement.init(name: "password", stringValue: self.password!))
            elements.append(XMLElement.init(name: "name", stringValue: self.UserName))
            elements.append(XMLElement.init(name: "url", stringValue: self.profileImageUrl))
            do {
                try self.xmppStream.register(with: elements) //register(withPassword: String(describing: _userID))
            } catch let error {
                printMsg(with: "Registration error")
                print(error.localizedDescription)
            }
        } else {
            self.disconnect()
        }
    }
    
     //MARK:- ===================== XMPP Register &  Authenticate ==================
    
    func xmppStreamDidRegister(_ sender: XMPPStream) {
        printMsg(with: "User Registered successfully")
//        if self._bRegistrationCallback != nil {
//            self._bRegistrationCallback!(true)
//        }
        self.authenticateUser()
    }
    func xmppStream(_ sender: XMPPStream, didNotRegister error: DDXMLElement) {
        printMsg(with: " User Not Register")
        printMsg(with: error.description)
        if self._bRegistrationCallback != nil {
            self._bRegistrationCallback!(false)
        }
    }
    
    
    
    //MARK:- ===================== XMPP didReceive IQ ==================
    
    func xmppStream(_ sender: XMPPStream, didReceive iq: XMPPIQ) -> Bool {
        
        print("XMPP didReceive IQ =====   ")
        print("XMPP didReceive IQ \(iq) ")
        
        return true
    }
    
    //MARK:- ===================== XMPP didReceive message ==================
    
    func xmppStream(_ sender: XMPPStream, didReceive message: XMPPMessage) {
        print("did  Receive message.........\(message)")
        
        guard let messageFromStr = message.from?.bare else { return }
        
        //1 unreadCount
        if message.isChatMessageWithBody {
            
            self.SetUnreadCount(of: messageFromStr)
            
            //1
            let obj = Model_ChatMessage.init(xmppMessageObj: message)
            
            if obj.isForRemove == false {
            //2
                XMPP_MessageArchiving_Custom.InsertMessage(obj: obj)
                if self._bUpdateChatList != nil {
                    self._bUpdateChatList!(obj)
                }
            } else {
                XMPP_MessageArchiving_Custom.RemoveMessage(obj: obj)
                fetchArchieveingAfterDeleteMsg()
            }
            //AppDelegate.shared.showNotificaiton(objChat: obj)
            
        }
    
        //2 typing status
        
        if message.hasChatState && message.errorMessage == nil {
            
            let typingStatus = message.hasComposingChatState
            self.xmpp_setTypingStatus(to: XMPPJID.init(string: message.from!.bare)!, typingStatus: typingStatus)
            
            return
        }
        
        // 3 set delivered
        if message.hasReceiptResponse && message.receiptResponseID != nil {
            self.updateMessageStatus(status: .delivered, messageID: message.receiptResponseID!)
        }
        //4 read status
        //print(message.element(forName: "x", xmlns: "jabber:x:event")?.element(forName: "id")?.stringValue)
        let msgID = message.element(forName: "x", xmlns: "jabber:x:event")?.element(forName: "id")?.stringValue
        if msgID != nil {
            self.updateMessageStatus(status: .read, messageID: msgID!)
        }
    
        if self._bFriendListUpdateCallback != nil {
            self._bFriendListUpdateCallback!()
        }

    }
    
    //MARK:- ===================== XMPP didSend message ==================
    func xmppStream(_ sender: XMPPStream, didSend message: XMPPMessage) {
        print("did  Send message.........\n \(message)")
        if message.isChatMessageWithBody {
            //1
            let obj = Model_ChatMessage.init(xmppMessageObj: message)
            //2
            if obj.isForRemove == false {
                self.updateMessageStatus(status: .sent, messageID: obj.messageId)
            } else {
                XMPP_MessageArchiving_Custom.RemoveMessage(obj: obj)
                fetchArchieveingAfterDeleteMsg()
            }
        }
    }
    
    
    func xmppStream(_ sender: XMPPStream, didFailToSend message: XMPPMessage, error: Error) {
        printMsg(with: "Error == didFailToSend \n\(error.localizedDescription)\n \(message)")
    }
    //MARK:- ===================== XMPP didReceive presence ==================
    func xmppStream(_ sender: XMPPStream, didReceive presence: XMPPPresence) {
        
        print("Receiving Presence ....")
        //1
        
        print(" Presence type... \(presence.type ?? "")")
        print(" Presence showType... \(presence.showType?.rawValue ?? "")")
        print(" Presence toStr... \(presence.toStr ?? "")")
        print(" Presence FromStr... \(presence.fromStr ?? "")")
        print(" Presence status... \(presence.status ?? "")")
        
        if self.xmppStream.myJID == presence.from {
            print("Logged in user Presence")
            return
        }
        
        //2
        guard let presenceFromStr = presence.from?.bare else { return }
        
        //3
        guard let presenceType = presence.type  else {
            printMsg(with: "Presence type... NOT AVAILABLE")
            return
        }
        
        switch presenceType {
        case xmppKey_User_Subscribed: break
            
        case xmppKey_User_Available:
            
            _collectionFriendsStatus[presenceFromStr] = xmpp_User_online
            
            self.xmppvCardTempModule.fetchvCardTemp(for: presence.from!, ignoreStorage: true)
            
            break
            
        case xmppKey_User_Unvailable:
            
            _collectionFriendsStatus[presenceFromStr] = xmpp_User_offline
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.xmpp_getLastActivityOfUser(jid: XMPPJID.init(string: presenceFromStr)!)
            }
            
            break
            
        default:
            break
        }
        
    }
    
    func xmppStream(_ sender: XMPPStream, didReceiveError error: DDXMLElement) {
        
    }
    
    
}
//MARK:- ===================== XMPPMessage Archive Management Delegate ==================
extension SOXmpp: XMPPMessageArchiveManagementDelegate {
    
    func xmppMessageArchiveManagement(_ xmppMessageArchiveManagement: XMPPMessageArchiveManagement, didReceiveMAMMessage message: XMPPMessage) {
        printMsg(with: "did Receive MAM Message")
        print("-------------Message ---- \n\(message)")
//        //1
//        let obj = Model_ChatMessage.init(xmppMessageObj: message)
//
//        //2
//        XMPP_MessageArchiving_Custom.InsertMessage(obj: obj)
//
//        if self._bUpdateChatList != nil {
//            self._bUpdateChatList!(obj)
//        }
//
//        if self._bFriendListUpdateCallback != nil {
//            self._bFriendListUpdateCallback!()
//        }
    }
    func xmppMessageArchiveManagement(_ xmppMessageArchiveManagement: XMPPMessageArchiveManagement, didFinishReceivingMessagesWith resultSet: XMPPResultSet) {
        
        printMsg(with: "didFinishReceivingMessagesWith")
        print("-----------XMPPResultSet--\n \(resultSet)")
        
    }
}

//MARK:- ===================== XMPP Deliver ==================
//extension SOXmpp: XMPPMessageDeliveryReceiptsDelegate {
//
//    func xmppMessageDeliveryReceipts(_ xmppMessageDeliveryReceipts: XMPPMessageDeliveryReceipts, didReceiveReceiptResponseMessage message: XMPPMessage) {
//        print("=========== did Receive Receipt Response Message \n \(message)")
//        if message.isChatMessageWithBody {
//            //1
//            let obj = Model_ChatMessage.init(xmppMessageObj: message)
//            //2
//            if let msg = XMPP_MessageArchiving_Custom.fetchMessageObj(with: obj.messageId) {
//
//                msg.msgStatus = XMPP_Message_Status.read.rawValue
//
//                XMPP_MessageArchiving_Custom.UpdateMessage(obj: msg)
//                if self._bUpdateChatList != nil {
//                    self._bUpdateChatList!(msg)
//                }
//            }
//
//        }
//    }
//
//}
//MARK:- ===================== XMPP Recconect Delegate ==================
extension SOXmpp: XMPPReconnectDelegate {
    
    func xmppReconnect(_ sender: XMPPReconnect, didDetectAccidentalDisconnect connectionFlags: SCNetworkConnectionFlags) {
        printMsg(with: "XMPP Disconnect ....")
    }
    func xmppReconnect(_ sender: XMPPReconnect, shouldAttemptAutoReconnect connectionFlags: SCNetworkConnectionFlags) -> Bool {
        printMsg(with: "XMPP Reconnecting ....")
        return true
    }
    
}
//MARK:- ===================== XMPPRosterDelegate & Methods ==================
extension SOXmpp: XMPPRosterDelegate {
    func xmppRoster(_ sender: XMPPRoster, didReceiveRosterItem item: DDXMLElement) {
        print("didReceiveRosterItem.........\(sender)")
        print(item.attributesAsDictionary())
        let itemData = item.attributesAsDictionary()
        if let jid = itemData["jid"] {
            //self.xmppvCardTempModule.fetchvCardTemp(for: XMPPJID.init(string: jid)!)
            self.xmppvCardTempModule.fetchvCardTemp(for:  XMPPJID.init(string: jid)!, ignoreStorage: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.xmpp_getLastActivityOfUser(jid: XMPPJID.init(string: jid)!)
            }
        }
        if let subscription = itemData["subscription"] {
            if subscription == "remove" {
                self.xmpp_getFriendList()
            }
        }
        //["jid": "spaceo_lib_101@localhost", "subscription": "remove"]
    }
    func xmppRoster(_ sender: XMPPRoster, didReceivePresenceSubscriptionRequest presence: XMPPPresence) {
        if presence.from != nil {
            sender.acceptPresenceSubscriptionRequest(from: presence.from!, andAddToRoster: true)
            print("didReceivePresenceSubscriptionRequest..........")
            print(" Presence type... \(presence.type ?? "")")
            print(" Presence toStr... \(presence.toStr ?? "")")
            print(" Presence toFrom... \(presence.fromStr ?? "")")
            print(" Presence status... \(presence.status ?? "")")
        }
    }
    
    func xmpp_SendFriendRequest(to Jid: XMPPJID) {
        if self.xmppStream.isConnected == false {
            return
        }
        xmppRoster.addUser(Jid, withNickname: nil, groups: nil, subscribeToPresence: true)
    }
    
    func xmpp_getFriendList() { //(_ completion:@escaping ([Model_ChatFriendList]) -> Void) {
        if self.xmppStream.isConnected == false {
            return
        }
        //xmppRoster.fetch()
        let arrIDs = self.xmppRosterStorage.jids(for: self.xmppStream)
        
        self.arrFriendsList.removeAll()
        
        for item in arrIDs {
            
            var obj = Model_ChatFriendList.init()
            obj.jID = item.bare
            obj.xmppJID = item
            obj.vCard = self.GetVcard(of: item)
            
            self.arrFriendsList.append(obj)
            
            //self.retrieveArchivedMessages(objFriend: obj)
        }
        
        self.arrFriendsList.forEach { self.xmppvCardTempModule.fetchvCardTemp(for:  $0.xmppJID!, ignoreStorage: true) }
    
        self._bFriendListUpdateCallback?()
        
    }
    
}

//MARK:- ===================== vCardDelegate & Methods ==================
extension SOXmpp: XMPPvCardTempModuleDelegate {
    
    func xmppvCardTempModule(_ vCardTempModule: XMPPvCardTempModule, didReceivevCardTemp vCardTemp: XMPPvCardTemp, for jid: XMPPJID) {
        print("Receive vCard ...")
        print("vCard ===== jid.full \(jid.full)")
        print("vCard ===== jid.bare \(jid.bare)")
        print("vCard ===== jid.user \(jid.user ?? "")")
        print("vCard ===== nickname \(vCardTemp.nickname ?? "")")
        print("vCard ===== photo url \(vCardTemp.url ?? "")")
        
        if jid == self.xmppStream.myJID {
            printMsg(with: "======= self vcard recieved ======")
            return
        }
        
        self._bChatStartingWithVcard?(vCardTemp, jid)
        
        if let index = self.arrFriendsList.firstIndex( where: { $0.jID ==  jid.bare } ) {
            
            self.arrFriendsList[index].imagUrl = vCardTemp.url ?? ""
            self.arrFriendsList[index].name = vCardTemp.nickname ?? ""
            self.arrFriendsList[index].vCard = vCardTemp
            
        } else if self.xmppStream.myJID != jid {
            self.xmpp_getFriendList()
            return
        } else {
            print("============= vcard not found in friend list")
        }
        
        //1
        //self._bFriendListUpdateCallback?()
        
        //2 used to update user status and details
        NotificationCenter.default.post(name: Notification_User_Online_Offline, object: nil, userInfo: nil)
        
        
    }
    func xmppvCardTempModuleDidUpdateMyvCard(_ vCardTempModule: XMPPvCardTempModule) {
        printMsg(with: "xmppvCardTempModuleDidUpdateMyvCard")
        
        if self.xmppStream.isConnected == false {
            print("xmppStream not connected")
            return
        }
        
        self.xmpp_getFriendList()
    }
    func xmppvCardTempModule(_ vCardTempModule: XMPPvCardTempModule, failedToUpdateMyvCard error: DDXMLElement?) {
        printMsg(with: "failedToUpdateMyvCard XMPPJID \(String(describing: error?.description))")
    }
    
    func xmppvCardTempModule(_ vCardTempModule: XMPPvCardTempModule, failedToFetchvCardFor jid: XMPPJID, error: DDXMLElement?) {
        printMsg(with: "failedToFetchvCardFor \(String(describing: error?.description))")
    }
    
    
    func xmpp_UpdateMyvCard() {
        
        let nickName = DDXMLElement.init(name: "NICKNAME", stringValue: self.UserName)
        let role = DDXMLElement.init(name: "ROLE", stringValue: "iOS")
        let photoUrl = DDXMLElement.init(name: "URL", stringValue: self.profileImageUrl)
        
        let x = DDXMLElement.init(name: "vCard", xmlns: "vcard-temp")
        x.addChild(nickName)
        x.addChild(role)
        x.addChild(photoUrl)
        
        let iq = DDXMLElement.init(name: "iq")
        iq.addAttribute(withName: "type", stringValue: "set")
        iq.addAttribute(withName: "id", stringValue: "updatevcard")
        
        iq.addChild(x)
        
        print("==================IQ ==\(iq)")
        
//        self.xmppStream.send(iq)
//
//        xmppTracker.addID("updatevcard", block: { (obj, info) in
//            print(" updatevcard update  ==\(obj)")
//            print("updatevcard update  ==\(info.elementID)")
//        }, timeout: 60)
        
        let myVcardObj = XMPPvCardTemp.vCardTemp(from: x)
        
        self.xmppvCardTempModule.updateMyvCardTemp(myVcardObj)
        
        
    }
    
}

//MARK:-=========================XMPP Last Activity Delegate================================
extension SOXmpp: XMPPLastActivityDelegate {
    
    
    func xmppLastActivity(_ sender: XMPPLastActivity!, didReceiveResponse response: XMPPIQ!) {
        let query = response.element(forName: "query", xmlns: XMPPLastActivityNamespace)
        if query != nil {
            let attribute = query!.attributeStringValue(forName: "seconds") ?? ""
            print("xmppLastActivity second \(attribute)")

            if attribute == "0" {
                //user is online
                let from = response.attributeStringValue(forName: "from")!
                _collectionFriendsStatus[from] = xmpp_User_online
                
            } else {
                //user is offline
                let from = response.attributeStringValue(forName: "from")!
                let lastSeenTime = self.GetLastSeenTime(second: attribute as NSString)
                _collectionFriendsStatus[from] = "Last Seen on \(lastSeenTime)"
                if let _index = self.arrFriendsList.firstIndex(where: { $0.jID == from }) {
                    self.arrFriendsList[_index].lastSeenSeconds = attribute
                }
            }
            
        }
        print("xmppLastActivity response \(String(describing: response))")
        // used to update user status and details
        NotificationCenter.default.post(name: Notification_User_Online_Offline, object: nil, userInfo: nil)
    }
    
    func xmppLastActivity(_ sender: XMPPLastActivity!, didNotReceiveResponse queryID: String!, dueToTimeout timeout: TimeInterval) {
        print("xmppLastActivity did Not Receive Response")
    }
    
    func numberOfIdleTimeSeconds(for sender: XMPPLastActivity!, queryIQ iq: XMPPIQ!, currentIdleTimeSeconds idleSeconds: UInt) -> UInt {
        print("xmppLastActivity numberOfIdleTimeSeconds")
        return 0
    }
}
extension SOXmpp {
    
    //MARK:-========================= Methods  ================================
    
    func updateMessageStatus(status: XMPP_Message_Status , messageID: String) {
        
        if let msg = XMPP_MessageArchiving_Custom.fetchMessageObj(with: messageID) {

            if msg.msgStatus != XMPP_Message_Status.read.rawValue {
                msg.msgStatus = status.rawValue
                XMPP_MessageArchiving_Custom.UpdateMessage(obj: msg)
            }
            if self._bUpdateChatList != nil {
                self._bUpdateChatList!(msg)
            }
        }
    }
    
    func xmpp_SendTypingNotification(to jid:XMPPJID , isTyping: Bool) {
        let message = XMPPMessage.init(type: "chat", to: jid)
        isTyping ? message.addComposingChatState() : message.addInactiveChatState()
        self.xmppStream.send(message)
    }
    
    func xmpp_setTypingStatus(to jid:XMPPJID , typingStatus: Bool) {
        
        if typingStatus {
             if !self._arrTypingUsersIDs.contains(jid.bare) {
                 self._arrTypingUsersIDs.append(jid.bare)
             }
        } else {
            if let _index = self._arrTypingUsersIDs.firstIndex(of: jid.bare) {
                self._arrTypingUsersIDs.remove(at: _index)
            }
        }
        
        if self._bChangeTypingStatus != nil {
            self._bChangeTypingStatus!(typingStatus)
        }
    }
    
    func xmpp_getLastActivityOfUser(jid:XMPPJID) {
        self.xmppLastActivity.sendQuery(to: jid)
    }
    
    func xmpp_FetchArchiving(with toUserID: XMPPJID) -> [Model_ChatMessage]? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        let context = CoreDataManager.sharedManager.managedContext()
        //let context = self.xmppCoreDataStorage.managedObjectContext!
        
        let messageEntity: NSEntityDescription = NSEntityDescription.entity(forEntityName:   "XMPP_MessageArchiving_Custom", in: context)!
        
        fetchRequest.entity = messageEntity
        //fetchRequest.fetchOffset = pageOffset
        //fetchRequest.fetchLimit = pageSize
        
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate1 =  NSPredicate(format: "streamBareJidStr = %@","\(self.xmppStream.myJID!.bare)")
        let predicate2 =  NSPredicate(format: "bareJidStr = %@","\(toUserID.bare)")
        let predicateCompound = NSCompoundPredicate.init(type: .and, subpredicates: [predicate1,predicate2])
        fetchRequest.predicate = predicateCompound
        //fetchRequest.predicate = NSPredicate(format: "(fromAppID = %@) AND (toAppID = %@)","\(self.xmppStream.myJID!.user!)\(toUserID.user!)")
        
        do {
            let result = try context.fetch(fetchRequest)
            guard var filteredResult = result as? [XMPP_MessageArchiving_Custom] else {
                return nil
            }
            //            filteredResult = filteredResult.filter({ (evaluatedObject) -> Bool in
            //                if evaluatedObject.message != nil && evaluatedObject.message.isMessageWithBody {
            //                     return true
            //                }
            //                return false
            //            })
            
            filteredResult = filteredResult.sorted(by: { (obj1, obj2) -> Bool in
                return obj1.timestamp!.compare(obj2.timestamp!) == .orderedAscending
            })
            var arr = [Model_ChatMessage]()
            for item in filteredResult {
                let obj = Model_ChatMessage.init(xmppMessageObj: item)
                arr.append(obj)
            }
            //printMsg(with: "\(filteredResult.count)")
            return arr
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func xmpp_FetchArchivingObject(with toUserID: XMPPJID) -> NSArray {

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
    
        let context = CoreDataManager.sharedManager.managedContext()
        //let context = self.xmppCoreDataStorage.managedObjectContext!
        
        let messageEntity: NSEntityDescription = NSEntityDescription.entity(forEntityName:   "XMPP_MessageArchiving_Custom", in: context)!
        
        fetchRequest.entity = messageEntity
        //fetchRequest.fetchOffset = pageOffset
        //fetchRequest.fetchLimit = pageSize
    
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate1 =  NSPredicate(format: "streamBareJidStr = %@","\(self.xmppStream.myJID!.bare)")
        let predicate2 =  NSPredicate(format: "bareJidStr = %@","\(toUserID.bare)")
        let predicateCompound = NSCompoundPredicate.init(type: .and, subpredicates: [predicate1,predicate2])
        fetchRequest.predicate = predicateCompound
        //fetchRequest.predicate = NSPredicate(format: "(fromAppID = %@) AND (toAppID = %@)","\(self.xmppStream.myJID!.user!)\(toUserID.user!)")
    
        do {
            let result = try context.fetch(fetchRequest)
            guard var filteredResult = result as? [XMPP_MessageArchiving_Custom] else {
                return []
            }
//            filteredResult = filteredResult.filter({ (evaluatedObject) -> Bool in
//                if evaluatedObject.message != nil && evaluatedObject.message.isMessageWithBody {
//                     return true
//                }
//                return false
//            })
            
            filteredResult = filteredResult.sorted(by: { (obj1, obj2) -> Bool in
                return obj1.timestamp!.compare(obj2.timestamp!) == .orderedAscending
            })
            var arr = [Model_ChatMessage]()
            for item in filteredResult {
                let obj = Model_ChatMessage.init(xmppMessageObj: item)
                arr.append(obj)
            }
            //printMsg(with: "\(filteredResult.count)")
            return result as NSArray
        } catch {
            print(error.localizedDescription)
        }
    
        return []
    }
    
    //MARK - Duration From Timestamp

    func DurationStringFromTimestamp(_ timestamp: Date) -> String {
        
        
        //let CurrentTimeStamp:Double = Double(Chat_Utility.timeStamp())!
        //let timeStamp:Double = CurrentTimeStamp - time.doubleValue
        
        //let interval: TimeInterval = TimeInterval.init(time.doubleValue)
        let timeStampDate = timestamp//Date.init(timeIntervalSince1970: interval)
        
        let calendar = NSCalendar.current
        let unitFlags:Set<Calendar.Component> = [.month,.weekOfMonth,.weekOfYear,.day,.hour , .minute, .second]
        
        let dateComponents:NSDateComponents = calendar.dateComponents(unitFlags, from: timeStampDate, to: Date()) as NSDateComponents
        
        
        
        let weeks = abs(dateComponents.weekOfYear)
        let days  =    abs(dateComponents.day)
        let hours  =   abs(dateComponents.hour)
        let minutes =  abs(dateComponents.minute)
        let seconds =  abs(dateComponents.second)
        
        var duration: String = ""
        
        //    5s ago (if time < 1 min)
        //    2 min ago (if time < 1 hour)
        //    1 hour ago (if time < 1 day)
        //    2 days ago (if time < 1 week)
        //    1 week ago (If time > 1 week and < 2 week)
        //    27 Jan 2015, 08:20 AM (If time > 1week)
        
        if (weeks > 1)
        {
            //let date = Date.init(timeIntervalSince1970: timestamp.doubleValue)
            duration =  ST_DateFormater.GetFormatedDate(from: timestamp)
        }
        else if (weeks > 0)
        {
            //duration = String.init(format: "%ld %@", weeks , weeks > 1 ?  "weeks" : "week")
            duration =  ST_DateFormater.GetFormatedDate(from: timestamp)
        }
        else if (days > 0)
        {
            //duration = String.init(format: "%ld %@", days , days > 1 ?  "days" : "day")
            if days == 1 {
                duration =  ST_DateFormater.GetTime(from: timestamp)
            } else {
                duration =  ST_DateFormater.GetFormatedDate(from: timestamp)
            }
        }
        else if (hours > 0)
        {
            //duration = String.init(format: "%ld %@", hours , hours > 1 ?  "hours" : "hour")
            duration =  ST_DateFormater.GetTime(from: timestamp)
        }
        else if (minutes > 0)
        {
            //duration = String.init(format: "%ld %@", minutes , minutes > 1 ?  "mins" : "min")
            duration =  ST_DateFormater.GetTime(from: timestamp)
        } else   {
//            if (seconds <= 0)
//            {
//                return "now";
//            } else {
//                duration = String.init(format: "%lds", seconds)
//            }
            duration =  ST_DateFormater.GetTime(from: timestamp)
        }
        
        return duration
    }
    
    func GetLastSeenTime(second: NSString) -> String {
        
        let CurrentTimeStamp:Double = Double(Chat_Utility.timeStamp())!
        let timeStamp:Double = CurrentTimeStamp - second.doubleValue
        
        let interval: TimeInterval = TimeInterval.init(timeStamp)
        
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.timeZone = .current
        formatter.dateFormat = "MMM d, h:mm a"
        
        let _dateStr = formatter.string(from: Date.init(timeIntervalSince1970: interval))
        
        return _dateStr
    }
    
    
     //MARK:-=========================Send Message================================

    func xmpp_SendMessage(bodyData: String, objMsg: Model_ChatMessage) {
        
        if (bodyData.count == 0) {
            return;
        }
        
        var param:[String: Any] = [String: Any]()
        param["Platform"] = ""
        param["Username"] = ""
        
        if let vcardOfReciever = self.GetVcard(of: objMsg.ToJID!) {
            param["Platform"] = vcardOfReciever.role ?? ""
            param["Username"] = vcardOfReciever.nickname ?? ""
        }
        
        param["Type"] = objMsg.msgType!
        param["msgDetail"] = bodyData
        
        let subjectStr = Chat_Utility.getJsonString(from: param)
        
        //let msgDetail = XMLElement.init(name: "msgDetail", stringValue: bodyData)
        let subject = XMLElement.init(name: "subject", stringValue: subjectStr)
        var body:XMLElement = XMLElement.init(name: "body", stringValue: objMsg.strMsg!)
        
        switch objMsg.msgType! {
        case XMPP_Message_Type.text.rawValue:
            body = XMLElement.init(name: "body", stringValue: objMsg.strMsg!);break
            
        case XMPP_Message_Type.image.rawValue, XMPP_Message_Type.video.rawValue, XMPP_Message_Type.document.rawValue:
            body = XMLElement.init(name: "body", stringValue: objMsg.thumbUrl);break
            
        case XMPP_Message_Type.location.rawValue:
            body = XMLElement.init(name: "body", stringValue: objMsg.body);break
        default:
            break
        }
        //to
        let message = XMLElement.init(name: "message")
        message.addAttribute(withName: "to", stringValue: "\(objMsg.ToJID!.bare)")
        message.addAttribute(withName: "type", stringValue: "chat")
        message.addAttribute(withName: "id", stringValue: objMsg.messageId)
        if objMsg.strMsg != "" {
            message.addAttribute(withName: "latitude", stringValue: String((objMsg.strMsg?.split(",").first)!))
           message.addAttribute(withName: "longitude", stringValue: String((objMsg.strMsg?.split(",").last)!))
        }
        message.addChild(body)
        message.addChild(subject)
        //message.addChild(msgDetail)
        
        self.xmppStream.send(message)
        
    }
    
//    func xmpp_SendImageOrVideo(bodyData: String, objMsg: Model_ChatMessage) {
//
//        if (bodyData.count == 0) {
//            return;
//        }
//
//        let vcardOfReciever = self.GetVcard(of: objMsg.ToJID!)!
//
//        var param:[String: Any] = [String: Any]()
//
//        param["Platform"] = vcardOfReciever.role ?? ""
//        param["Type"] = objMsg.msgType!
//        param["Username"] = vcardOfReciever.nickname ?? ""
//        param["msgDetail"] = bodyData
//
//        let subjectStr = Chat_Utility.getJsonString(from: param)
//
//        //let msgDetail = XMLElement.init(name: "msgDetail", stringValue: bodyData)
//        let subject = XMLElement.init(name: "subject", stringValue: subjectStr)
//        let body = XMLElement.init(name: "body", stringValue: objMsg.thumbUrl)
//        //to
//        let message = XMLElement.init(name: "message")
//        message.addAttribute(withName: "to", stringValue: "\(objMsg.ToJID!.bare)")
//        message.addAttribute(withName: "type", stringValue: "chat")
//        message.addAttribute(withName: "id", stringValue: objMsg.messageId)
//
//        message.addChild(body)
//        message.addChild(subject)
//        message.addChild(msgDetail)
//
//        self.xmppStream.send(message)
//
//    }
    
    func sendReadMessageStatus(objMsg: Model_ChatMessage) {
        
        if objMsg.isOutgoing ||  objMsg.msgStatus == XMPP_Message_Status.read.rawValue {
            return
        }
        
        objMsg.msgStatus = XMPP_Message_Status.read.rawValue
        XMPP_MessageArchiving_Custom.UpdateMessage(obj: objMsg)
        
//        let message = XMLElement.init(name: "message", xmlns: "jabber:client")
//        message.addAttribute(withName: "to", stringValue: "\(objMsg.ToJID!.bare)")
//        message.addAttribute(withName: "type", stringValue: "chat")
//        message.addAttribute(withName: "id", stringValue: objMsg.messageId)
        
//        let message = XMPPMessage.init(type: "chat", to: objMsg.ToJID!, elementID: objMsg.messageId)
//        message.addDisplayedChatMarker(withID: objMsg.messageId)
//
//        self.xmppStream.send(message)
        
        let x = XMLElement.init(name: "x", xmlns: "jabber:x:event")
        let displayed = XMLElement.init(name: "displayed", stringValue: "")
        let id = XMLElement.init(name: "id", stringValue: objMsg.messageId)

        x.addChild(displayed)
        x.addChild(id)

        let request = XMLElement.init(name: "request", xmlns: "urn:xmpp:receipts")
        //to
        let message = XMLElement.init(name: "message", xmlns: "jabber:client")
        message.addAttribute(withName: "to", stringValue: "\(objMsg.FromJID!.full)")
        message.addAttribute(withName: "from", stringValue: "\(objMsg.ToJID!.bare)")
        message.addAttribute(withName: "id", stringValue: objMsg.messageId)
        print(objMsg.body)
        if objMsg.strMsg != "" {
            message.addAttribute(withName: "latitude", stringValue: String((objMsg.strMsg?.split(",").first)!))
            message.addAttribute(withName: "longitude", stringValue: String((objMsg.strMsg?.split(",").last)!))
        }
        
        message.addChild(x)
        message.addChild(request)

        //print(message)
        self.xmppStream.send(message)
    }
    
    
    func retrieveArchivedMessages(objFriend: Model_ChatFriendList) {
        
        
        /*
        <iq to='4_user_@localhost' id='6PxlL-1921' type='set'>
         <query xmlns='urn:xmpp:mam:1' queryid='683d4c27-c8ef-41eb-802c-b2c4a3a331c4'>
         <x xmlns='jabber:x:data' type='submit'>
         <field var='FORM_TYPE' type='hidden'><value>urn:xmpp:mam:1</value></field>
         <field var='with'><value>3_user@localhost</value></field>
         </x>
         <set xmlns='http://jabber.org/protocol/rsm'><max>10</max></set>
         </query>
         </iq> */
        
        
        /*
         let value = DDXMLElement(name: "value", stringValue: youJid)
         let child = DDXMLElement(name: "field")
         child.addChild(value)
         child.addAttribute(withName: "var", stringValue: "with")
         let set = XMPPResultSet(max: 1, before: "")
         xmppMam.retrieveMessageArchive(at: nil, withFields: [child], with: set)`
         */
        
        let value = DDXMLElement(name: "value", stringValue: objFriend.xmppJID!.full)
        let child = DDXMLElement(name: "field")
        child.addChild(value)
        child.addAttribute(withName: "var", stringValue: "with")
        let set1 = XMPPResultSet(max: 1, before: "")
        xmppMAM.retrieveMessageArchive(at: nil, withFields: [child], with: set1)
        
        return
        
        let set = XMPPResultSet(max: 3, before: "")
        
        let query = DDXMLElement.init(name: "query", xmlns: "urn:xmpp:mam:2")
        query.addAttribute(withName: "id", stringValue: XMPPStream.generateUUID)
        query.addChild(set)
        
        let x = DDXMLElement.init(name: "x", xmlns: "jabber:x:data")
        x.addAttribute(withName: "type", stringValue: "submit")


        let f1 = DDXMLElement.init(name: "field")
        f1.addAttribute(withName: "var", stringValue: "FORM_TYPE")
        f1.addAttribute(withName: "type", stringValue: "hidden")
        
        let f1value = DDXMLElement.init(name: "value")
        f1value.stringValue = "urn:xmpp:mam:2"

        let f2 = DDXMLElement.init(name: "field")
        f2.addAttribute(withName: "var", stringValue: "with")
 
        let f2value = DDXMLElement.init(name: "value")
        f2value.stringValue = objFriend.xmppJID!.full

        f1.addChild(f1value)
        f2.addChild(f2value)
        x.addChild(f2)
        x.addChild(f1)
        query.addChild(x)

        let iq :XMPPIQ = XMPPIQ(iqType: XMPPIQ.IQType.set, to: self.xmppStream.myJID!, elementID: "xmpp_MAM_Result", child: query)
        
         print(iq)
        self.xmppStream.send(iq)
    }
    
    func xmpp_RemoveArchiving(withID toUserID: XMPPJID) {
        let context = CoreDataManager.sharedManager.managedContext()
        let arrSkChats = xmpp_FetchArchivingObject(with: toUserID)

        (arrSkChats as NSArray).enumerateObjects({ skChat, idx, stop in
            if let messageObject = (skChat as? NSManagedObject) {
                context.delete(messageObject)
            }
        })

        do {
            try context.save()
        } catch {
        }
    }
    
    func xmpp_BlockUser(withJid userId: String?) {
        
        let strUser = userId! + "\(Xmpp_MyDomain)"
        let jd = XMPPJID(string: strUser)
        
        //Blocking Managment
        self.xmppBlocking = XMPPBlocking()
        self.xmppBlocking!.autoRetrieveBlockingListItems = true
        self.xmppBlocking!.autoClearBlockingListInfo = true;
        self.xmppBlocking!.addDelegate(self, delegateQueue: DispatchQueue.main)
        self.xmppBlocking!.activate(self.xmppStream)
        self.xmppBlocking?.retrieveBlockingListItems()

        xmppBlocking?.blockJID(jd)

    }
    
    func xmpp_UnBlockUserWithJid(userId: String?) {
        
        let strUser = userId! + "\(Xmpp_MyDomain)"
        let jd = XMPPJID(string: strUser)
        
        //Unblocking Managment
        self.xmppBlocking = XMPPBlocking()
        self.xmppBlocking!.autoRetrieveBlockingListItems = true
        self.xmppBlocking!.autoClearBlockingListInfo = true;
        self.xmppBlocking!.addDelegate(self, delegateQueue: DispatchQueue.main)
        self.xmppBlocking!.activate(self.xmppStream)
        self.xmppBlocking?.retrieveBlockingListItems()

        xmppBlocking?.unblockJID(jd)

    }
    
    public func xmppBlocking(_ sender: XMPPBlocking!, didBlockJID xmppJID: XMPPJID!){
             //Successfully blocked
        print("didBlockJID")
    }

    public func xmppBlocking(_ sender: XMPPBlocking!, didNotBlockJID xmppJID: XMPPJID!, error: Any!){
        print("didNotBlockJID")
        if(error is NSError){
                  //print error message
            print(error)
        }
    }

    public func xmppBlocking(_ sender: XMPPBlocking!, didReceivedBlockingList blockingList: [Any]!) {
        print("didReceivedBlockingList")
        //Received blocked list in this delegate method
    }

     public func xmppBlocking(_ sender: XMPPBlocking!, didUnblockJID xmppJID: XMPPJID!) {
            print("didUnblockJID")
      }

      public func xmppBlocking(_ sender: XMPPBlocking!, didNotUnblockJID xmppJID: XMPPJID!, error: Any!) {
        print("didNotUnblockJID")
          if(error is NSError){
            print(error)
          }
      }
    
    func addID(_ elementID: String?, block: @escaping (_ obj: Any?, _ info: XMPPTrackingInfo?) -> Void, timeout: TimeInterval) {
//        AssertProperQueue()

        var trackingInfo: XMPPBasicTrackingInfo?
        trackingInfo = XMPPBasicTrackingInfo(block: block, timeout: timeout)

        addID(elementID, trackingInfo: trackingInfo)
    }
    
    func addID(_ elementID: String?, trackingInfo: XMPPTrackingInfo?) {
//        AssertProperQueue()

//        dict[elementID ?? ""] = trackingInfo

        trackingInfo?.elementID = elementID!
//        trackingInfo?.createTimer(withDispatchQueue: queue)
    }
    
    func xmpp_RemoveFriend(withJid friendID: String?) {

        if !xmppStream.isConnected {
            return
        }
        //friendID =10@localhost
        //[xmppRoster subscribePresenceToUser:[XMPPJID jidWithString:[friendID stringByAppendingString:MyDomain]]];
        //[xmppRoster addUser:[XMPPJID jidWithString:friendID] withNickname:friendID];
        
        let jd = XMPPJID(string: friendID!)
        
        xmppRoster.removeUser(jd!)
        xmppRoster.unsubscribePresence(fromUser: jd!)
        
        self.xmpp_getFriendList()
    }
    
    func xmpp_RemoveSingleObject(withMessageId MsgID: String?, withToUserId toUserID: String?, obj : Model_ChatMessage) {

        let jd = XMPPJID(string: toUserID!)
        let context = CoreDataManager.sharedManager.managedContext()
        let arrSkChats = xmpp_FetchSingleArchivingObject(MsgID, with: jd!)

        (arrSkChats as NSArray).enumerateObjects({ skChat, idx, stop in
            if let messageObject = (skChat as? NSManagedObject) {
                let jsonStr = Chat_Utility.getOneToOneMsgBody(objChat: obj)
                print(jsonStr)
                SOXmpp.manager.xmpp_SendMessage(bodyData: jsonStr, objMsg: obj)
                context.delete(messageObject)
            }
        })

        do {
            try context.save()
        } catch {
        }
    }

        func xmpp_FetchSingleArchivingObject(_ MessageId: String?, with toUserID: XMPPJID) -> NSArray {

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
            let context = CoreDataManager.sharedManager.managedContext()
            //let context = self.xmppCoreDataStorage.managedObjectContext!
            
            let messageEntity: NSEntityDescription = NSEntityDescription.entity(forEntityName:   "XMPP_MessageArchiving_Custom", in: context)!
            
            fetchRequest.entity = messageEntity
            //fetchRequest.fetchOffset = pageOffset
            //fetchRequest.fetchLimit = pageSize
        
            let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
             let predicate1 =  NSPredicate(format: "streamBareJidStr = %@","\(self.xmppStream.myJID!.bare)")
            let predicate2 =  NSPredicate(format: "bareJidStr = %@","\(toUserID.bare)")
            let predicateCompound = NSCompoundPredicate.init(type: .and, subpredicates: [predicate1,predicate2])
            fetchRequest.predicate = predicateCompound
            //fetchRequest.predicate = NSPredicate(format: "(fromAppID = %@) AND (toAppID = %@)","\(self.xmppStream.myJID!.user!)\(toUserID.user!)")
        
            do {
                var result = try context.fetch(fetchRequest)
                guard var filteredResult = result as? [XMPP_MessageArchiving_Custom] else {
                    return []
                }
                
                result = (result as NSArray).filtered(using: NSPredicate(block: { evaluatedObject, bindings in
                    if (evaluatedObject as! XMPP_MessageArchiving_Custom).messageId == MessageId! {
                        return true
                    }
                    return false

                }))
                
                return result as NSArray
            } catch {
                print(error.localizedDescription)
            }
        
            return []
        }
    
    func fetchArchieveingAfterDeleteMsg(){
        NotificationCenter.default.post(name: Notification_RefreshChatAfterDelete, object: nil, userInfo: nil)
    }
}

