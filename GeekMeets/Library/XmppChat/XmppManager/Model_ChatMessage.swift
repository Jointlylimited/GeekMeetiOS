//
//  Model_ChatMessage.swift
//  xmppchat
//
//  Created by SOTSYS255 on 08/01/20.
//  Copyright © 2020 SOTSYS255. All rights reserved.
//

import UIKit
import XMPPFramework
import CoreLocation

class Model_ChatMessage {
    
    var autoIncrementedID: Int = 0
    
    var messageObject: XMPPMessage?
    //var isDelivered: Bool = false
    //var isRead: Bool = false
    var msgStatus: Int16 = 0
    
//    var isFileAvailable: Bool? = false
//    var isRemainingToUpload: Bool? = false
//    var isUpdatedURL: Bool? = false
//    var isVideoCallMsg: Bool? = false

    var bareAppID: String?
    
    var fromAppID: String?
    var ToAppID: String?
   
    var FromJID: XMPPJID?
    var ToJID: XMPPJID?
    
    //var dicBody: NSDictionary?
    
    var _ID: String?
    var strMsg: String?
    var body: String?
    var msgType : NSInteger?
    
    var timestamp: Date!
    var messageId: String = ""
    var messageDate: String = ""
    
    var isOutgoing: Bool = false
    var thumbUrl: String = ""
    var url: String = ""
    var duration: String = ""
    
    var fromGroup: Bool = false
    var isDownloading: Bool = false
    var isUploading: Bool = false
    var isError: Bool = false
    
    var thumbLocalUrl: String?
    var localPath: String?
    var thumbnailData: Data?
    var location : CLLocation?
    
    //Added by Divya
    var imgProfileURL : String?
    var isForRemove: Bool = false
    
    init() {
    
    }
    
    //var completionCallback: completionBlock?
    
    convenience init(xmppMessageObj: XMPPMessage) {
        self.init()
        
        messageObject = xmppMessageObj
        
        _ID = messageObject?.attributeStringValue(forName: "id")
        body = messageObject?.attributeStringValue(forName: "body")
        //msg property
        //timestamp = Date.init()
        isOutgoing = false
        
        FromJID = xmppMessageObj.from
        ToJID = xmppMessageObj.to
        
        fromAppID = xmppMessageObj.from?.bare
        ToAppID = xmppMessageObj.to?.bare
        
//        guard let msgDetails = xmppMessageObj.element(forName: "msgDetail")?.stringValue, let data = msgDetails.data(using: .utf8) else {
//            print(" msgDetail ====  field not found    ")
//            return
//        }
        guard let data = xmppMessageObj.subject!.data(using: .utf8) else {
            print("subject ====  field not found")
            return
        }
        do {
            
            let msgDetailInfo = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: Any]
            
            let msgDetailStr = msgDetailInfo[XMPP_Message_Key.msgDetail] as? String ?? ""
            
            guard let msgDetailData = msgDetailStr.data(using: .utf8)  else {
                print("msgDetail ====  field not found")
                return
            }
            
            let _dicInfo = try JSONSerialization.jsonObject(with: msgDetailData, options: .mutableLeaves) as! [String: Any]
            
            let _type = _dicInfo[XMPP_Message_Key.messageType] as! NSNumber
            
            msgType = _type.intValue
            strMsg = _dicInfo[XMPP_Message_Key.message] as? String
            
            messageId = _dicInfo[XMPP_Message_Key.messageId] as! String
            let msgDate =  String.init(describing: _dicInfo[XMPP_Message_Key.messageDate]!)
            timestamp =  ST_DateFormater.Get_Date(Date.init(timeIntervalSince1970: TimeInterval.init(msgDate)!))//
            messageDate = msgDate
            
            duration = _dicInfo[XMPP_Message_Key.duration] as? String ?? ""
            fromGroup = "\(_dicInfo[XMPP_Message_Key.fromGroup] ?? "0")".bool ?? false
            
            thumbUrl = _dicInfo[XMPP_Message_Key.thumbUrl] as? String ?? ""
            url = _dicInfo[XMPP_Message_Key.url] as? String ?? ""
            isForRemove = _dicInfo[XMPP_Message_Key.isForRemove] as? Bool ?? false
        } catch let error {
            print(error.localizedDescription)
        }
        //print(messageObj.message.attributesAsDictionary())
        //print(messageObj.body)
        
    }
    
    convenience init(xmppMessageObj: XMPP_MessageArchiving_Custom) {
        self.init()
        messageObject = xmppMessageObj.message as? XMPPMessage
        
        //isDelivered = messageObj.attributeBoolValue(forName: xmppKey_IsDelivered)
        //isRead = messageObj.attributeBoolValue(forName: xmppKey_IsRead)
        
        _ID = xmppMessageObj.messageId
        body = xmppMessageObj.body
        //msg property
        timestamp = xmppMessageObj.timestamp!
        isOutgoing = xmppMessageObj.isOutgoing
        messageId = xmppMessageObj.messageId!
        
        timestamp = xmppMessageObj.timestamp!
        messageDate = xmppMessageObj.messageDate ?? ""
        
        fromAppID = xmppMessageObj.fromAppID
        ToAppID = xmppMessageObj.toAppID
        
        FromJID = xmppMessageObj.fromJID as? XMPPJID
        ToJID = xmppMessageObj.toJID as? XMPPJID
        
        msgType = NSInteger.init(exactly: NSNumber.init(value: xmppMessageObj.messageType))
        
        strMsg = xmppMessageObj.body
        isUploading  = xmppMessageObj.isUploading
        isDownloading  = xmppMessageObj.isDownloading
        isError  = xmppMessageObj.isError
        localPath  = xmppMessageObj.localPath
        url  = xmppMessageObj.url ?? ""
        thumbUrl  = xmppMessageObj.thumbUrl ?? ""
        thumbLocalUrl  = xmppMessageObj.thumbLocalUrl
        msgStatus = xmppMessageObj.msgStatus
        imgProfileURL = xmppMessageObj.thumbUrl ?? ""
    }
    
    func getLocalPath() -> URL? {
        if let localPath = self.localPath , localPath.count > 0 {
            let lastPath = URL(fileURLWithPath: localPath).lastPathComponent
            let _url = Chat_Utility.documentsPath.appendingPathComponent(lastPath)
            return _url
        }
        return nil
    }
    
    func getThumbLocalPath() -> URL? {
        if let localPath = self.thumbLocalUrl , localPath.count > 0 {
            let lastPath = URL(fileURLWithPath: localPath).lastPathComponent
            let _url = Chat_Utility.documentsPath.appendingPathComponent(lastPath)
            return _url
        }
        return nil
    }
}

