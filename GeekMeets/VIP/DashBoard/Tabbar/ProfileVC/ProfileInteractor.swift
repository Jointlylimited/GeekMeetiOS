//
//  ProfileInteractor.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 20/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ProfileInteractorProtocol {
    func doSomething()
}

protocol ProfileDataStore {
    //var name: String { get set }
}

class ProfileInteractor: ProfileInteractorProtocol, ProfileDataStore {
    var presenter: ProfilePresentationProtocol?
    //var name: String = ""
    
    // MARK: Do something
    func doSomething() {
        
    }
}
