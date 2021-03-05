//
// CommonResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct CommonResponse: Codable {

    public var responseCode: Int?
    public var responseMessage: String?

    public init(responseCode: Int?, responseMessage: String?) {
        self.responseCode = responseCode
        self.responseMessage = responseMessage
    }


}

