//
//  UserDataModel.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 04/05/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

class UserDataModel : Codable {
    
    static var isUserLoggedIn: Bool {
       return UserDefaults.standard.value(forKey: "userData") != nil
    }
    
    static var currentUser : UserAuthResponseField? {
        didSet{
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(currentUser) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "userData")
            }
        }
    }
    static var lastLoginUser : UserAuthResponseField? {
    let defaults = UserDefaults.standard

        if let userData = defaults.object(forKey: "userData") as? Data {
        let decoder = JSONDecoder()
        if let loadedPerson = try? decoder.decode(UserAuthResponseField.self, from: userData) {
            return loadedPerson
        }
    }
        return nil
    }
    
    static var OtherUserData : [UserProfileMediaList]? {
        didSet{
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(OtherUserData) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "OtherUserData")
            }
        }
    }
    static var OtherUser : [UserProfileMediaList]? {
    let defaults = UserDefaults.standard

        if let userData = defaults.object(forKey: "OtherUserData") as? Data {
        let decoder = JSONDecoder()
        if let loadedPerson = try? decoder.decode([UserProfileMediaList].self, from: userData) {
            return loadedPerson
        }
    }
        return nil
    }
    
    static var UserPreferenceResponse : PreferencesResponse? {
        didSet{
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(UserPreferenceResponse) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "UserPreferenceData")
            }
        }
    }
    static var UserPreferenceData : PreferencesResponse? {
    let defaults = UserDefaults.standard

        if let userData = defaults.object(forKey: "UserPreferenceData") as? Data {
        let decoder = JSONDecoder()
        if let loadedPerson = try? decoder.decode(PreferencesResponse.self, from: userData) {
            return loadedPerson
        }
    }
        return nil
    }
    
    static var SignUpUserResponse : SignUpUserModel? {
        didSet{
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(SignUpUserResponse) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "SignUpUserResponse")
            }
        }
    }
    static var SignUpUserData : SignUpUserModel? {
    let defaults = UserDefaults.standard

        if let userData = defaults.object(forKey: "UserPreferenceData") as? Data {
        let decoder = JSONDecoder()
        if let loadedPerson = try? decoder.decode(SignUpUserModel.self, from: userData) {
            return loadedPerson
        }
    }
        return nil
    }
    
    @objc static func setAuthKey(key: String){
        UserDefaults.standard.set(key, forKey: kAuthKey)
    }
    
    static var authorization : String {
        let auth = "Bearer \(UserDefaults.standard.value(forKey: kAuthKey) ?? "")"
        return auth
    }
    
    @objc static func setSocialType(socialType: String){
        UserDefaults.standard.set(socialType, forKey: kSocialType)
    }
    
    @objc static func getSocialType() -> String {
        return UserDefaults.standard.value(forKey: kSocialType) as? String ?? ""
    }
    
    static var PreferenceData : PreferencesResponse? {
        didSet{
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(PreferenceData) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "PreferenceData")
            }
        }
    }
    
    
//    @objc static func setNotificationCount(count: Int){
//        UserDefaults.standard.set(count, forKey: kNotificationCount)
//    }
//
//    @objc static func getNotificationCount() -> Int{
//        return UserDefaults.standard.integer(forKey: kNotificationCount)
//    }
//
//    @objc static func setNotificationData(count: Int){
//        UserDefaults.standard.set(count, forKey: kNotificationData)
//    }
//
//    @objc static func getNotificationData() -> Int{
//        return UserDefaults.standard.integer(forKey: kNotificationData)
//    }
}

