//
//  URLExtensions.swift
//  SuccessDance
//
//  Created by SOTSYS044 on 15/05/19.
//  Copyright © 2019 SOTSYS203. All rights reserved.
//

import Foundation
import UIKit
import AVKit

extension URL {
    
    func getVideoThumbImage() -> UIImage? {
        let asset = AVAsset(url: self)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        let time = CMTimeMake(value: 1, timescale: 1)
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return  UIImage(cgImage:imageRef)
        } catch let error {
            imageGenerator.cancelAllCGImageGeneration()
            print( "getVideoThumbImage  error : \(error.localizedDescription)")
        }
        return nil
    }
    
    func getVideoData() -> Data? {
        do {
            return try Data(contentsOf: self)
        }catch let error {
            print( "getVideoData error : \(error)")
        }
        return nil
    }
    
    func checkAndDeleteVideoFile() {
        let fileManager = FileManager.default
        let exist = fileManager.fileExists(atPath: path)
        if exist {
            print( "Delete temporary created file : \(path)")
            do {
                try fileManager.removeItem(at: self)
            } catch let error as NSError {
                print( error.localizedDescription)
            }
        }
    }
    
    func checkVideoFileExists() -> Bool {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: path)
    }
    
    func compressVideo(_ outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?, _ compressVideoURL: URL?)-> Void) {
        let urlAsset = AVURLAsset(url: self, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetHighestQuality) else {
            DispatchQueue.main.async {
                handler(nil, nil)
            }
            return
        }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            DispatchQueue.main.async {
                handler(exportSession, outputURL)
            }
        }
    }
    
}
