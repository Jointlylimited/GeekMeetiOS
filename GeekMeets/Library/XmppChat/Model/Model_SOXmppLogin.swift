//
//  Model_SOXmppLogin.swift
//  xmppchat
//
//  Created by SOTSYS255 on 02/01/20.
//  Copyright © 2020 SOTSYS255. All rights reserved.
//

import Foundation

struct Model_SOXmppLogin: Codable {
    
    var userID: String
    var password: String
    
    var userName: String?
    var userImage: String?
    
    init(_ userID: String ,_ Name: String,_ userImage: String?) {
        self.userID = userID
        self.password = userID
        self.userName = Name
        self.userImage = userImage
    }
    
    
    static func loginToXmpp() {
        
        guard let objLogin =  Model_SOXmppLogin.loadSavedData() else {
            return
        }
        
        if let UnreadMessageCount = UserDefaults.standard.object(forKey: kxmppUnreadMessageCount) as? [String: Int] {
            SOXmpp.manager._unreadMessageCount = UnreadMessageCount
        }
        
        SOXmpp.manager.Login(objLogin: objLogin) { (status) in
            if status {
                print("XMPP Login done")
                objLogin.saveToLocal()
            } else {
                print("XMPP Login failed")
            }
        }
    }
    
//    static func ReconnectXmpp() {
//
//        guard let objLogin =  Model_SOXmppLogin.loadSavedData() else {
//            return
//        }
//        SOXmpp.manager.Login(objLogin: objLogin) { (status) in
//            if status {
//                print("XMPP Login done")
//            } else {
//                print("XMPP Login failed")
//            }
//        }
//    }
    
    func saveToLocal() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: kLoggedInUserDATA)
        }
    }
    
    static func loadSavedData() -> Model_SOXmppLogin? {
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: kLoggedInUserDATA) as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode(Model_SOXmppLogin.self, from: savedData) {
                return loadedData
            }
        }
        return nil
    }
    
}
