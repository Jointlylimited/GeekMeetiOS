//
// BoostGeekFields.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct BoostGeekFields: Codable {

    public var pendingBoost: Int?
    public var pendingGeek: Int?
    public var tiPlanType: Int?
    public var iActiveAt: String?
    public var iExpireAt: String?

    public init(pendingBoost: Int?, pendingGeek: Int?, tiPlanType: Int?, iActiveAt: String?, iExpireAt: String?) {
        self.pendingBoost = pendingBoost
        self.pendingGeek = pendingGeek
        self.tiPlanType = tiPlanType
        self.iActiveAt = iActiveAt
        self.iExpireAt = iExpireAt
    }


}

