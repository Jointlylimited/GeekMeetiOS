//
//  AddPhotosPresenter.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 21/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreLocation

protocol AddPhotosPresentationProtocol {
    
    func callUserSignUpAPI(signParams : Dictionary<String, String>, images : [NSDictionary])
    func getSignUpResponse(response : UserAuthResponse)
}

class AddPhotosPresenter: AddPhotosPresentationProtocol {
    weak var viewController: AddPhotosProtocol?
    var interactor: AddPhotosInteractorProtocol?
    
    func callUserSignUpAPI(signParams : Dictionary<String, String>, images : [NSDictionary]) {
        if String(describing: signParams["photos"]!).isEmpty {
            self.viewController?.displayAlert(strTitle: "", strMessage: kAddPhotos)
            return
        } else {
            if images.count > 0 {
                self.interactor?.uploadImgToS3(with: signParams, images: images)
            } else {
                self.interactor?.callSignUpInfoAPI(signParams : signParams)
            }
        }
    }
    
    func getSignUpResponse(response : UserAuthResponse) {
        
        UserDataModel.currentUser = response.responseData
        UserDataModel.setAuthKey(key: (response.responseData?.vAuthKey)!)
        
        let controller = GeekMeets_StoryBoard.Questionnaire.instantiateViewController(withIdentifier: GeekMeets_ViewController.SelectAgeRange)
        if let view = self.viewController as? UIViewController
        {
            view.pushVC(controller)
        }
    }
}
