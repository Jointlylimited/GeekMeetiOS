//
//  MyMatchesInteractor.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 22/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MyMatchesInteractorProtocol {
    func doSomething()
}

protocol MyMatchesDataStore {
    //var name: String { get set }
}

class MyMatchesInteractor: MyMatchesInteractorProtocol, MyMatchesDataStore {
    var presenter: MyMatchesPresentationProtocol?
    //var name: String = ""
    
    // MARK: Do something
    func doSomething() {
        
    }
}
