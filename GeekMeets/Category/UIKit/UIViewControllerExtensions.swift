//
//  UIViewControllerExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 15/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.

#if os(iOS) || os(tvOS)

import UIKit

extension UIViewController {
    // MARK: - Notifications
    
    ///EZSE: Adds an NotificationCenter with name and Selector
    open func addNotificationObserver(_ name: String, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    ///EZSE: Removes an NSNotificationCenter for name
    open func removeNotificationObserver(_ name: String) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    ///EZSE: Removes NotificationCenter'd observer
    open func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    #if os(iOS)
    
//    ///EZSE: Adds a NotificationCenter Observer for keyboardWillShowNotification()
//    ///
//    /// ⚠️ You also need to implement ```keyboardWillShowNotification(_ notification: Notification)```
//    open func addKeyboardWillShowNotification() {
//        self.addNotificationObserver(NSNotification.Name.UIKeyboardWillShow.rawValue, selector: #selector(UIViewController.keyboardWillShowNotification(_:)))
//    }
//    
//    ///EZSE:  Adds a NotificationCenter Observer for keyboardDidShowNotification()
//    ///
//    /// ⚠️ You also need to implement ```keyboardDidShowNotification(_ notification: Notification)```
//    public func addKeyboardDidShowNotification() {
//        self.addNotificationObserver(NSNotification.Name.UIKeyboardDidShow.rawValue, selector: #selector(UIViewController.keyboardDidShowNotification(_:)))
//    }
//    
//    ///EZSE:  Adds a NotificationCenter Observer for keyboardWillHideNotification()
//    ///
//    /// ⚠️ You also need to implement ```keyboardWillHideNotification(_ notification: Notification)```
//    open func addKeyboardWillHideNotification() {
//        self.addNotificationObserver(NSNotification.Name.UIKeyboardWillHide.rawValue, selector: #selector(UIViewController.keyboardWillHideNotification(_:)))
//    }
//    
//    ///EZSE:  Adds a NotificationCenter Observer for keyboardDidHideNotification()
//    ///
//    /// ⚠️ You also need to implement ```keyboardDidHideNotification(_ notification: Notification)```
//    open func addKeyboardDidHideNotification() {
//        self.addNotificationObserver(NSNotification.Name.UIKeyboardDidHide.rawValue, selector: #selector(UIViewController.keyboardDidHideNotification(_:)))
//    }
//    
//    ///EZSE: Removes keyboardWillShowNotification()'s NotificationCenter Observer
//    open func removeKeyboardWillShowNotification() {
//        self.removeNotificationObserver(NSNotification.Name.UIKeyboardWillShow.rawValue)
//    }
//    
//    ///EZSE: Removes keyboardDidShowNotification()'s NotificationCenter Observer
//    open func removeKeyboardDidShowNotification() {
//        self.removeNotificationObserver(NSNotification.Name.UIKeyboardDidShow.rawValue)
//    }
//    
//    ///EZSE: Removes keyboardWillHideNotification()'s NotificationCenter Observer
//    open func removeKeyboardWillHideNotification() {
//        self.removeNotificationObserver(NSNotification.Name.UIKeyboardWillHide.rawValue)
//    }
//    
//    ///EZSE: Removes keyboardDidHideNotification()'s NotificationCenter Observer
//    open func removeKeyboardDidHideNotification() {
//        self.removeNotificationObserver(NSNotification.Name.UIKeyboardDidHide.rawValue)
//    }
    
    @objc open func keyboardDidShowNotification(_ notification: Notification) {
        if let nInfo = (notification as NSNotification).userInfo, let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let frame = value.cgRectValue
            keyboardDidShowWithFrame(frame)
        }
    }
    
