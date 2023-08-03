//
//  Model_ChatFriendList.swift
//  xmppchat
//
//  Created by SOTSYS255 on 07/01/20.
//  Copyright © 2020 SOTSYS255. All rights reserved.
//

import Foundation
import XMPPFramework

struct Model_ChatFriendList: Equatable {
    
    var vCard:XMPPvCardTemp?
    var jID: String = ""
    var xmppJID: XMPPJID?
    
    var name: String = ""
    var imagUrl: String = ""
    
    var lastMsg: String = ""
    var userStatus: String = xmpp_User_offline
    
    var objMessage: Model_ChatMessage?
    
    var lastSeenSeconds: String = ""
    var lastSeenDate: Date?
    
    init() {
    }
    
    init(_vCard: XMPPvCardTemp) {
        self.init()
        self.vCard = _vCard
        self.xmppJID = _vCard.jid
        self.name = _vCard.nickname ?? ""
        self.jID = _vCard.jid?.bare ?? ""
    }
    
    static func == (lhs: Model_ChatFriendList, rhs: Model_ChatFriendList) -> Bool {
        return lhs.jID == rhs.jID
    }
    
}
