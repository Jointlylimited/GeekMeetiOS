//
// BlockUserFields.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct BlockUserFields: Codable {

    public var iUserId: Int?
    public var vName: String?
    public var vProfileImage: String?

    public init(iUserId: Int?, vName: String?, vProfileImage: String?) {
        self.iUserId = iUserId
        self.vName = vName
        self.vProfileImage = vProfileImage
    }


}

