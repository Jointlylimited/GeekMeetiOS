//
//  stickerView.swift
//  stickerTextView
//
//  Created by 刘业臻 on 16/4/20.
//  Copyright © 2016年 luiyezheng. All rights reserved.
//

import UIKit

public class JLStickerImageView: UIImageView, UIGestureRecognizerDelegate {
    public var currentlyEditingLabel: JLStickerLabelView!
    fileprivate var labels: [JLStickerLabelView]!
    private var renderedView: UIView!
    
    fileprivate lazy var tapOutsideGestureRecognizer: UITapGestureRecognizer! = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(JLStickerImageView.tapOutside))
        tapGesture.delegate = self
        return tapGesture
        
    }()
    
    //MARK: -
    //MARK: init
    
    init() {
        super.init(frame: CGRect.zero)
        isUserInteractionEnabled = true
        labels = []
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        labels = []
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isUserInteractionEnabled = true
        labels = []
    }
    
}

//MARK: -
//MARK: Functions
extension JLStickerImageView {
    
    public func addLabel(text : String, font : String) {
        if let label: JLStickerLabelView = currentlyEditingLabel {
            label.hideEditingHandlers()
        }
        
        let labelFrame = CGRect(x: self.bounds.midX - CGFloat(arc4random()).truncatingRemainder(dividingBy: 20),
                                    y: self.bounds.midY - CGFloat(arc4random()).truncatingRemainder(dividingBy: 20),
                                    width: 60, height: 50)
        let labelView = JLStickerLabelView(frame: labelFrame)
        labelView.setupTextLabel()
        labelView.delegate = self
        labelView.showsContentShadow = false
        labelView.borderColor = UIColor.white
        labelView.labelTextView?.text = text
        labelView.labelTextView?.fontName = font
        self.addSubview(labelView)
        currentlyEditingLabel = labelView
        adjustsWidthToFillItsContens(currentlyEditingLabel)
        labels.append(labelView)
        
        self.addGestureRecognizer(tapOutsideGestureRecognizer)
    }
    
    public func addImage(image : UIImage) {
        if let label: JLStickerLabelView = currentlyEditingLabel {
            label.hideEditingHandlers()
        }
        
        let labelFrame = CGRect(x: self.bounds.midX - CGFloat(arc4random()).truncatingRemainder(dividingBy: 20),
                                y: self.bounds.midY - CGFloat(arc4random()).truncatingRemainder(dividingBy: 20),
                                width: 60, height: 50)
        let labelView = JLStickerLabelView(frame: labelFrame)
        labelView.setupImageLabel()
        labelView.showsContentShadow = false
        labelView.borderColor = UIColor.white
        self.addSubview(labelView)
        currentlyEditingLabel = labelView
        adjustsWidthToFillItsContens(currentlyEditingLabel)
        labels.append(labelView)
        
        self.addGestureRecognizer(tapOutsideGestureRecognizer)
    }
    
    public func resizeImage(transform : CGAffineTransform, frame : CGRect)  -> UIImage? {
        let degrees : CGFloat = CGFloat(atan2f(Float(transform.b), Float(transform.a)))
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0)
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: self.bounds.size))
        let t = CGAffineTransform(rotationAngle: degrees);
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap?.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0);
        
        // Rotate the image context
        bitmap?.rotate(by: degrees);
        
        // Now, draw the rotated/scaled image into the context
        bitmap?.scaleBy(x: 1.0, y: -1.0)
        bitmap?.draw((self.image?.cgImage!)!, in: CGRect(x: -frame.width/2, y: -frame.width/2, width: frame.width, height:frame.height))
//        bitmap?.draw((self.image?.cgImage!)!, in: CGRect(x: frame.x, y: -(frame.width/2 + frame.y), width: frame.width, height:frame.height))
        //
        //        // Get the resized image from the context and a UIImage
        let newImage:UIImage = UIImage(cgImage: bitmap!.makeImage()!)
        self.image = newImage
        return newImage
    }
    
    public func renderContentOnView() -> UIImage? {
        
        self.cleanup()
        print(" Image 1 : \(self.image)")
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        print("Image 2 : \(self.image)")
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return img
    }
    
    public func limitImageViewToSuperView() {
        if self.superview == nil {
            return
        }
        guard let imageSize = self.image?.size else {
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = true
        let aspectRatio = imageSize.width / imageSize.height
        
        if imageSize.width > imageSize.height {
            self.bounds.size.width = self.superview!.bounds.size.width
            self.bounds.size.height = self.superview!.bounds.size.width / aspectRatio
        }else {
            self.bounds.size.height = self.superview!.bounds.size.height
            self.bounds.size.width = self.superview!.bounds.size.height * aspectRatio
        }
    }
    
    // MARK: -
    
    func cleanup() {
        for label in labels {
            if let isEmpty = label.labelTextView?.text.isEmpty, isEmpty {
                label.closeTap(nil)
            } else {
                label.hideEditingHandlers()
            }
        }
    }
}

