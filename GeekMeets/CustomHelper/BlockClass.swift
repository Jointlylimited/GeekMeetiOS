
//  Copyright © 2016 myCompany. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class BlockClass: NSObject
{
    
    typealias ReloadSideMenuHomeView = () -> Void
    var sideMenuHomeReloadData : ReloadSideMenuHomeView?
    
    typealias UpdateLocationValue = (_ currentCordinate : CLLocationCoordinate2D, _ cityName : String) -> Void
    var updateLocation : UpdateLocationValue?

    typealias ReloadSideMenuFavouriteView = () -> Void
    var sideMenuFavReloadData : ReloadSideMenuFavouriteView?

    typealias ReloadSideMenuBookingView = () -> Void
    var sideMenuBookingReloadData : ReloadSideMenuBookingView?
    
    typealias ReloadSideMenuProfileView = () -> Void
    var sideMenuProfileReloadData : ReloadSideMenuProfileView?
    
    typealias ReloadSideMenuNotificationView = () -> Void
    var sideMenuNotificationReloadData : ReloadSideMenuNotificationView?
    
    typealias ReloadSideMenuAddMissingBusiness = () -> Void
    var sideMenuMissingBusinesReloadData : ReloadSideMenuAddMissingBusiness?
    
    typealias sideMenuButtonClick = () -> Void
    var clickOnSideMenu : sideMenuButtonClick?
    
    typealias carRentalDoneButton = (_ pickerviewTag : Int?) -> Void
    var carRentalDoneClick : carRentalDoneButton?
    
   
    
    static var instanceBlockClass: BlockClass!

    class func sharedInstanceBlockClass() -> BlockClass {
        self.instanceBlockClass = (self.instanceBlockClass ?? BlockClass())
        return self.instanceBlockClass
    }
}