    @objc open func keyboardWillShowNotification(_ notification: Notification) {
        if let nInfo = (notification as NSNotification).userInfo, let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let frame = value.cgRectValue
            keyboardWillShowWithFrame(frame)
        }
    }
    
    @objc open func keyboardWillHideNotification(_ notification: Notification) {
        if let nInfo = (notification as NSNotification).userInfo, let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let frame = value.cgRectValue
            keyboardWillHideWithFrame(frame)
        }
    }
    
    @objc open func keyboardDidHideNotification(_ notification: Notification) {
        if let nInfo = (notification as NSNotification).userInfo, let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let frame = value.cgRectValue
            keyboardDidHideWithFrame(frame)
        }
    }
    
    open func keyboardWillShowWithFrame(_ frame: CGRect) {
        
    }
    
    open func keyboardDidShowWithFrame(_ frame: CGRect) {
        
    }
    
    open func keyboardWillHideWithFrame(_ frame: CGRect) {
        
    }
    
    open func keyboardDidHideWithFrame(_ frame: CGRect) {
        
    }
    
    //EZSE: Makes the UIViewController register tap events and hides keyboard when clicked somewhere in the ViewController.
    open func hideKeyboardWhenTappedAround(cancelTouches: Bool = false) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = cancelTouches
        view.addGestureRecognizer(tap)
    }
    
    #endif
    
    //EZSE: Dismisses keyboard
    @objc open func dismissKeyboard() {
        view.endEditing(true)
    }
    
  
     //MARK:- NavigationBar Button
        
        
        var leftSideBackBarButton: UIBarButtonItem {
            let button = UIBarButtonItem(image: #imageLiteral(resourceName: "icn_snapchat"), style: .plain, target: self, action: #selector(self.popVC))
            button.image = #imageLiteral(resourceName: "icn_back").withRenderingMode(.alwaysOriginal)
//            if isCurrentArabicLanguage
//            {
//                button.image = button.image?.withHorizontallyFlippedOrientation()
//            }
            return button;
        }
        
        var leftSideRootViewBackButton: UIBarButtonItem {
            let button = UIBarButtonItem(image: #imageLiteral(resourceName: "icn_back"), style: .plain, target: self, action: #selector(self.popToRootVC))
            button.image = #imageLiteral(resourceName: "icn_back").withRenderingMode(.alwaysOriginal)
//            if isCurrentArabicLanguage
//            {
//                button.image = button.image?.withHorizontallyFlippedOrientation()
//            }
            return button;
        }
        
        var leftSideMenuBarButton: UIBarButtonItem
        {
            let button = UIBarButtonItem(image: #imageLiteral(resourceName: "icn_menu"), style: .plain, target: self, action: #selector(self.btnSideMenuClick(sender:)))
            button.image = #imageLiteral(resourceName: "icn_menu").withRenderingMode(.alwaysOriginal)
//            if isCurrentArabicLanguage
//            {
//                button.image =  button.image?.withHorizontallyFlippedOrientation()
//            }
            return button;
        }
        
        @objc func btnSideMenuClick(sender: UIBarButtonItem)
        {
//            if sender.isEnabled {
//               sender.isEnabled = false
//                 BlockClass.sharedInstanceBlockClass().clickOnSideMenu!()
//                delay(0.5) {
//                     sender.isEnabled = true
//                }
//               
//            }
           
        }
        
        var rightSideBarButton: UIBarButtonItem
        {
            let button = UIBarButtonItem(image: #imageLiteral(resourceName: "icn_notification"), style: .plain, target: self, action: #selector(self.btnRightSideClick))
            button.image = #imageLiteral(resourceName: "icn_notification").withRenderingMode(.alwaysOriginal)
            return button;
        }
        
        @objc func btnRightSideClick()
        {
    //        BlockClass.sharedInstanceBlockClass().clickOnSideMenu!()
        }
  
  
    // MARK: - VC Container
    
    ///EZSE: Returns maximum y of the ViewController
    open var top: CGFloat {
        if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
            return visibleViewController.top
        }
        if let nav = self.navigationController {
            if nav.isNavigationBarHidden {
                return view.top
            } else {
                return nav.navigationBar.bottom
            }
        } else {
            return view.top
        }
    }
    
    ///EZSE: Returns minimum y of the ViewController
    open var bottom: CGFloat {
        if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
            return visibleViewController.bottom
        }
        if let tab = tabBarController {
            if tab.tabBar.isHidden {
                return view.bottom
            } else {
                return tab.tabBar.top
            }
        } else {
            return view.bottom
        }
    }
    
    ///EZSE: Returns Tab Bar's height
    open var tabBarHeight: CGFloat {
        if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
            return visibleViewController.tabBarHeight
        }
        if let tab = self.tabBarController {
            return tab.tabBar.frame.size.height
        }
        return 0
    }
    
    ///EZSE: Returns Navigation Bar's height
    open var navigationBarHeight: CGFloat {
        if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
            return visibleViewController.navigationBarHeight
        }
        if let nav = self.navigationController {
            return nav.navigationBar.h
        }
        return 0
    }
    
    ///EZSE: Returns Navigation Bar's color
    open var navigationBarColor: UIColor? {
        get {
            if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
                return visibleViewController.navigationBarColor
            }
            return navigationController?.navigationBar.tintColor
        } set(value) {
            navigationController?.navigationBar.barTintColor = value
        }
    }
    
    ///EZSE: Returns current Navigation Bar
    open var navBar: UINavigationBar? {
        return navigationController?.navigationBar
    }
    
    /// EZSwiftExtensions
    open var applicationFrame: CGRect {
        return CGRect(x: view.x, y: top, width: view.w, height: bottom - top)
    }
    
    // MARK: - VC Flow
    
    ///EZSE: Pushes a view controller onto the receiver’s stack and updates the display.
    open func pushVC(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///EZSE: Pops the top view controller from the navigation stack and updates the display.
  @objc open func popVC() {
        _ = navigationController?.popViewController(animated: true)
    }

    func pop(toLast controller: AnyClass) {
       for con in self.navigationController!.viewControllers as Array {
            if con.isKind(of: controller.self) {
                self.navigationController!.popToViewController(con, animated: true)
                break
            }
        }
    }
    
    /// EZSE: Hide or show navigation bar
    public var isNavBarHidden: Bool {
        get {
            return (navigationController?.isNavigationBarHidden)!
        }
        set {
            navigationController?.isNavigationBarHidden = newValue
        }
    }
    
    /// EZSE: Added extension for popToRootViewController
  @objc open func popToRootVC() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    ///EZSE: Presents a view controller modally.
    open func presentVC(_ vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }
    
    ///EZSE: Dismisses the view controller that was presented modally by the view controller.
    open func dismissVC(completion: (() -> Void)? ) {
        dismiss(animated: true, completion: completion)
    }
    
    ///EZSE: Adds the specified view controller as a child of the current view controller.
    open func addAsChildViewController(_ vc: UIViewController, toView: UIView) {
        self.addChild(vc)
        toView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    ///EZSE: Adds image named: as a UIImageView in the Background
    open func setBackgroundImage(_ named: String) {
        let image = UIImage(named: named)
        let imageView = UIImageView(frame: view.frame)
        imageView.image = image
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }
    
    ///EZSE: Adds UIImage as a UIImageView in the Background
    @nonobjc func setBackgroundImage(_ image: UIImage) {
        let imageView = UIImageView(frame: view.frame)
        imageView.image = image
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }
    
    /// SwifterSwift: Check if ViewController is onscreen and not hidden.
    public var isVisible: Bool {
        // http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
        return self.isViewLoaded && view.window != nil
    }
    
    /// SwifterSwift: Helper method to display an alert on any UIViewController subclass. Uses UIAlertController to show an alert
    ///
    /// - Parameters:
    ///   - title: title of the alert
    ///   - message: message/body of the alert
    ///   - buttonTitles: (Optional)list of button titles for the alert. Default button i.e "OK" will be shown if this paramter is nil
    ///   - highlightedButtonIndex: (Optional) index of the button from buttonTitles that should be highlighted. If this parameter is nil no button will be highlighted
    ///   - completion: (Optional) completion block to be invoked when any one of the buttons is tapped. It passes the index of the tapped button as an argument
    /// - Returns: UIAlertController object (discardable).
    @discardableResult public func showAlert(title: String?, message: String?, buttonTitles: [String]? = nil, highlightedButtonIndex: Int? = nil, completion: ((Int) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var allButtons = buttonTitles ?? [String]()
        if allButtons.count == 0 {
            allButtons.append("OK")
        }
        
        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                completion?(index)
            })
            alertController.addAction(action)
            // Check which button to highlight
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                if #available(iOS 9.0, *) {
                    alertController.preferredAction = action
                }
            }
        }
        present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    #if os(iOS)

    @available(*, deprecated)
    public func hideKeyboardWhenTappedAroundAndCancelsTouchesInView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    #endif
}

#endif
