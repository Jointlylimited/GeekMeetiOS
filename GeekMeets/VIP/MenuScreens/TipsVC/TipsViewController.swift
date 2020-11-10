//
//  TipsViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 16/07/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class TipsViewController: UIViewController {
    
    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var lblScreenTitle: UILabel!
    
    var pageMenu : CAPSPageMenu?
    var firstCallVC: FirstCallViewController!
    var firstDateVC: FirstDateViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI()
    {
        var controllerArray : [UIViewController] = []
        
        firstCallVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.FirstCallScreen) as! FirstCallViewController
        firstCallVC.title = "First Call"
        firstCallVC.parentNavigationController = self.navigationController
        controllerArray.append(firstCallVC)
        
        firstDateVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.FirstDateScreen) as! FirstDateViewController
        firstDateVC.title = "First Date"
        firstDateVC.parentNavigationController = self.navigationController
        controllerArray.append(firstDateVC)
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            //.bottomMenuHairlineColor(UIColor(red: 186/255, green: 0/255, blue: 0/255, alpha: 1)),
            .selectionIndicatorColor(AppCommonColor.firstGradient),
            .menuMargin(0.5),
            .menuHeight(50.0),
            .selectedMenuItemLabelColor(AppCommonColor.firstGradient),
            .unselectedMenuItemLabelColor(UIColor.black),
            .menuItemFont(UIFont(name: "Poppins-SemiBold", size: 14.0)!),
            .selectMenuItemFont(UIFont(name: "Poppins-SemiBold", size: 16.0)!),
            .titleTextSizeBasedOnMenuItemWidth(true),
            .centerMenuItems(true),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorRoundEdges(true),
            .selectionIndicatorHeight(3.0),
            .menuItemSeparatorPercentageHeight(0)
        ]
        
        self.navBar?.barTintColor = UIColor(red: 186/255, green: 0/255, blue: 0/255, alpha: 1)
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: DeviceType.hasNotch ? (viewNavigation?.frame.height)! + 44 : ((viewNavigation?.frame.height)! + 24), width: self.view.frame.width, height: ((self.view.frame.height - 44)  - 50)), pageMenuOptions: parameters)
        
        // Optional delegate
        pageMenu!.delegate = self
        self.view.addSubview(pageMenu!.view)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.popVC()
    }
}

extension TipsViewController : CAPSPageMenuDelegate {
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        if index == 0 {
            print("First Call")
        } else if index == 1 {
            print("First Date")
        } else {
            
        }
    }
}
