//
//  InitialSignUpInteractor.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 15/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol InitialSignUpInteractorProtocol {
    func doSomething()
}

protocol InitialSignUpDataStore {
    //var name: String { get set }
}

class InitialSignUpInteractor: InitialSignUpInteractorProtocol, InitialSignUpDataStore {
    var presenter: InitialSignUpPresentationProtocol?
    //var name: String = ""
    
    // MARK: Do something
    func doSomething() {
        
    }
}
