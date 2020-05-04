//
//  UserProfileModel.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 30/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class UserProfileModel: NSObject {

    public var vFullName: String?
    public var vAge: String?
    public var vAbout: String?
    public var vCity : String?
    public var vGender: String?
    public var vCompanyDetail: String?
    public var vInterestAge: String?
    public var vInterestGender: String?
    public var vLikedSocialPlatform: String?
    public var vPhotos : String?
    public var vInstagramLink: String?
    public var vSnapchatLink: String?
    public var vFacebookLink: String?
    public var vShowAge: Bool?
    public var vShowDistance: Bool?
    public var vShowContactNo: Bool?
    public var vShowProfiletoLiked: Bool?
    
    public init(vFullName: String?, vAge: String?, vAbout: String?, vCity : String?, vGender: String?, vCompanyDetail: String?, vInterestAge: String?, vInterestGender: String?, vLikedSocialPlatform: String?, vPhotos : String?, vInstagramLink: String?, vSnapchatLink: String?, vFacebookLink: String?, vShowAge : Bool?, vShowDistance: Bool?, vShowContactNo: Bool?, vShowProfiletoLiked: Bool?) {
        
        self.vFullName = vFullName
        self.vAge = vAge
        self.vAbout = vAbout
        self.vCity = vCity
        self.vGender = vGender
        self.vCompanyDetail = vCompanyDetail
        self.vInterestAge = vInterestAge
        self.vInterestGender = vInterestGender
        self.vLikedSocialPlatform = vLikedSocialPlatform
        self.vPhotos = vPhotos
        self.vInstagramLink = vInstagramLink
        self.vSnapchatLink = vSnapchatLink
        self.vFacebookLink = vFacebookLink
        self.vShowAge = vShowAge
        self.vShowDistance = vShowDistance
        self.vShowContactNo = vShowContactNo
        self.vShowProfiletoLiked = vShowProfiletoLiked
    }
}
