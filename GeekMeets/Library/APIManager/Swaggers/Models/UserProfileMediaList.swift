//
// UserProfileMediaList.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct UserProfileMediaList: Codable {

    public var iMediaId: Int?
    public var vMedia: String?
    public var tiMediaType: Int?
    public var fHeight: Double?
    public var fWidth: Double?
    public var tiIsDefault: Int?
    public var reaction: [MediaReaction]?

    public init(iMediaId: Int?, vMedia: String?, tiMediaType: Int?, fHeight: Double?, fWidth: Double?, tiIsDefault: Int?, reaction: [MediaReaction]?) {
        self.iMediaId = iMediaId
        self.vMedia = vMedia
        self.tiMediaType = tiMediaType
        self.fHeight = fHeight
        self.fWidth = fWidth
        self.tiIsDefault = tiIsDefault
        self.reaction = reaction
    }


}