class Model_ChatMedia {
   
    var isDownloading: Bool
    var url: URL?
    var thumbUrl: URL?
    var localUrl: String?
    var image: UIImage?
    var videoData: Data?
    
    init(downloading: Bool) {
        self.isDownloading = downloading
    }
}

struct ST_DateFormater {
    
    private init() {}
    static var UTC_DateFormater: DateFormatter = {
        let formatter = DateFormatter.init()
        formatter.dateFormat =  "dd MMM YYYY, hh:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    static var local_DateFormater: DateFormatter = {
        let formater = DateFormatter.init()
        formater.dateFormat =  "dd MMM YYYY, hh:mm a"
        formater.timeZone = .current
        formater.locale = Locale.current
        return formater
    }()
    
    private static var DateFormaterForChat: DateFormatter = {
        let dateFormate=DateFormatter()
        dateFormate.locale = .current
        dateFormate.dateFormat="yyyy-MM-dd HH:mm:ss"
        dateFormate.amSymbol = "AM"
        dateFormate.pmSymbol = "PM"
        return dateFormate
    }()

    static func UTCToLocal(_ dateStr:String) -> Date {
        let date = ST_DateFormater.UTC_DateFormater.date(from: dateStr)
        //let strDate = localToUTC_DateFormater.string(from: date!)
        return date!
    }
    
    static func Get_Date(_ date: Date) -> Date {
        ST_DateFormater.DateFormaterForChat.dateFormat = "dd MMMM,yyyy hh:mm a"
        let strDate = ST_DateFormater.DateFormaterForChat.string(from: date)
        return ST_DateFormater.DateFormaterForChat.date(from: strDate)!
    }
    
    static func GetTime(from _date: Date , format: String = "h:mm a") -> String {
        ST_DateFormater.DateFormaterForChat.dateFormat = format
        return ST_DateFormater.DateFormaterForChat.string(from: _date)
    }
    
    static func GetMediumDate(from _date: Date , format: String = "dd MMM,yyyy"/* "h:mm a"*/) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        let time = "\(dateFormatter.string(from: _date))"
        
//        ST_DateFormater.DateFormaterForChat.dateFormat = format
        return time //ST_DateFormater.DateFormaterForChat.string(from: _date)
    }
    
    static func GetFormatedDate(from _date: Date , format: String = "dd/MM/yy") -> String {
        ST_DateFormater.DateFormaterForChat.dateFormat = format
        return ST_DateFormater.DateFormaterForChat.string(from: _date)
    }
}
