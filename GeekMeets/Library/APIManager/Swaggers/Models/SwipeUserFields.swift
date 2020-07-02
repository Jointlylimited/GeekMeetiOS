//
// SwipeUserFields.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct SwipeUserFields: Codable {

    public var iUserId: Int?
    public var iProfileId: Int?
    public var vUserImage: String?
    public var vProfileImage: String?
    public var vUserName: String?
    public var vProfileName: String?
    public var tiSwipeType: Int?
    public var iOtherUserId: Int?
    public var vOtherUserXmpp: String?
    public var vOtherUserXmppPassword: String?
    public var iMatchDateTime: String?
    
    public init(iUserId: Int?, iProfileId: Int?, vUserImage: String?, vProfileImage: String?, vUserName: String?, vProfileName: String?, tiSwipeType: Int?, iOtherUserId: Int?, vOtherUserXmpp: String?, vOtherUserXmppPassword: String?, iMatchDateTime: String?) {
        self.iUserId = iUserId
        self.iProfileId = iProfileId
        self.vUserImage = vUserImage
        self.vProfileImage = vProfileImage
        self.vUserName = vUserName
        self.vProfileName = vProfileName
        self.tiSwipeType = tiSwipeType
        self.iOtherUserId = iOtherUserId
        self.vOtherUserXmpp = vOtherUserXmpp
        self.vOtherUserXmppPassword = vOtherUserXmppPassword
        self.iMatchDateTime = iMatchDateTime
    }
}

