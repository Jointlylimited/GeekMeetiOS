//
//  GlobalMethods.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 24/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import Foundation
import UIKit
import Photos

/*---------------------------------------------------
 Ratio
 ---------------------------------------------------*/
let _heightRatio : CGFloat = {
    let ratio = ScreenSize.height / 736
    return ratio
}()

let _widthRatio : CGFloat = {
    let ratio = ScreenSize.width / 414
    return ratio
}()

var objQuestionModel = QuestionaryModel()

enum FontTypePoppins: String {
    case Poppins_Regular = "Poppins-Regular"
    case Poppins_Medium = "Poppins-Medium"
    case Poppins_Bold = "Poppins-Bold"
    case Poppins_SemiBold = "Poppins-SemiBold"
    
}

enum FontSizePoppins: CGFloat {
    case sizeSmallLabel = 12
    case sizeNormalTextField = 14
    case sizeNormalTitleNav = 16
    case sizeNormalButton = 18
    case sizePopupMenuTitle = 20
    case sizeMenuButton = 22
    case sizebigLabelForSpin = 30
    case size15Point = 15
}

fileprivate let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    return formatter
}()

func fontPoppins(fontType : FontTypePoppins , fontSize : FontSizePoppins) -> UIFont {
    return UIFont(name: fontType.rawValue, size: fontSize.rawValue)!
}

func shareInviteApp(message: String, link: String, controller : UIViewController) {
    
    if let link = NSURL(string: link) {
        let objectsToShare = [message,link] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        controller.present(activityVC, animated: true, completion: nil)
    }
}

func fetchUserData() -> [UserDetail] {
    var arrayDetails :  [UserDetail] = []
    if let path = Bundle.main.path(forResource: "user-details", ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            print(jsonResult)
            let userDetails : NSArray = (jsonResult as! NSDictionary).object(forKey: "userDetails") as! NSArray
            for object in userDetails {
                
                let userDetail : UserDetail = try UserDetail(dictionary: object as! [AnyHashable : Any])
                arrayDetails.append(userDetail)
            }
            print(userDetails)
            
        } catch {
            // handle error
        }
    }
    return arrayDetails
}

  func callQuestionnaireApi() -> [NSDictionary] {
    
      if let path = Bundle.main.path(forResource: "questionnaire", ofType: "json") {
          do {
              let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
              let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
              if let jsonResult = jsonResult as? NSArray {
                  // do stuff
                  print(jsonResult)
                  var abc:[QuestionnaireModel]? = []
                  
                  let data = (jsonResult as! NSArray)
                  print(data)
                  let dict = data as! [NSDictionary]
                  print(dict)
                  abc = [QuestionnaireModel(dictionary: dict[0])!]
                  print(abc)
                  //                  let Data:QuestionnaireModel = QuestionnaireModel.init(dictionary: jsonResult)!
                objQuestionModel.arrQuestionnaire = dict
                return dict
              }
          } catch {
              // handle error
          }
      }
    return []
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

// MARK: - Camera Access Permisison
extension UIViewController {
    
    typealias PermissionStatus = (_ status: Int, _ isGranted: Bool) -> ()
    
    func cameraAccess(permissionWithStatus block: @escaping PermissionStatus) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            switch status {
            case .authorized:
                block(AVAuthorizationStatus.authorized.rawValue, true)
            case .denied:
                block(AVAuthorizationStatus.denied.rawValue, false)
            case .restricted:
                block(AVAuthorizationStatus.restricted.rawValue, false)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (grant) in
                    delay(0.2) {
                        if grant {
                            block(AVAuthorizationStatus.authorized.rawValue, grant)
                        }else{
//                            AppSingleton.sharedInstance().showAlert(kCameraAccessMsg, okTitle: "OK")
                            self.showAccessPopup(title: kCameraAccessTitle, msg: kCameraAccessMsg)
                            block(AVAuthorizationStatus.denied.rawValue, grant)
                        }
                    }
                })
            }
        }else{
            delay(0.2) {
//                AppSingleton.sharedInstance().showAlert(kCameraAccessMsg, okTitle: "OK")
                self.showAccessPopup(title: kCameraAccessTitle, msg: kCameraAccessMsg)
                block(AVAuthorizationStatus.restricted.rawValue, false)
            }
        }
    }
    
    func showAccessPopup(title: String?, msg: String?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)! , options: [:], completionHandler: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func photoLibraryAccess(block: @escaping PermissionStatus) {
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            block(status.rawValue, true)
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (perStatus) in
                delay(0.2) {
                    if perStatus == PHAuthorizationStatus.authorized {
                        block(perStatus.rawValue, true)
                    } else {
//                        AppSingleton.sharedInstance().showAlert(kPhotosAccessMsg, okTitle: "OK")
                        self.showAccessPopup(title: kPhotosAccessTitle, msg: kPhotosAccessMsg)
                        block(perStatus.rawValue, false)
                    }
                }
            }
        } else {
            delay(0.2) {
//                AppSingleton.sharedInstance().showAlert(kPhotosAccessMsg, okTitle: "OK")
                self.showAccessPopup(title: kPhotosAccessTitle, msg: kPhotosAccessMsg)
                block(status.rawValue, false)
            }
        }
    }
}
