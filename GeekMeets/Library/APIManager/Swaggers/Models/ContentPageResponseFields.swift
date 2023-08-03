//
// ContentPageResponseFields.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct ContentPageResponseFields: Codable {

    public var vPageId: Int?
    public var vPageName: String?
    public var txContent: String?

    public init(vPageId: Int?, vPageName: String?, txContent: String?) {
        self.vPageId = vPageId
        self.vPageName = vPageName
        self.txContent = txContent
    }


}
