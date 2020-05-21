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

enum CommonModelData {

    case Tips
    case Terms
    case Privacy
    case About
    case Licenses

    var Title : String {
        switch self {
        case .Tips:
            return "Tips"
        case .Terms:
            return "Terms & Conditions"
        case .Privacy:
            return "Privacy Policy"
        case .About:
            return "About Us"
        case .Licenses:
            return "Licenses"
        }
    }
}

enum Interest_PreferenceData {

    case Ethernity
    case Preference_Ethernity
    case Personality
    case Preference_Personality
    case Height
    case Preference_Height
    case SexualOrientation
    case Preference_SexualOrientation
    case LookingFor
    case AgeRange
    case Region
    case BodyType
    case Preference_BodyType
    case TurnsMost
    case Communication
    case Important
    case Accountable
    case Indoor_Outdoor
    case Sex_Important
    case Morning_Night
    case Pets
    case Kids
    case Decision_Making
    
    var Title : String {
        switch self {
        case .Ethernity:
            return "Your Ethnicity?"
        case .Preference_Ethernity:
            return "Your desired partner’s Ethnicity would be?"
        case .Personality:
            return "What is your personality type?"
        case .Preference_Personality:
            return "Personality of your desired partner would be?"
        case .Height:
            return "Your Height?"
        case .Preference_Height:
            return "Your Height preference?"
        case .SexualOrientation:
            return "Your Sexual orientation?"
        case .Preference_SexualOrientation:
            return "Sexual Orientation of your desired partner"
        case .LookingFor:
            return "Are you looking for.."
        case .AgeRange:
            return "Select age range of your preferred partner?"
        case .Region:
            return "What is your religion?"
        case .BodyType:
            return "Your Body Type?"
        case .Preference_BodyType:
            return "Body type of your desired partner?"
        case .TurnsMost:
            return "What turns you on the most?"
        case .Communication:
            return "How important is communication in a relationship?"
        case .Important:
            return "Which is more important?"
        case .Accountable:
            return "It is important to be accountable in a relationship?"
        case .Indoor_Outdoor:
            return "Are you A indoors or outdoors person?"
        case .Sex_Important:
            return "How important is the element of sex in a relationship?"
        case .Morning_Night:
            return "Are you a morning or night person?"
        case .Pets:
            return "Do you have pets?"
        case .Kids:
            return "Do you have Kids?"
        case .Decision_Making:
            return "How Important is decision making as a couple?"
        }
    }
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

func json(from object:[NSDictionary]) -> String? {
        var yourString : String = ""
        do
        {
            if let postData : NSData = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
            {
                yourString = NSString(data: postData as Data, encoding: String.Encoding.utf8.rawValue)! as String
                return yourString
            }
        }
        catch
        {
            print(error)
        }
        return yourString
    }

func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
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
