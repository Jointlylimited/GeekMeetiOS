//
//  UserProfileModel.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 30/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class UserProfileModel: NSObject {

    public var vEmail: String?
    public var vProfileImage: String?
    public var vFullName: String?
    public var vAge: Int?
    public var vDoB: String?
    public var vAbout: String?
    public var vCity : String?
    public var vGender: String?
    public var vGenderIndex: String?
    public var vCompanyDetail: String?
    public var vInterestAge: String?
    public var vInterestGender: String?
    public var vLikedSocialPlatform: String?
    public var vPhotos : String?
    public var vInstagramLink: String?
    public var vSnapchatLink: String?
    public var vFacebookLink: String?
    public var vShowAge: Int?
    public var vShowDistance: Int?
    public var vShowContactNo: Int?
    public var vShowProfiletoLiked: Int?
    public var vProfileImg: UIImage?
    public var vProfileImageArray: [UIImage]?
    
    public init(vEmail: String?, vProfileImage: String?, vFullName: String?, vAge: Int?, vDoB: String?, vAbout: String?, vCity : String?, vGender: String?, vGenderIndex: String?, vCompanyDetail: String?, vInterestAge: String?, vInterestGender: String?, vLikedSocialPlatform: String?, vPhotos : String?, vInstagramLink: String?, vSnapchatLink: String?, vFacebookLink: String?, vShowAge : Int?, vShowDistance: Int?, vShowContactNo: Int?, vShowProfiletoLiked: Int?, vProfileImg: UIImage?, vProfileImageArray: [UIImage]?) {
        
        self.vEmail = vEmail
        self.vProfileImage = vProfileImage
        self.vFullName = vFullName
        self.vAge = vAge
        self.vDoB = vDoB
        self.vAbout = vAbout
        self.vCity = vCity
        self.vGender = vGender
        self.vGenderIndex = vGenderIndex
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
        self.vProfileImg = vProfileImg
        self.vProfileImageArray = vProfileImageArray
    }
}
