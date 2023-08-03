//
//  SignUpUser.swift
//  NearByEventPlanProvider
//
//  Created by Hiren Gohel on 17/01/19.
//  Copyright © 2019 SOTSYS203. All rights reserved.
//

import UIKit

class SignUpUserModel: Codable {

    public var email : String?
    public var password : String?
    public var confirmpassword : String?
    public var mobile : String?
    public var countryCode : String?
    public var userImageName : String? = ""
    public var firstName : String?
    public var lastName : String?
    public var phone: String?
    public var birthday: String?

    public init(email : String?, password : String?, confirmpassword : String?, mobile : String?, countryCode : String?, userImageName : String? = "", firstName : String?, lastName : String?, phone: String?, birthday: String?) {
        self.email = email
        self.password = password
        self.confirmpassword = confirmpassword
        self.mobile = mobile
        self.countryCode = countryCode
        self.userImageName = userImageName
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.birthday = birthday
    }
}
