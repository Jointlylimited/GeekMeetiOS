//
// SearchUsers.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct SearchUsers: Codable {

    public var responseCode: Int?
    public var responseMessage: String?
    public var responseData: [SearchUserFields]?

    public init(responseCode: Int?, responseMessage: String?, responseData: [SearchUserFields]?) {
        self.responseCode = responseCode
        self.responseMessage = responseMessage
        self.responseData = responseData
    }


}
