//
// UserAuthResponseField.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct UserAuthResponseField: Codable {

    public var iUserId: Int?
    public var vSocialId: String?
    public var tiSocialType: Int?
    public var vAuthKey: String?
    public var vName: String?
    public var tiAge: Int?
    public var tiGender: Int?
    public var dDob: String?
    public var vProfileImage: String?
    public var vEmail: String?
    public var txAbout: String?
    public var vCountryCode: String?
    public var vPhone: String?
    public var vUserDeviceLanguage: String?
    public var txCompanyDetail: String?
    public var vLiveIn: String?
    public var fLatitude: String?
    public var fLongitude: String?
    public var tiIsSocialLogin: Int?
    public var vReferralCode: String?
    public var vInstaLink: String?
    public var vSnapLink: String?
    public var vFbLink: String?
    public var tiIsShowAge: Int?
    public var tiIsShowDistance: Int?
    public var tiIsShowContactNumber: Int?
    public var tiIsShowProfileToLikedUser: Int?
    public var tiIsSubscribed: Int?
    public var tiIsAdmin: Int?
    public var tiStep: Int?
    public var photos: [UserProfileMediaList]?
    public var preference: [PreferenceAnswer]?

    public init(iUserId: Int?, vSocialId: String?, tiSocialType: Int?, vAuthKey: String?, vName: String?, tiAge: Int?, tiGender: Int?, dDob: String?, vProfileImage: String?, vEmail: String?, txAbout: String?, vCountryCode: String?, vPhone: String?, vUserDeviceLanguage: String?, txCompanyDetail: String?, vLiveIn: String?, fLatitude: String?, fLongitude: String?, tiIsSocialLogin: Int?, vReferralCode: String?, vInstaLink: String?, vSnapLink: String?, vFbLink: String?, tiIsShowAge: Int?, tiIsShowDistance: Int?, tiIsShowContactNumber: Int?, tiIsShowProfileToLikedUser: Int?, tiIsSubscribed: Int?, tiIsAdmin: Int?, tiStep: Int?, photos: [UserProfileMediaList]?, preference: [PreferenceAnswer]?) {
        self.iUserId = iUserId
        self.vSocialId = vSocialId
        self.tiSocialType = tiSocialType
        self.vAuthKey = vAuthKey
        self.vName = vName
        self.tiAge = tiAge
        self.tiGender = tiGender
        self.dDob = dDob
        self.vProfileImage = vProfileImage
        self.vEmail = vEmail
        self.txAbout = txAbout
        self.vCountryCode = vCountryCode
        self.vPhone = vPhone
        self.vUserDeviceLanguage = vUserDeviceLanguage
        self.txCompanyDetail = txCompanyDetail
        self.vLiveIn = vLiveIn
        self.fLatitude = fLatitude
        self.fLongitude = fLongitude
        self.tiIsSocialLogin = tiIsSocialLogin
        self.vReferralCode = vReferralCode
        self.vInstaLink = vInstaLink
        self.vSnapLink = vSnapLink
        self.vFbLink = vFbLink
        self.tiIsShowAge = tiIsShowAge
        self.tiIsShowDistance = tiIsShowDistance
        self.tiIsShowContactNumber = tiIsShowContactNumber
        self.tiIsShowProfileToLikedUser = tiIsShowProfileToLikedUser
        self.tiIsSubscribed = tiIsSubscribed
        self.tiIsAdmin = tiIsAdmin
        self.tiStep = tiStep
        self.photos = photos
        self.preference = preference
    }


}

