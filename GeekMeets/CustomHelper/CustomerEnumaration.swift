import Foundation
import UIKit

//MARK:- CarRental SideMenu Option with Title and Segue

enum CustomerSideMenu
{
    case home
    case myProfile
    case myFavorites
    case myBooking
    case allCategories
    case setting
    case notifications
    case addMissingBussiness
    case registerProvider
    
    var sideMenuTitle : String{
        switch self
        {
        case .home:
            return "Home"
            
        case .myProfile:
            return "My Profile"
            
        case .myFavorites:
            return "My Favorites"
            
        case .myBooking:
            return "My Bookings"
            
        case .allCategories:
            return "All Categories"
            
        case .setting:
            return "Settings"
            
        case .notifications:
            return "Notifications"
            
        case .addMissingBussiness:
            return "Add Missing Business"
            
        case .registerProvider:
            return "Registered as Provider"
            
        }
    }
    
    var sideMenuSegue : String{
        switch self
        {
        case .home:
            return "homeSegue"
            
        case .myProfile:
            return "myProfileSegue"
            
        case .myFavorites:
            return "myFavoriteSegue"
            
        case .myBooking:
            return "myBookingSegue"
            
        case .allCategories:
            return "allCategorySegue"
            
        case .setting:
            return "settingSegue"
            
        case .notifications:
            return "notificationSegue"
            
        case .addMissingBussiness:
            return "addMissingBussinessSegue"
            
        case .registerProvider:
            return "registerProviderSegue"
            
        }
    }
    
    var sideMenuIcon : UIImage
    {
        switch self
        {
        case .home:
            return #imageLiteral(resourceName: "icn_home")
            
        case .myProfile:
            return #imageLiteral(resourceName: "icn_profile")

        case .myFavorites:
            return #imageLiteral(resourceName: "icn_favorite")

        case .myBooking:
            return #imageLiteral(resourceName: "icn_my_tickets")

        case .allCategories:
            return #imageLiteral(resourceName: "icn_all_categories")

        case .setting:
            return #imageLiteral(resourceName: "icn_settings")

        case .notifications:
            return #imageLiteral(resourceName: "icn_notification-1")

        case .addMissingBussiness:
            return #imageLiteral(resourceName: "icn_add_workplace_small")

        case .registerProvider:
            return #imageLiteral(resourceName: "icn_provider")

        }
    }
}

//MARK:- Language Data

enum LanguageData {
    case arabic
    case english
    case french
    case spanish
    case german
    case italian
    case turkish
    case russia
    
    var name : String{
        switch self {
        case .arabic:
            return "Arabic"
        case .english:
            return "English"
        case .french:
            return "French"
        case .spanish:
            return "Spanish"
        case .german:
            return "German"
        case .italian:
            return "Italian"
        case .turkish:
            return "Turkish"
        case .russia:
            return "Russian"
        }
    }
    var currencyCode : String{
        switch self {
        case .arabic:
            return "AED"
        case .english:
            return "USD"
        case .french:
            return "EUR"
        case .spanish:
            return "ESP"
        case .german:
            return "EUR"
        case .italian:
            return "EUR"
        case .turkish:
            return "TRY"
        case .russia:
            return "RUB"
        }
    }
    
    var languageCode : String{
        switch self {
        case .arabic:
            return "ar"
        case .english:
            return "en"
        case .french:
            return "fr"
        case .spanish:
            return "es"
        case .german:
            return "de"
        case .italian:
            return "it"
        case .turkish:
            return "tr"
        case .russia:
            return "ru"
        }
    }
    
    var image : UIImage{
        switch self {
        case .arabic:
            return #imageLiteral(resourceName: "img_arabic")
        case .english:
            return #imageLiteral(resourceName: "img_english")
        case .french:
            return #imageLiteral(resourceName: "img_french")
        case .spanish:
            return #imageLiteral(resourceName: "img_spanish")
        case .german:
            return #imageLiteral(resourceName: "img_german")
        case .italian:
            return #imageLiteral(resourceName: "img_italian")
        case .turkish:
            return #imageLiteral(resourceName: "img_turkish")
        case .russia:
            return #imageLiteral(resourceName: "img_russian")
        }
    }
}

//MARK:- Tutorial Data

enum TutorialData {
    case firstPage
    case secondPage
    case thirdPage
    
    var pageTitle : String{
        switch self {
        case .firstPage:
            return "Find people You Like nearby     "
        case .secondPage:
            return "Match & Chat with new people     "
        case .thirdPage:
            return "Meet your Match and have fun!!     "
        }
    }
    
    var pageDescription : String{
        switch self {
        case .firstPage:
            return "Best Dating app to meet, chat, date and hangout with people near you"
        case .secondPage:
            return "Best Dating app to meet, chat, date and hangout with people near you"
        case .thirdPage:
            return "Best Dating app to meet, chat, date and hangout with people near you"
        }
    }
    
    var pageImage : UIImage{
        switch self {
        case .firstPage:
            return #imageLiteral(resourceName: "img_intro_1")
        case .secondPage:
            return #imageLiteral(resourceName: "img_intro_2")
        case .thirdPage:
            return #imageLiteral(resourceName: "img_intro_3")
        }
    }
}

enum ContentPage: String{
    case privacy = "privacy-policy"
    case termsConditions = "terms"
}

//MARK:- Setting Data
enum SettingOption {
    case notification
    case changePW
    case viewAppFetures
    case rateUs
    case privacyPolicy
    case contactUs
    case terms
    case logout
    
    var slug : String{
        switch self {
        case .privacyPolicy:
            return "privacy-policy"
        case .terms:
            return "terms"
        default:
            return ""
        }
    }
    
    var title : String{
        switch self {
        case .notification:
            return "Notifications"
        case .changePW:
            return "Change Password"
        case .viewAppFetures:
            return "View App Features"
        case .rateUs:
        return "Rate Us"
        case .privacyPolicy:
            return "Privacy Policy"
        case .terms:
            return "Terms & conditions"
        case .contactUs:
            return "Contact Us"
        case .logout:
            return "Logout"
            

        }
    }
    
    var sideDiscloser : settingDisclouser{
        switch self {
        case .notification:
            return .switchMenu
        case .changePW:
            return .arrow
        case .viewAppFetures:
            return .none
        case .rateUs:
            return .none
        case .privacyPolicy:
            return .arrow
        case .terms:
            return .arrow
        case .contactUs:
            return .arrow
        case .logout:
            return .none
        }
    }
}


enum settingDisclouser{
    case switchMenu
    case arrow
    case none
}

enum SettingData {
  
    case firstSection
    case secondSection
    
    var settingData : [SettingOption]{
        switch self {
          
        case .firstSection:
//            return currentCustomerUser.tiIsSocialLogin == 1 ? [.notification, .viewAppFetures] : [.notification, .changePW, .viewAppFetures]
              return [.rateUs, .privacyPolicy, .terms, .contactUs, .logout]
        case .secondSection:
            return [.rateUs, .privacyPolicy, .terms, .contactUs, .logout]
          
        }
    }
    
    var sectionTitle : String{
        switch self {
        case .firstSection:
            return ""
        case .secondSection:
            return "About"
        }
    }
}

//MARK:- Gender Data
enum Gender {
    case male
    case female
    case other
    
    var title : String{
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        case .other:
            return "Other"
        }
    }
    
    var genderValue : Int{
        switch self {
        case .male:
            return 1
        case .female:
            return 2
        case .other:
            return 3
        }
    }
}
