//
//  UITapGestureRecognizerExtensions.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 15/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import Foundation
import UIKit
extension UITapGestureRecognizer {

   func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
       // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
    
       let layoutManager = NSLayoutManager()
       let textContainer = NSTextContainer(size: CGSize.zero)
       let textStorage = NSTextStorage(attributedString: label.attributedText!)

       // Configure layoutManager and textStorage
       layoutManager.addTextContainer(textContainer)
       textStorage.addLayoutManager(layoutManager)

       // Configure textContainer
       textContainer.lineFragmentPadding = 0.0
       textContainer.lineBreakMode = label.lineBreakMode
       textContainer.maximumNumberOfLines = label.numberOfLines
       let labelSize = label.bounds.size
       textContainer.size = labelSize

       // Find the tapped character location and compare it to the specified range
    let locationOfTouchInLabel = self.location(in: label)
    let textBoundingBox = layoutManager.usedRect(for: textContainer)
    let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                      y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
    let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                 y: locationOfTouchInLabel.y - textContainerOffset.y);
    let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

       return NSLocationInRange(indexOfCharacter, targetRange)
   }
}

extension TimeZone {

    func offsetFromUTC() -> String
    {
        let localTimeZoneFormatter = DateFormatter()
        localTimeZoneFormatter.timeZone = self
        localTimeZoneFormatter.dateFormat = "Z"
        return localTimeZoneFormatter.string(from: Date())
    }

    func offsetInHours() -> String
    {

        let hours = secondsFromGMT()/3600
        let minutes = abs(secondsFromGMT()/60) % 60
        let tz_hr = String(format: "%+.2d:%.2d", hours, minutes) // "+hh:mm"
        return tz_hr
    }
    
    func getCurrentTimeZone() -> String {
        let localTimeZoneAbbreviation: Int = TimeZone.current.secondsFromGMT()
        let items = (localTimeZoneAbbreviation / 3600)
        return "\(items)"
    }
}
