//
// PreferencesResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct PreferencesResponse: Codable {

    public var responseCode: Int?
    public var responseMessage: String?
    public var responseData: [PreferencesField]?

    public init(responseCode: Int?, responseMessage: String?, responseData: [PreferencesField]?) {
        self.responseCode = responseCode
        self.responseMessage = responseMessage
        self.responseData = responseData
    }


}

