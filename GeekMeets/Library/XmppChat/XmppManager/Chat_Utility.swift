//
//  Chat_Utility.swift
//  xmppchat
//
//  Created by SOTSYS255 on 08/01/20.
//  Copyright © 2020 SOTSYS255. All rights reserved.
//

import Foundation
import XMPPFramework
import Photos


let kisUserLoggedIn: String = "kisUserLoggedIn"
let kLoggedInUserDATA: String = "kLoggedInUserDATA"

let MAX_VIDEO_SIZE: Double = 100.0

public enum XMPP_Message_Type: Int {

    case text           //0
    case image          //1
    case video          //2
    case audio          //3
    case contact        //4
    case location       //5
    case logCall        //6
    case logRoom        //7
    case document       //8
    case videoUpdated   //9
    case imageUpdated   //10
    case audioUpdated   //11
    case videoCalling   //12
    case audioCalling   //13
    case sticker        //14
    case documentUpdated//15
    case gif
//    func GetText() -> String {
//        switch self {
//        case .text: return ""
//        case .video: return ""
//        case .image: return ""
//        case .audio: return ""
//        case .contact: return ""
//        case .location: return ""
//        case .logCall: return ""
//        case .logRoom: return ""
//        case .sticker: return ""
//        case .videoUpdated: return ""
//        case .imageUpdated: return ""
//        case .audioUpdated: return ""
//        case .videoCalling: return ""
//        case .audioCalling: return ""
//        case .document: return ""
//        case .documentUpdated: return ""
//        default: return ""
//        }
//    }
}


public enum XMPP_Message_Status: Int16 {
    case pending = 0   //0
    case sent          //1
    case delivered     //2
    case read          //3
}

public struct XMPP_Message_Key {
    private init() {}
    
    static let msgDetail = "msgDetail"
    static let messageType = "messageType"
    static let messageDesc = "messageDesc"
    static let message = "message"
    static let messageId = "messageId"
    static let messageDate = "messageDate"
    static let from = "from"
    static let to = "to"
    static let duration = "duration"
    static let fromGroup = "fromGroup"
    static let thumbUrl = "thumbUrl"
    static let url = "url"
}

struct Chat_Utility {
    
    private init() {}
    static func timeStamp() -> String {
        let _timeStamp = Date().timeIntervalSince1970
        return  "\(NSNumber.init(value: _timeStamp).int64Value)"//String.init(format: "%0f", _timeStamp)
    }
    
