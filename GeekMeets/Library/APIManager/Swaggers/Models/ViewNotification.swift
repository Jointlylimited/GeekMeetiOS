//
// ViewNotification.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct ViewNotification: Codable {

    public var responseCode: Int?
    public var responseMessage: String?
    public var responseData: NotificationFields?

    public init(responseCode: Int?, responseMessage: String?, responseData: NotificationFields?) {
        self.responseCode = responseCode
        self.responseMessage = responseMessage
        self.responseData = responseData
    }


}