//MARK-
//MARK: Gesture
extension JLStickerImageView {
    @objc func tapOutside() {
        if let _: JLStickerLabelView = currentlyEditingLabel {
            currentlyEditingLabel.hideEditingHandlers()
        }
        
    }
}

//MARK-
//MARK: stickerViewDelegate
extension JLStickerImageView: JLStickerLabelViewDelegate {
    public func labelViewDidBeginEditing(_ label: JLStickerLabelView) {
        //labels.removeObject(label)
        
    }
    
    public func labelViewDidClose(_ label: JLStickerLabelView) {
        
    }
    
    public func labelViewDidShowEditingHandles(_ label: JLStickerLabelView) {
        currentlyEditingLabel = label
        
    }
    
    public func labelViewDidHideEditingHandles(_ label: JLStickerLabelView) {
        currentlyEditingLabel = nil
        
    }
    
    public func labelViewDidStartEditing(_ label: JLStickerLabelView) {
        currentlyEditingLabel = label
        
    }
    
    public func labelViewDidChangeEditing(_ label: JLStickerLabelView) {
        
    }
    
    public func labelViewDidEndEditing(_ label: JLStickerLabelView) {
        
        
    }
    
    public func labelViewDidSelected(_ label: JLStickerLabelView) {
        for labelItem in labels {
            labelItem.hideEditingHandlers()
        }
        label.showEditingHandles()
    }
    
}

//MARK: -
//MARK: Set propeties

extension JLStickerImageView: adjustFontSizeToFillRectProtocol {
    
    public enum textShadowPropterties {
        case offSet(CGSize)
        case color(UIColor)
        case blurRadius(CGFloat)
    }
    
    public var fontName: String! {
        set {
            if self.currentlyEditingLabel != nil {
                self.currentlyEditingLabel.labelTextView?.fontName = newValue
                adjustsWidthToFillItsContens(currentlyEditingLabel)
            }
        }
        get {
            return self.currentlyEditingLabel.labelTextView?.fontName
        }
    }
    
    public var textColor: UIColor! {
        set {
            if self.currentlyEditingLabel != nil {
                self.currentlyEditingLabel.labelTextView?.foregroundColor = newValue
            }
        }
        get {
            return self.currentlyEditingLabel.labelTextView?.foregroundColor
        }
    }
    
    public var textAlpha: CGFloat! {
        set {
            if self.currentlyEditingLabel != nil {
                self.currentlyEditingLabel.labelTextView?.textAlpha = newValue
            }
            
        }
        get {
            return self.currentlyEditingLabel.labelTextView?.textAlpha
        }
    }
    
    //MARK: -
    //MARK: text Format
    
    public var textAlignment: NSTextAlignment! {
        set {
            if self.currentlyEditingLabel != nil {
                self.currentlyEditingLabel.labelTextView?.alignment = newValue
            }
            
        }
        get {
            return self.currentlyEditingLabel.labelTextView?.alignment
        }
    }
    
    public var lineSpacing: CGFloat! {
        set {
            if self.currentlyEditingLabel != nil {
                self.currentlyEditingLabel.labelTextView?.lineSpacing = newValue
                adjustsWidthToFillItsContens(currentlyEditingLabel)
            }
            
        }
        get {
            return self.currentlyEditingLabel.labelTextView?.lineSpacing
            
        }
    }
    
    //MARK: -
    //MARK: text Background
    
    public var textBackgroundColor: UIColor! {
        set {
            if self.currentlyEditingLabel != nil {
                self.currentlyEditingLabel.labelTextView?.textBackgroundColor = newValue
            }
            
        }
        
        get {
            return self.currentlyEditingLabel.labelTextView?.textBackgroundColor
        }
    }
    
    public var textBackgroundAlpha: CGFloat! {
        set {
            if self.currentlyEditingLabel != nil {
                self.currentlyEditingLabel.labelTextView?.textBackgroundAlpha = newValue
            }
            
        }
        get {
            return self.currentlyEditingLabel.labelTextView?.textBackgroundAlpha
            
        }
    }
    
    //MARK: -
    //MARK: text shadow
    
    public var textShadowOffset: CGSize! {
        set {
            if self.currentlyEditingLabel != nil {
                self.currentlyEditingLabel.labelTextView?.textShadowOffset = newValue
            }
            
        }
        get {
            return self.currentlyEditingLabel.labelTextView?.shadow?.shadowOffset
        }
    }
    
    public var textShadowColor: UIColor! {
        set {
            if self.currentlyEditingLabel != nil {
                self.currentlyEditingLabel.labelTextView?.textShadowColor = newValue
            }
            
        }
        get {
            return (self.currentlyEditingLabel.labelTextView?.shadow?.shadowColor) as? UIColor
        }
    }
    
    public var textShadowBlur: CGFloat! {
        set {
            if self.currentlyEditingLabel != nil {
                self.currentlyEditingLabel.labelTextView?.textShadowBlur = newValue
            }
            
        }
        get {
            return self.currentlyEditingLabel.labelTextView?.shadow?.shadowBlurRadius
        }
    }
}
