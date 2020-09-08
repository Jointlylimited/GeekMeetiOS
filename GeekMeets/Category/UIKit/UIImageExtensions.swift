//
//  UIImageExtensions.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 14/05/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import Photos
import ImageIO
import Accelerate

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}


// MARK: Custom UItextfield Initilizers
extension UIImageView {
    func set(with urlString: String){
        guard let url = URL.init(string: urlString) else {
            return
        }
        let resource = ImageResource(downloadURL: url, cacheKey: urlString)
        var kf = self.kf
        kf.indicatorType = .activity
        self.kf.setImage(with: resource)
    }
   
    func setImage(with urlString: String?, placeHolder: UIImage? = #imageLiteral(resourceName: "placeholder_rect"), showActivity: Bool = true){
        let imgUrl = URL(string: urlString ?? "")
        var kf = self.kf
        kf.indicatorType = showActivity ? .activity : .none
        self.kf.setImage(with: imgUrl, placeholder: placeHolder)
        
    }
  
    func setUserImage(with urlString: String?, placeHolder: UIImage? = #imageLiteral(resourceName: "placeholder_rect"), showActivity: Bool = true){
      let imgUrl = URL(string: urlString ?? "")
      var kf = self.kf
      kf.indicatorType = showActivity ? .activity : .none
      self.kf.setImage(with: imgUrl, placeholder: placeHolder)
      
    }
  
    func SetImageWithKey(urlString: String,key: String){
        guard let url = URL.init(string: urlString) else {
            return
        }
        let resource = ImageResource(downloadURL: url, cacheKey: key)
        var kf = self.kf
        kf.indicatorType = .activity
        self.kf.setImage(with: resource)
    }
    
}


extension UIImage {
    
    func isEqualToImage(image: UIImage) -> Bool {
        let data1: NSData = self.pngData()! as NSData
        let data2: NSData = image.pngData()! as NSData
        return data1.isEqual(data2)
    }
    
    /// It will used to scale image size to down and maintain image ration.
    ///
    /// - Parameter toWidth: CGFloat type value, expect width
    /// - Returns: UIImage type object
    func scaleWithAspectRatioTo(_ width:CGFloat) -> UIImage {
        let oldWidth = size.width
        let oldHeight = size.height
        if oldHeight < width && oldWidth < width {
            return self
        }
        let scaleFactor = oldWidth > oldHeight ? width/oldWidth : width/oldHeight
        let newHeight = oldHeight * scaleFactor
        let newWidth = oldWidth * scaleFactor;
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    /// It will used to reduce image resolution and maintain aspect ratio.
    ///
    /// - Parameter width: Expected width to reduce resolution
    /// - Returns: UIImage object return
    func scaleAndManageAspectRatio(_ width: CGFloat) -> UIImage {
        if let cgImage = cgImage {
            let oldWidth = size.width
            let oldHeight = size.height
            if oldHeight < width && oldWidth < width {
                return self
            }
            let scaleFactor = oldWidth > oldHeight ? width/oldWidth : width/oldHeight
            let newHeight = oldHeight * scaleFactor
            let newWidth = oldWidth * scaleFactor;
            var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),version: 0, decode: nil, renderingIntent: CGColorRenderingIntent.defaultIntent)
            var sourceBuffer = vImage_Buffer()
            defer {
                sourceBuffer.data.deallocate()
            }
            var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, numericCast(kvImageNoFlags))
            guard error == kvImageNoError else { return self }
            
            // create a destination buffer
            let scale = self.scale
            let destWidth = Int(newWidth)
            let destHeight = Int(newHeight)
            let bytesPerPixel = cgImage.bitsPerPixel/8
            let destBytesPerRow = destWidth * bytesPerPixel
            let destData = UnsafeMutablePointer<UInt8>.allocate(capacity: destHeight * destBytesPerRow)
            defer {
                destData.deallocate()
            }
            var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)
            
            // scale the image
            error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
            guard error == kvImageNoError else { return self }
            
            // create a CGImage from vImage_Buffer
            let destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue()
            guard error == kvImageNoError else { return self }
            
            // create a UIImage
            let imgOutPut = destCGImage.flatMap { (cgImage) -> UIImage? in
                return UIImage(cgImage: cgImage, scale: 0.0, orientation: imageOrientation)
            }
            return imgOutPut ?? self
        }else{
            return self
        }
    }
    
}

// MARK: - Get Image From asset
extension PHAsset {
    func getDisplayImage(size: CGSize, comp: @escaping (UIImage?) -> ()){
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        PHImageManager.default().requestImage(for: self, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, info) -> Void in
            comp(image)
        })
    }
    
    func getFullImage(comp: @escaping (UIImage?) -> ()) {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.isSynchronous = true
        PHImageManager.default().requestImage(for: self, targetSize: _maxImageSize, contentMode: PHImageContentMode.aspectFit, options: options, resultHandler: { (image, info) -> Void in
            comp(image)
        })
        //        PHImageManager.default().requestImageData(for: self, options: options, resultHandler: { (imageData, imageDataUTI, imageOrientation, imageUserInfo) -> Void in
        //            DispatchQueue.main.async(execute: { () -> Void in
        //                if let d = imageData {
        //                    let image = UIImage(data: d)
        //                    comp(image)
        //                } else {
        //                    comp(nil)
        //                }
        //            })
        //        })
    }
}
extension PHAsset {

    func getUIImage(asset: PHAsset) -> UIImage? {

        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in

            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
}
