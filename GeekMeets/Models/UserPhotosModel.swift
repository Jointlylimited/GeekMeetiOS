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
    public var tiMediaType: Int?
    public var tiImage: UIImage?
    public var tiIsDefault: Int?

    public init(iMediaId: Int?, vMedia: String?, tiMediaType: Int?, tiImage: UIImage?, tiIsDefault: Int?) {
        self.iMediaId = iMediaId
        self.vMedia = vMedia
        self.tiMediaType = tiMediaType
        self.tiImage = tiImage
        self.tiIsDefault = tiIsDefault
    }
}
