//
//  SelectAgeRangeInteractor.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 23/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SelectAgeRangeInteractorProtocol {
    func doSomething()
    func callQuestionnaireApi()
}

protocol SelectAgeRangeDataStore {
    //var name: String { get set }
}

class SelectAgeRangeInteractor: SelectAgeRangeInteractorProtocol, SelectAgeRangeDataStore {
    var presenter: SelectAgeRangePresentationProtocol?
    //var name: String = ""
    
    // MARK: Do something
    func doSomething() {
        
    }
    func callQuestionnaireApi() {
      
      if let path = Bundle.main.path(forResource: "questionnaire", ofType: "json") {
          do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? NSArray {
                          // do stuff
                  print(jsonResult)
                  var abc:[QuestionnaireModel]?
                  abc = jsonResult as! [QuestionnaireModel]
//                  let Data:QuestionnaireModel = QuestionnaireModel.init(dictionary: jsonResult)!
                  self.presenter?.getQuestionnaireResponse(userData: abc)
                }
            } catch {
                 // handle error
            }
      }
      
  }
}
