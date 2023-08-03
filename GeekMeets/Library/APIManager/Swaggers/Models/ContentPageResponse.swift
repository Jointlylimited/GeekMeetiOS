//
// ContentPageResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct ContentPageResponse: Codable {

    public var responseCode: Int?
    public var responseMessage: String?
    public var responseData: ContentPageResponseFields?

    public init(responseCode: Int?, responseMessage: String?, responseData: ContentPageResponseFields?) {
        self.responseCode = responseCode
        self.responseMessage = responseMessage
        self.responseData = responseData
    }


}
