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
let authToken = Authentication.sharedInstance().getAutheticationToken()
var objQuestionModel = QuestionaryModel()
var genderArray : [String] = ["Male", "Female", "Others", "Prefer not to say"]
var PreferenceIconsDict : [NSDictionary] = [["type" : "1", "icon" : #imageLiteral(resourceName: "Ethnicity")], ["type" : "5", "icon" : #imageLiteral(resourceName: "scale")], ["type" : "3", "icon" : #imageLiteral(resourceName: "personality")], ["type" : "26", "icon" : #imageLiteral(resourceName: "ruler")], ["type" : "24", "icon" : #imageLiteral(resourceName: "education")], ["type" : "11", "icon" : #imageLiteral(resourceName: "religion")], ["type" : "25", "icon" : #imageLiteral(resourceName: "Politics")], ["type" : "27", "icon" : #imageLiteral(resourceName: "Drink")], ["type" : "28", "icon" : #imageLiteral(resourceName: "smoke")], ["type" : "29", "icon" : #imageLiteral(resourceName: "zodiac_sign")], ["type" : "9", "icon" : #imageLiteral(resourceName: "lookinng for")], ["type" : "22", "icon" : #imageLiteral(resourceName: "kid")]]
var NotificationImages : [NSDictionary] = [["type" : "1", "image" : #imageLiteral(resourceName: "match")], ["type" : "2", "image" : #imageLiteral(resourceName: "noti_Subscription")], ["type" : "3" , "image" : #imageLiteral(resourceName: "icn_active_boost")],
                                           ["type" : "4", "image" : #imageLiteral(resourceName: "icn_geek_purchase")], ["type" : "5", "image" : #imageLiteral(resourceName: "icn_combine")], ["type" : "6" , "image" : #imageLiteral(resourceName: "icn_active_boost")],
                                           ["type" : "7", "image" : #imageLiteral(resourceName: "icn_geek_purchase")], ["type" : "8", "image" : #imageLiteral(resourceName: "icn_update_profile")], ["type" : "9" , "image" : #imageLiteral(resourceName: "icn_change_password")]]

enum MediaType: Int {
    case image = 0, video, gif
}

let _maxImageSize              : CGSize  = CGSize(width: 1000, height: 1000)
let _minImageSize              : CGSize  = CGSize(width: 800, height: 800)

enum FontTypePoppins: String {
    case Poppins_ExtraLight = "Poppins-ExtraLight"
    case Poppins_ThinItalic = "Poppins-ThinItalic"
    case Poppins_ExtraLightItalic = "Poppins-ExtraLightItalic"
    case Poppins_BoldItalic = "Poppins-BoldItalic"
    case Poppins_Light = "Poppins-Light"
    case Poppins_Medium = "Poppins-Medium"
    case Poppins_SemiBoldItalic = "Poppins-SemiBoldItalic"
    case Poppins_ExtraBoldItalic = "Poppins-ExtraBoldItalic"
    case Poppins_ExtraBold = "Poppins-ExtraBold"
    case Poppins_BlackItalic = "Poppins-BlackItalic"
    case Poppins_Regular = "Poppins-Regular"
    case Poppins_LightItalic = "Poppins-LightItalic"
    case Poppins_Bold = "Poppins-Bold"
    case Poppins_Black = "Poppins-Black"
    case Poppins_Thin = "Poppins-Thin"
    case Poppins_SemiBold = "Poppins-SemiBold"
    case Poppins_Italic = "Poppins-Italic"
    case Poppins_MediumItalic = "Poppins-MediumItalic"
    
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
    
    var slugTitle : String {
        switch self {
        case .Tips:
            return "tips"
        case .Terms:
            return "terms"
        case .Privacy:
            return "privacy-policy"
        case .About:
            return "about-us"
        case .Licenses:
            return "licenses"
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

enum BoostPurchase {
    case OneBoost
    case FiveBoost
    case EightBoost
    case MostPopular
    
    var productKey : String {
        switch self {
        case .OneBoost:
            return "com.jointly.oneboost"
        case .FiveBoost:
            return "com.jointly.onetopstory"
        case .EightBoost:
            return "com.jointly.monthlysubscription"
        case .MostPopular:
            return "com.jointly.bundlepackage"
        }
    }
}

enum TopStoryPurchase {
    case OneStory
    case FourStory
    case EightStory
    case MostPopular
    
    var productKey : String {
        switch self {
        case .OneStory:
            return "com.jointly.onetopstory"
        case .FourStory:
            return "com.jointly.fourtopstory"
        case .EightStory:
            return "com.jointly.eighttopstory"
        case .MostPopular:
            return "com.jointly.bundlepackage"
        }
    }
}

enum SubscriptionKeys {
    
    case Monthly
    case Annualy
    
    var productKey : String {
        switch self {
        case .Monthly:
            return "com.jointly.monthlysubscription"
        case .Annualy:
            return "com.jointly.yearlysubscription"
        }
    }
}

let callingCodes = ["AD":"376","AE":"971","AF":"93","AG":"1","AI":"1","AL":"355","AM":"374","AN":"599","AO":"244","AR":"54","AS":"1","AT":"43","AU":"61","AW":"297","AZ":"994",
                    "BA":"387","BB":"1","BD":"880","BE":"32","BF":"226","BG":"359","BH":"973","BI":"257","BJ":"229","BL":"590","BM":"1","BN":"673","BO":"591","BR":"55","BS":"1","BT":"975","BW":"267","BY":"375","BZ":"501",
                    "CA":"1","CC":"61","CD":"243","CF":"236","CG":"242","CH":"41","CI":"225","CK":"682","CL":"56","CM":"237","CN":"86","CO":"57","CR":"506","CU":"53","CV":"238","CX":"61","CY":"537","CZ":"420",
                    "DE":"49","DJ":"253","DK":"45","DM":"1","DO":"1","DZ":"213",
                    "EC":"593","EE":"372","EG":"20","ER":"291","ES":"34","ET":"251",
                    "FI":"358","FJ":"679","FK":"500","FM":"691","FO":"298","FR":"33",
                    "GA":"241","GB":"44","GD":"1","GE":"995","GF":"594","GG":"44","GH":"233","GI":"350","GL":"299","GM":"220","GN":"224","GP":"590","GQ":"240","GR":"30","GS":"500","GT":"502","GU":"1","GW":"245","GY":"595",
                    "HK":"852","HN":"504","HR":"385","HT":"509","HU":"36","ID":"62","IE":"353",
                    "IL":"972","IM":"44","IN":"91","IO":"246","IQ":"964","IR":"98","IS":"354","IT":"39",
                    "JE":"44","JM":"1","JO":"962","JP":"81",
                    "KE":"254","KG":"996","KH":"855","KI":"686","KM":"269","KN":"1","KP":"850","KR":"82","KW":"965","KY":"345","KZ":"77",
                    "LA":"856","LB":"961","LC":"1","LI":"423","LK":"94","LR":"231","LS":"266","LT":"370","LU":"352","LV":"371","LY":"218",
                    "MA":"212","MC":"377","MD":"373","ME":"382","MF":"590","MG":"261","MH":"692","MK":"389","ML":"223","MM":"95","MN":"976","MO":"853","MP":"1","MQ":"596","MR":"222","MS":"1","MT":"356","MU":"230","MV":"960","MW":"265","MX":"52","MY":"60","MZ":"258",
                    "NA":"264","NC":"687","NE":"227","NF":"672","NG":"234","NI":"505","NL":"31","NO":"47","NP":"977","NR":"674","NU":"683","NZ":"64",
                    "OM":"968",
                    "PA":"507","PE":"51","PF":"689","PG":"675","PH":"63","PK":"92","PL":"48","PM":"508","PN":"872","PR":"1","PS":"970","PT":"351","PW":"680","PY":"595",
                    "QA":"974",
                    "RE":"262","RO":"40","RS":"381","RU":"7","RW":"250",
                    "SA":"966","SB":"677","SC":"248","SD":"249","SE":"46","SG":"65","SH":"290","SI":"386","SJ":"47","SK":"421","SL":"232","SM":"378","SN":"221","SO":"252","SR":"597","ST":"239","SV":"503","SY":"963","SZ":"268",
                    "TC":"1","TD":"235","TG":"228","TH":"66","TJ":"992","TK":"690","TL":"670","TM":"993","TN":"216","TO":"676","TR":"90","TT":"1","TV":"688","TW":"886","TZ":"255",
                    "UA":"380","UG":"256","US":"1","UY":"598","UZ":"998",
                    "VA":"379","VC":"1","VE":"58","VG":"284","VI":"340","VN":"84","VU":"678",
                    "WF":"681","WS":"685",
                    "YE":"967","YT":"262",
                    "ZA":"27","ZM":"260","ZW":"263"]

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
    
//      if let path = Bundle.main.path(forResource: "questionnaire", ofType: "json") {
//          do {
//              let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//              let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//              if let jsonResult = jsonResult as? NSArray {
//                  // do stuff
//                  print(jsonResult)
//                  var abc:[QuestionnaireModel]? = []
//                  
//                  let data = (jsonResult as! NSArray)
//                  print(data)
//                  let dict = data as! [NSDictionary]
//                  print(dict)
//                  abc = [QuestionnaireModel(dictionary: dict[0])!]
//                  print(abc)
//                  //                  let Data:QuestionnaireModel = QuestionnaireModel.init(dictionary: jsonResult)!
//                objQuestionModel.arrQuestionnaire = dict
//                return dict
//              }
//          } catch {
//              // handle error
//          }
//      }
    return []
}

func json(from object:[NSDictionary]) -> String? {
        var yourString : String = ""
        do
        {
//            if let postData : NSData = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
//            {
//                yourString = NSString(data: postData as Data, encoding: String.Encoding.utf8.rawValue)! as String
//                return yourString
//            }
             let postData : NSData = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
            
                yourString = NSString(data: postData as Data, encoding: String.Encoding.utf8.rawValue)! as String
                return yourString
            
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
                            self.showAccessPopup(title: kCameraAccessTitle, msg: kCameraAccessMsg)
                            block(AVAuthorizationStatus.denied.rawValue, grant)
                        }
                    }
                })
            }
        }else{
            delay(0.2) {
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
                        self.showAccessPopup(title: kPhotosAccessTitle, msg: kPhotosAccessMsg)
                        block(perStatus.rawValue, false)
                    }
                }
            }
        } else {
            delay(0.2) {
                self.showAccessPopup(title: kPhotosAccessTitle, msg: kPhotosAccessMsg)
                block(status.rawValue, false)
            }
        }
    }
    func timeGapBetweenDates(previousDate : String,currentDate : String)  -> (Int, Int, Int)
    {
        let dateString1 = previousDate
        let dateString2 = currentDate
        
        let Dateformatter = DateFormatter()
        Dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date1 = Dateformatter.date(from: dateString1)
        let date2 = Dateformatter.date(from: dateString2)
        //       startDate = date1!
        //       endDate = Calendar.current.date(byAdding: .day, value: 1, to: date2!)
        let distanceBetweenDates: TimeInterval? = date2?.timeIntervalSince(date1!)
        let secondsInAnHour: Double = 3600
        let minsInAnHour: Double = 60
        let secondsInDays: Double = 86400
        let secondsInWeek: Double = 604800
        let secondsInMonths : Double = 2592000
        let secondsInYears : Double = 31104000
        
        let minBetweenDates = Int((distanceBetweenDates! / minsInAnHour))
        let hoursBetweenDates = Int((distanceBetweenDates! / secondsInAnHour))
        let daysBetweenDates = Int((distanceBetweenDates! / secondsInDays))
        let weekBetweenDates = Int((distanceBetweenDates! / secondsInWeek))
        let monthsbetweenDates = Int((distanceBetweenDates! / secondsInMonths))
        let yearbetweenDates = Int((distanceBetweenDates! / secondsInYears))
        let secbetweenDates = Int(distanceBetweenDates!)
        
        if yearbetweenDates > 0
        {
            print(yearbetweenDates,"years")//0 years
        }
        if monthsbetweenDates > 0
        {
            print(monthsbetweenDates,"months")//0 months
        }
        if weekBetweenDates > 0
        {
            print(weekBetweenDates,"weeks")//0 weeks
        }
        if daysBetweenDates > 0
        {
            print(daysBetweenDates,"days")//5 days
        }
        if hoursBetweenDates > 0
        {
            print(hoursBetweenDates,"hours")//120 hours
        }
        if minBetweenDates > 0
        {
            print(minBetweenDates,"minutes")//7200 minutes
        }
        if secbetweenDates > 0
        {
            print(secbetweenDates,"seconds")//seconds
        }
        //       totalSecond = hoursBetweenDates
        //       totalDay = -daysBetweenDates
//        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: secbetweenDates)
        
        let totalHour = 0 // -(seconds / 3600)
        //       }
        let totalMin = -((secbetweenDates % 3600) / 60)
        let totalSecond = -((secbetweenDates % 3600) % 60)
        print(totalHour, totalMin, totalSecond)
        
        return (totalHour, totalMin, totalSecond)
        //       if date1?.compare(date2!) == .orderedDescending  {
        //         startTimer()
        //       } else {
        ////         viewTimer.isHidden = true
        ////         viewMeeting.isHidden = false
        //       }
    }
    
//    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
//        //       if totalDay > 0 {
//        //         totalHour = (-(seconds / 3600)) - (totalDay*24)
//        //       } else {
//        totalHour = 0 // -(seconds / 3600)
//        //       }
//        totalMin = -((seconds % 3600) / 60)
//        totalSecond = -((seconds % 3600) % 60)
//        return (totalHour, totalMin, totalSecond)
//    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
