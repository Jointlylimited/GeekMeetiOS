//
//  XMPP_MessageArchiving_Custom+CoreDataProperties.swift
//  xmppchat
//
//  Created by SOTSYS255 on 31/01/20.
//  Copyright © 2020 SOTSYS255. All rights reserved.
//
//

import Foundation
import CoreData
import CoreLocation


extension XMPP_MessageArchiving_Custom {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<XMPP_MessageArchiving_Custom> {
        return NSFetchRequest<XMPP_MessageArchiving_Custom>(entityName: "XMPP_MessageArchiving_Custom")
    }

    @NSManaged public var bareJid: NSObject?
    @NSManaged public var bareJidStr: String?
    @NSManaged public var body: String?
    @NSManaged public var composing: NSNumber?
    @NSManaged public var downloading: NSNumber?
    @NSManaged public var error: NSNumber?
    @NSManaged public var fromAppID: String?
    @NSManaged public var fromJID: NSObject?
    @NSManaged public var localPath: String?
    @NSManaged public var mediaData: NSObject?
    @NSManaged public var message: NSObject?
    @NSManaged public var messageId: String?
    @NSManaged public var messageStr: String?
    @NSManaged public var messageType: Int16
    @NSManaged public var msgStatus: Int16
    @NSManaged public var outgoing: NSNumber?
    @NSManaged public var streamBareJidStr: String?
    @NSManaged public var thread: String?
    @NSManaged public var thumbLocalUrl: String?
    @NSManaged public var thumbUrl: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var toAppID: String?
    @NSManaged public var toJID: NSObject?
    @NSManaged public var uploading: NSNumber?
    @NSManaged public var url: String?
    @NSManaged public var messageDate: String?
}