    static func getOneToOneMsgBody(objChat: Model_ChatMessage)-> String {
        
        
        var dictText = [String: String]()
        dictText[XMPP_Message_Key.message] = objChat.strMsg ?? ""
        
        var dict = [String: Any]()
        
        dict[XMPP_Message_Key.messageDesc] = dictText
        
        dict[XMPP_Message_Key.messageType] = objChat.msgType!
        dict[XMPP_Message_Key.message] =  objChat.strMsg ?? ""
                
        dict[XMPP_Message_Key.messageId] =  objChat.messageId
        dict[XMPP_Message_Key.messageDate] = objChat.messageDate
    
        dict[XMPP_Message_Key.from] =  objChat.FromJID?.user!
        dict[XMPP_Message_Key.to] =  objChat.ToJID?.user!
                
        dict[XMPP_Message_Key.duration] =  "0"
        dict[XMPP_Message_Key.fromGroup] = "false"
        dict[XMPP_Message_Key.thumbUrl] = objChat.thumbUrl
        dict[XMPP_Message_Key.url] = objChat.url
        
        
        let param = self.getJsonString(from: dict)
        return param
        
        /*
        switch XMPP_Message_Type.init(rawValue: objChat.msgType!) {
        case .text:
            
            var dictText = [String: String]()
            dictText[XMPP_Message_Key.message] = objChat.strMsg!
            
            dict[XMPP_Message_Key.messageDesc] = dictText
            
            dict[XMPP_Message_Key.messageType] = XMPP_Message_Type.text.rawValue
            dict[XMPP_Message_Key.message] =  objChat.strMsg!
            
            dict[XMPP_Message_Key.messageId] =  objChat.messageId
            dict[XMPP_Message_Key.messageDate] = objChat.messageDate
            
            dict[XMPP_Message_Key.from] =  objChat.FromJID?.user!
            dict[XMPP_Message_Key.to] =  objChat.ToJID?.user!
            
            dict[XMPP_Message_Key.duration] =  "0"
            dict[XMPP_Message_Key.fromGroup] = "false"
            dict[XMPP_Message_Key.thumbUrl] =    ""
            dict[XMPP_Message_Key.url] =    ""
            
            break
        case .image:
    
            var dictText = [String: String]()
            dictText[XMPP_Message_Key.message] = objChat.strMsg!
            dict[XMPP_Message_Key.messageDesc] = dictText
    
            dict[XMPP_Message_Key.messageType] = XMPP_Message_Type.image.rawValue
            dict[XMPP_Message_Key.message] =  ""
            
            dict[XMPP_Message_Key.messageId] =  objChat.messageId
            dict[XMPP_Message_Key.messageDate] = objChat.messageDate
            
            dict[XMPP_Message_Key.from] =  objChat.FromJID?.user!
            dict[XMPP_Message_Key.to] =  objChat.ToJID?.user!
            
            dict[XMPP_Message_Key.duration] =  "0"
            dict[XMPP_Message_Key.fromGroup] = "false"
            dict[XMPP_Message_Key.thumbUrl] = objChat.thumbUrl
            dict[XMPP_Message_Key.url] = objChat.url
    
            break
        case .video:
            
            var dictText = [String: String]()
            dictText[XMPP_Message_Key.message] = objChat.strMsg!
            dict[XMPP_Message_Key.messageDesc] = dictText
    
            dict[XMPP_Message_Key.messageType] = XMPP_Message_Type.video.rawValue
            dict[XMPP_Message_Key.message] =  ""
            
            dict[XMPP_Message_Key.messageId] =  objChat.messageId
            dict[XMPP_Message_Key.messageDate] = objChat.messageDate
            
            dict[XMPP_Message_Key.from] =  objChat.FromJID?.user!
            dict[XMPP_Message_Key.to] =  objChat.ToJID?.user!
            
            dict[XMPP_Message_Key.duration] =  "0"
            dict[XMPP_Message_Key.fromGroup] = "false"
            dict[XMPP_Message_Key.thumbUrl] = objChat.thumbUrl
            dict[XMPP_Message_Key.url] = objChat.url
            break
            
        case .document:
            
            var dictText = [String: String]()
            dictText[XMPP_Message_Key.message] = objChat.strMsg!
            dict[XMPP_Message_Key.messageDesc] = dictText
    
            dict[XMPP_Message_Key.messageType] = XMPP_Message_Type.document.rawValue
            dict[XMPP_Message_Key.message] =  ""
            
            dict[XMPP_Message_Key.messageId] =  objChat.messageId
            dict[XMPP_Message_Key.messageDate] = objChat.messageDate
            
            dict[XMPP_Message_Key.from] =  objChat.FromJID?.user!
            dict[XMPP_Message_Key.to] =  objChat.ToJID?.user!
            
            dict[XMPP_Message_Key.duration] =  "0"
            dict[XMPP_Message_Key.fromGroup] = "false"
            dict[XMPP_Message_Key.thumbUrl] = objChat.thumbUrl
            dict[XMPP_Message_Key.url] = objChat.url
            break
        default: return ""
        }
        let param = self.getJsonString(from: dict)
        return param
 */
    }
    
    
    static func getJsonString(from dictionary: [String: Any]) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                return JSONString
            }
            
            return ""
        }
        catch {
            return ""
        }
    }
    
    
    static let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    
    static func SaveImageToDocumentDirectory(image: UIImage) -> (URL?,NSError?) {
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
            return (nil, error)
        }
        
        let fileName: String = ProcessInfo.processInfo.globallyUniqueString + (".jpeg")
        
        let fileUrl = Chat_Utility.documentsPath.appendingPathComponent(fileName)
        
        do {
            try imageData.write(to: fileUrl)
            return (fileUrl, nil)
        } catch {
            let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
            return (nil, error)
        }
        
    }
    
    
    static func Save_Media_ToDocumentDirectory(mediaType: XMPP_Message_Type , data: Data) -> (URL?,NSError?) {
        
        var fileUrl: URL?
        
        if mediaType == .image {
            let fileName: String = ProcessInfo.processInfo.globallyUniqueString + (".jpeg")
            fileUrl = Chat_Utility.documentsPath.appendingPathComponent(fileName)
        } else if mediaType == .video {
            let fileName: String = ProcessInfo.processInfo.globallyUniqueString + (".mov")
            fileUrl = Chat_Utility.documentsPath.appendingPathComponent(fileName)
        } else if mediaType == .document {
            let fileName: String = ProcessInfo.processInfo.globallyUniqueString + (".pdf")
            fileUrl = Chat_Utility.documentsPath.appendingPathComponent(fileName)
        } else if mediaType == .gif {
            let fileName: String = ProcessInfo.processInfo.globallyUniqueString + (".gif")
            fileUrl = Chat_Utility.documentsPath.appendingPathComponent(fileName)
        }
        
        do {
            try data.write(to: fileUrl!)
            return (fileUrl!, nil)
        } catch {
            let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
            return (nil, error)
        }
        
    }
    
    static func DeleteItemFromDocumentDirectory(path: URL) {
        do {
            try FileManager.default.removeItem(at: path)
        } catch let error {
            print("Error while deleting item from document directory === \(error.localizedDescription)")
        }
    }
    
    
    static func checkCameraAccess(view: UIViewController, completion: @escaping ((Bool) -> Void)) {
        
        let permissionStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch permissionStatus {
        case .authorized:
            return completion(true)
            
        case .denied,.restricted:
            
            let alert = UIAlertController(title: "Camera Access", message: "Allow camera access", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { action in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            view.present(alert, animated: true)
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    return completion(true)
                }
            })
        default:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    return completion(true)
                }
            })
        }
    }

    static func checkGalleryAccess(view: UIViewController, complition: @escaping ((Bool) -> Void)) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    complition(true)
                }
            })
        case .denied,.restricted:
            let alert = UIAlertController(title: "Photo's Access", message: "Allow photo's access", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { action in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            view.present(alert, animated: true)
        default:
            complition(true)
        }
    }
    
}




//extension String {
//    var bool: Bool? {
//        switch self.lowercased() {
//        case "true", "t", "yes", "y", "1":
//            return true
//        case "false", "f", "no", "n", "0":
//            return false
//        default:
//            return nil
//        }
//    }
//}

