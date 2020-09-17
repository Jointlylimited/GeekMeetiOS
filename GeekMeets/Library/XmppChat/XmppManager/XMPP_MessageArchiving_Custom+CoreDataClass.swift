//
//  XMPP_MessageArchiving_Custom+CoreDataClass.swift
//  xmppchat
//
//  Created by SOTSYS255 on 17/01/20.
//  Copyright © 2020 SOTSYS255. All rights reserved.
//
//

import Foundation
import CoreData
import XMPPFramework

@objc(XMPP_MessageArchiving_Custom)
public class XMPP_MessageArchiving_Custom: NSManagedObject {

    var isOutgoing: Bool {
        get {
            return Bool(truncating: outgoing!)
        }
        set {
            outgoing = NSNumber(value: newValue)
        }
    }
    var isComposing: Bool {
        get {
            return Bool(truncating: composing!)
        }
        set {
            composing = NSNumber(value: newValue)
        }
    }
    var isDownloading: Bool {
        get {
            return Bool(truncating: downloading!)
        }
        set {
            downloading = NSNumber(value: newValue)
        }
    }
    var isUploading: Bool {
        get {
            return Bool(truncating: uploading!)
        }
        set {
            uploading = NSNumber(value: newValue)
        }
    }
    var isError: Bool {
        get {
            return Bool(truncating: error!)
        }
        set {
            error = NSNumber(value: newValue)
        }
    }
    
    
    class func InsertMessage(obj: Model_ChatMessage) {
        
        let context = CoreDataManager.sharedManager.managedContext()
        let managedObj = XMPP_MessageArchiving_Custom(context: context)
        
        let messageJid = obj.isOutgoing ? obj.ToJID : obj.FromJID
        managedObj.body = obj.strMsg
        
        managedObj.bareJid = messageJid?.bareJID
        managedObj.bareJidStr = messageJid?.bareJID.bare
        
        managedObj.fromJID = obj.FromJID
        managedObj.toJID = obj.ToJID
        
        managedObj.fromAppID = obj.fromAppID
        managedObj.toAppID = obj.ToAppID
        
        managedObj.streamBareJidStr = SOXmpp.manager.xmppStream.myJID?.bare
        managedObj.timestamp = obj.timestamp
        managedObj.messageDate = obj.messageDate
        
        managedObj.isOutgoing = obj.isOutgoing
        managedObj.isComposing = false
        managedObj.messageStr = obj.strMsg
        managedObj.messageType = Int16.init(exactly: NSNumber.init(value: obj.msgType!))!
        managedObj.messageId = obj.messageId
        managedObj.isUploading = obj.isUploading
        managedObj.isDownloading = obj.isDownloading
        managedObj.isError = obj.isError
        managedObj.localPath = obj.localPath
        managedObj.url = obj.url
        managedObj.thumbUrl = obj.thumbUrl
//        managedObj.location = obj.location ?? CLLocation(latitude: CLLocationDegrees(exactly: 0.0)!, longitude: CLLocationDegrees(exactly: 0.0)!)
        
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    class func UpdateMessage(obj: Model_ChatMessage) {
        
        let context = CoreDataManager.sharedManager.managedContext()
        
        let fetchRequest: NSFetchRequest =  NSFetchRequest<NSFetchRequestResult>.init()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "XMPP_MessageArchiving_Custom", in: context)
        fetchRequest.predicate = NSPredicate(format: "messageId = %@","\(obj.messageId)")
        
        do {

            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                
                let managedObj = results.first as! XMPP_MessageArchiving_Custom
                
                //            managedObj.timestamp = obj.timestamp
                //            managedObj.isOutgoing = obj.isOutgoing
                //            managedObj.isComposing = false
                //            managedObj.messageStr = obj.strMsg
                //            managedObj.messageType = Int16.init(exactly: NSNumber.init(value: obj.msgType!))!
                //            managedObj.messageId = obj.messageId
                
                managedObj.isUploading = obj.isUploading
                managedObj.isDownloading = obj.isDownloading
                managedObj.isError = obj.isError
                managedObj.thumbLocalUrl = obj.thumbLocalUrl
                managedObj.url = obj.url
                managedObj.thumbUrl = obj.thumbUrl
                managedObj.msgStatus = obj.msgStatus
//                managedObj.location = obj.location ?? CLLocation(latitude: CLLocationDegrees(exactly: 0.0)!, longitude: CLLocationDegrees(exactly: 0.0)!)
                do {
                    try context.save()
                    print("update!")
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
            } else {
                print("  ============= message not found ")
                return
            }

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    class func RemoveMessage(obj: Model_ChatMessage) {
        
        let context = CoreDataManager.sharedManager.managedContext()
        
        let fetchRequest: NSFetchRequest =  NSFetchRequest<NSFetchRequestResult>.init()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "XMPP_MessageArchiving_Custom", in: context)
        fetchRequest.predicate = NSPredicate(format: "messageId = %@","\(obj.messageId)")
        
        do {
            
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                
                let managedObj = results.first as! XMPP_MessageArchiving_Custom
                context.delete(managedObj)
                do {
                    try context.save()
                    print("update!")
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
            } else {
                print("  ============= message not found ")
                return
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    class func xmpp_FetchSingleArchivingObject(_ MessageId: String?, with toUserID: XMPPJID) -> NSArray {

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
    
        let context = CoreDataManager.sharedManager.managedContext()
        //let context = self.xmppCoreDataStorage.managedObjectContext!
        
        let messageEntity: NSEntityDescription = NSEntityDescription.entity(forEntityName:   "XMPP_MessageArchiving_Custom", in: context)!
        
        fetchRequest.entity = messageEntity
        //fetchRequest.fetchOffset = pageOffset
        //fetchRequest.fetchLimit = pageSize
    
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate1 =  NSPredicate(format: "streamBareJidStr = %@","\(toUserID.bare)")
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
    
    class func fetchMessageObj(with messageId: String) -> Model_ChatMessage? {
        
        let context = CoreDataManager.sharedManager.managedContext()
        
        let fetchRequest: NSFetchRequest =  NSFetchRequest<NSFetchRequestResult>.init()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "XMPP_MessageArchiving_Custom", in: context)
        //fetchRequest.predicate = NSPredicate(format: "messageId = %@","\(messageId)")
        let predicate2 = NSPredicate(format: "messageId = %@","\(messageId)")
        let predicate1 =  NSPredicate(format: "streamBareJidStr = %@","\(SOXmpp.manager.xmppStream.myJID!.bare)")
        //let predicate2 =  NSPredicate(format: "bareJidStr = %@","\(toUserID.bare)")
        let predicateCompound = NSCompoundPredicate.init(type: .and, subpredicates: [predicate1,predicate2])
        fetchRequest.predicate = predicateCompound
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                let obj =  results.first as! XMPP_MessageArchiving_Custom
                return Model_ChatMessage.init(xmppMessageObj: obj)
            } else {
                print("  ============= message not found ")
                return nil
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    class func ResetUplodingMessage() {
        
        let context = CoreDataManager.sharedManager.managedContext()
        
        let fetchRequest: NSFetchRequest =  NSFetchRequest<NSFetchRequestResult>.init()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "XMPP_MessageArchiving_Custom", in: context)
        fetchRequest.predicate = NSPredicate(format: "uploading = %@", NSNumber(value: true))
        
        do {

            let results = try context.fetch(fetchRequest)
            for item in results {
                let managedObj = item as! XMPP_MessageArchiving_Custom
                managedObj.isError = true
                managedObj.isUploading = false
                
                do {
                    try context.save()
                    print("update isUploading!")
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
