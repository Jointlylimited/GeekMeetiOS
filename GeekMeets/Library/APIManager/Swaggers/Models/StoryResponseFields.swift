//
// StoryResponseFields.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct StoryResponseFields: Codable {

    public var iStoryId: Int?
    public var iUserId: Int?
    public var txStory: String?
    public var tiStoryType: Int?
    public var vThumbnail: String?
    public var dbTotalViews: String?
    public var vName: String?
    public var vProfileImage: String?
    public var tiIsView: Int?
    public var iCreatedAt: String?

    public init(iStoryId: Int?, iUserId: Int?, txStory: String?, tiStoryType: Int?, vThumbnail: String?, dbTotalViews: String?, vName: String?, vProfileImage: String?, tiIsView: Int?, iCreatedAt: String?) {
        self.iStoryId = iStoryId
        self.iUserId = iUserId
        self.txStory = txStory
        self.tiStoryType = tiStoryType
        self.vThumbnail = vThumbnail
        self.dbTotalViews = dbTotalViews
        self.vName = vName
        self.vProfileImage = vProfileImage
        self.tiIsView = tiIsView
        self.iCreatedAt = iCreatedAt
    }


}

