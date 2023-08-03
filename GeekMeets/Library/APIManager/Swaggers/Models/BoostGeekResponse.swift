//
// BoostGeekResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct BoostGeekResponse: Codable {

    public var responseCode: Int?
    public var responseMessage: String?
    public var responseData: BoostGeekFields?

    public init(responseCode: Int?, responseMessage: String?, responseData: BoostGeekFields?) {
        self.responseCode = responseCode
        self.responseMessage = responseMessage
        self.responseData = responseData
    }


}
