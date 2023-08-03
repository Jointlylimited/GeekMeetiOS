//
//  SettingsInteractor.swift
//  Basecode
//
//  Created by SOTSYS203 on 28/02/18.
//  Copyright (c) 2018 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SettingsInteractorProtocol {
    func doSomething()
}

protocol SettingsDataStore {
    //var name: String { get set }
}

class SettingsInteractor: SettingsInteractorProtocol, SettingsDataStore {
    var presenter: SettingsPresentationProtocol?
    //var name: String = ""
    
    // MARK: Do something
    func doSomething() {
        
    }
}