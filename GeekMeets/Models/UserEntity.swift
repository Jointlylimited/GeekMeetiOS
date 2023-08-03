//
//  UserEntity.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 13/05/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import Foundation

struct UserEntity {
    let displayName: String?
    let avatar: String?
    let externalId : String?
    
    private enum CodingKeys: String, CodingKey {
        case data
    }
    
    private enum DataKeys: String, CodingKey {
        case me
    }
    
    private enum MeKeys: String, CodingKey {
        case displayName
        case bitmoji
        case externalId
    }
    
    private enum BitmojiKeys: String, CodingKey {
        case avatar
    }
}

extension UserEntity: Decodable {
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let data = try values.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        let me = try data.nestedContainer(keyedBy: MeKeys.self, forKey: .me)
        
        displayName = try? me.decode(String.self, forKey: .displayName)
        
        let bitmoji = try me.nestedContainer(keyedBy: BitmojiKeys.self, forKey: .bitmoji)
        avatar = try? bitmoji.decode(String.self, forKey: .avatar)
        externalId = try? me.decode(String.self, forKey: .externalId)
    }
}
