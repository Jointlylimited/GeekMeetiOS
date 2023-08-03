//
// ContactUsResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct ContactUsResponse: Codable {

    public var responseCode: Int?
    public var responseMessage: String?
    public var responseData: ContactUsFields?

    public init(responseCode: Int?, responseMessage: String?, responseData: ContactUsFields?) {
        self.responseCode = responseCode
        self.responseMessage = responseMessage
        self.responseData = responseData
    }


}

