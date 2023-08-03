//
//  UIAlertControllerExtension.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 28/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    /// This class method extened under UIAlertController which helps you to show UIAlertContol
    ///
    /// - Parameters:
    ///   - title: title for alert
    ///   - message: message for alert
    ///   - style: UIAlertContoller style (actionSheet / alert)
    ///   - buttons: number of button titles needs to add
    ///   - controller: contoller where UIAlertControl to be shown
    ///   - userAction: block which returns user intrected button title (string) to perform any action
    class func showAlertWith(title: String?, message: String?, style: UIAlertController.Style, buttons: [String], controller: UIViewController?, userAction: ((_ action: String) -> ())?) {
        let alertController =
            UIAlertController(title: title, message: message, preferredStyle: style)
        buttons.forEach
            { (buttonTitle) in
                if buttonTitle == "Delete" {
                    alertController.addAction(UIAlertAction(title: buttonTitle, style: .destructive, handler: { (action: UIAlertAction) in
                        userAction? (buttonTitle)
                    }))
                }else if buttonTitle == "Cancel" {
                    alertController.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: { (action: UIAlertAction) in
                        userAction? (buttonTitle)
                    }))
                } else {
                    alertController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { (action: UIAlertAction) in
                        userAction? (buttonTitle)
                    }))
                }
        }
        if let parentController = controller { DispatchQueue.main.async {
            parentController.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
