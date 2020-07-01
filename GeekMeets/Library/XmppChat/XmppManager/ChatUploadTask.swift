//
//  ChatUploadTask.swift
//  xmppchat
//
//  Created by SOTSYS255 on 18/01/20.
//  Copyright © 2020 SOTSYS255. All rights reserved.
//


import Foundation
import UIKit

protocol ChatUploadTaskDelegate: class {
    func progress( progress: Double , objChatMsg: Model_ChatMessage)
    func UploadCompleted( CompletionData: Any? , error: Error? , objChatMsg: Model_ChatMessage)
}

struct Model_UploadMedia {
    let data: Data
    let msgType: XMPP_Message_Type
    
    init(msgType: XMPP_Message_Type , data: Data) {
        self.msgType = msgType
        self.data = data
    }
}

class ChatUploadTask {

    // MARK: - Variables And Properties
    //
    var isUploading = false
    var progress: Double = 0
    var resumeData: Data?
    var uploaded = false
    var objChat: Model_ChatMessage
    var localPath: URL
    var image : UIImage?
    var progressCallback: progressBlock?
    var completionCallback: completionBlock?
    
    weak var delegate: ChatUploadTaskDelegate?
    
    //
    // MARK: - Initialization
    //
    init(objChat: Model_ChatMessage , localPath: URL) {
        self.objChat = objChat
        self.localPath = localPath
        
        self.progressCallback = { _progress in
            self.progress = _progress
            self.delegate?.progress(progress: self.progress, objChatMsg: self.objChat)
        }
        
        self.completionCallback = { _data,error in
            
            print("============== ChatUploadTask = completionCallback")
            
            if error != nil {
                self.objChat.isUploading = false
                self.objChat.isError = true
                XMPP_MessageArchiving_Custom.UpdateMessage(obj: objChat)
                
                print("Uploaded Error: \(error?.localizedDescription ?? "")")
                
                self.delegate?.UploadCompleted(CompletionData: _data, error: error, objChatMsg: self.objChat)
                return
            }
            
            self.objChat.thumbUrl = _data! as! String
            self.objChat.url = _data! as! String
            self.objChat.body = (_data! as! String)
            self.objChat.strMsg = (_data! as! String)
            self.objChat.isUploading = false
//            self.objChat.image = (_data! as! UIImage)
            let jsonStr = Chat_Utility.getOneToOneMsgBody(objChat: self.objChat)
            print(jsonStr)
            
            XMPP_MessageArchiving_Custom.UpdateMessage(obj: objChat)
            
            self.delegate?.UploadCompleted(CompletionData: _data, error: error, objChatMsg: self.objChat)
            
            SOXmpp.manager.xmpp_SendMessage(bodyData: jsonStr, objMsg: self.objChat)

        }
        
    }
    
}

