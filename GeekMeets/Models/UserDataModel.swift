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
    
    static var authorization : String {
        let auth = "Bearer \(UserDataModel.currentUser!.vAuthKey ?? "")"
        return auth
    }
    
    @objc static func setUserLocation(location: CLLocation){
        UserDefaults.standard.set(location, forKey: kUserCurrentLocation)
    }
    
    @objc static func getUserLocation() -> CLLocation{
        return UserDefaults.standard.value(forKey: kUserCurrentLocation) as! CLLocation
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

