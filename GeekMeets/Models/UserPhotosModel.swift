//
//  UserPhotosModel.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 25/05/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class UserPhotosModel: NSObject {

    public var iMediaId: Int?
    public var vMedia: String?
    public var vMediaPath: String?
    public var tiMediaType: Int?
    public var tiImage: UIImage?
    public var tiIsDefault: Int?
    public var reaction: [MediaReactionFields]?
    
    public init(iMediaId: Int?, vMedia: String?, vMediaPath: String?, tiMediaType: Int?, tiImage: UIImage?, tiIsDefault: Int?, reaction: [MediaReactionFields]?) {
        self.iMediaId = iMediaId
        self.vMedia = vMedia
        self.vMediaPath = vMediaPath
        self.tiMediaType = tiMediaType
        self.tiImage = tiImage
        self.tiIsDefault = tiIsDefault
        self.reaction = reaction
    }
}
