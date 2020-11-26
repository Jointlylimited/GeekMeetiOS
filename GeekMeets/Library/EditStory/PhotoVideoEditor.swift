//
//  PhotoVideoEditor.swift
//  GeekMeets
//
//  Created by sotsys124 on 25/11/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit
import AVKit
import Photos

class PhotoVideoEditor: NSObject {
    
    static var instance: PhotoVideoEditor!
    
    // Helper function that return a AVMutableComposition instance of the current video
    func getVideoComposition(asset : AVAsset) -> AVMutableComposition {
        
        // Create an AVMutableComposition for editing
        let mixComposition : AVMutableComposition = AVMutableComposition()
        
        // Get video tracks and audio tracks of our video and the AVMutableComposition
        let compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let videoTrack: AVAssetTrack = asset.tracks(withMediaType: .video).first!
        
        var compositionAudioTrack : AVMutableCompositionTrack?
        if asset.tracks(withMediaType: AVMediaType.audio).count > 0 {
            compositionAudioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        }
        
        // Add our video tracks and audio tracks into the Mutable Composition normal order
        if asset.tracks(withMediaType: AVMediaType.audio).count > 0 {
            let audioTrack : AVAssetTrack = asset.tracks(withMediaType: AVMediaType.audio)[0]
            do {
                try compositionAudioTrack!.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: asset.duration), of: audioTrack, at: CMTime.zero)
            } catch let compError {
                print("Add Text: error during audioTrack composition: \(compError)")
                
            }
            //compositionAudioTrack!.preferredTransform = audioTrack.preferredTransform
        }
        
        do {
            try compositionVideoTrack!.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: asset.duration), of: videoTrack, at: CMTime.zero)
        } catch let compError {
            print("Add Text: error during videoTrack composition: \(compError)")
        }
        
        //compositionVideoTrack!.preferredTransform = videoTrack.preferredTransform
        compositionVideoTrack?.preferredTransform = CGAffineTransform(rotationAngle: .pi / 3)
        
        return mixComposition
    }
    
    func AddTextToVideo(strText: String, videoURL: URL, at Position: Int, FontStyle: UIFont, Color: UIColor,/* StartTime: Int, EndTime: Int,*/ success: @escaping ((URL) -> Void), failure: @escaping ((String?) -> Void)) {
        
        let videoAsset = AVAsset(url: videoURL)
        let videoSize = videoAsset.tracks(withMediaType: AVMediaType.video)[0].naturalSize
        
        let subtitle1Text = CATextLayer()
        // subtitle1Text.font = "Helvetica-Bold"
        // subtitle1Text.fontSize = 75
        subtitle1Text.font = FontStyle
        let textLayerWidth = videoSize.width
        subtitle1Text.frame = CGRect(x: 0, y: 0, width: textLayerWidth, height: 200)
        subtitle1Text.string = strText
        subtitle1Text.foregroundColor = Color.cgColor
        
        let endVisibleFromStart = CABasicAnimation.init(keyPath:"opacity")
        endVisibleFromStart.duration = 0.9
        endVisibleFromStart.repeatCount = 1
        endVisibleFromStart.fromValue = 0.0
        endVisibleFromStart.toValue = 0.0
        endVisibleFromStart.beginTime = 0.1
        endVisibleFromStart.fillMode = CAMediaTimingFillMode.forwards
        endVisibleFromStart.isRemovedOnCompletion = false
        
//        if StartTime != 0{
//            subtitle1Text.add(endVisibleFromStart, forKey: "endAnimation1")
//        }
        
        let startVisible = CABasicAnimation.init(keyPath:"opacity")
        startVisible.duration = 0.1  // for fade in duration
        startVisible.repeatCount = 1
        startVisible.fromValue = 0.0
        startVisible.toValue = 1.0
//        startVisible.beginTime = CFTimeInterval(StartTime)
        // overlay time range start duration
        startVisible.isRemovedOnCompletion = false
        startVisible.fillMode = CAMediaTimingFillMode.forwards
        subtitle1Text.add(startVisible, forKey: "startAnimation")
        
        let endVisible = CABasicAnimation.init(keyPath:"opacity")
        endVisible.duration = 0.1
        endVisible.repeatCount = 1
        endVisible.fromValue = 1.0
        endVisible.toValue = 0.0
//        endVisible.beginTime = CFTimeInterval(EndTime)
        // overlay time range end duration
        endVisible.fillMode = CAMediaTimingFillMode.forwards
        endVisible.isRemovedOnCompletion = false
        subtitle1Text.add(endVisible, forKey: "endAnimation")
        
        if Position % 3 == 0 {
            subtitle1Text.alignmentMode = CATextLayerAlignmentMode.left
        } else if Position % 3 == 1 {
            subtitle1Text.alignmentMode = CATextLayerAlignmentMode.center
        } else {
            subtitle1Text.alignmentMode = CATextLayerAlignmentMode.right
        }
        
        // 2 - The usual overlay
        let overlayLayer = CALayer()
        overlayLayer.addSublayer(subtitle1Text)
        overlayLayer.frame = CGRect(x: 0, y: 0, width: textLayerWidth, height: videoSize.height)
        overlayLayer.masksToBounds = true
        
        let parentLayer = CALayer()
        
        let videoLayer = CALayer()
        parentLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
        videoLayer.frame = CGRect(x: 0, y: 0, width: textLayerWidth, height: videoSize.height)
        
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(overlayLayer)
        
        let mutableComposition = getVideoComposition(asset: videoAsset)
        
        self.exportWithAddedLayer(mutableComposition, with: videoLayer, inLayer: parentLayer, success: { (outputURl) in
            success(outputURl)
        }) { (err) in
            failure(err)
        }
    }
    
    // Export a video and a added CALayer object
    func exportWithAddedLayer(_ mutableComposition: AVMutableComposition, with addedLayer: CALayer, inLayer: CALayer, success: @escaping ((URL) -> Void), failure: @escaping ((String?) -> Void)) {
        
        let videoTrack: AVAssetTrack = mutableComposition.tracks(withMediaType: AVMediaType.video)[0]
        let videoSize = CGSize(width: videoTrack.naturalSize.width, height: videoTrack.naturalSize.height)
        
        let layerComposition = AVMutableVideoComposition()
        layerComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        layerComposition.renderSize = videoSize
        
        layerComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: addedLayer, in: inLayer)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: mutableComposition.duration)
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        instruction.layerInstructions = [layerInstruction]
        layerComposition.instructions = [instruction]
        
        let exportUrl = generateExportUrl()
        
        // Set up exporter
        guard let exporter = AVAssetExportSession(asset: mutableComposition, presetName: AVAssetExportPresetHighestQuality) else { return }
        exporter.videoComposition = layerComposition
        exporter.outputURL = exportUrl as URL
        exporter.outputFileType = AVFileType.mov
        exporter.exportAsynchronously() {
            DispatchQueue.main.async {
                let status = exporter.status
                switch status {
                case .completed:
                    success(exporter.outputURL!)
                case .failed:
                    failure(exporter.error?.localizedDescription)
                default:
                    break
                }
            }
        }
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    // Helper function that generate a unique URL for saving
    func generateExportUrl() -> URL {
        // Create a custom URL using current date-time to prevent conflicted URL in the future.
        /*let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .long
        dateFormat.timeStyle = .short
        // let dateString = dateFormat.string(from: Date())
        let exportPath = (documentDirectory as NSString).strings(byAppendingPaths: ["edited-video-\(randomString(length: 2)).mp4"])[0]
        return NSURL(fileURLWithPath: exportPath) as URL
        */
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = URL(fileURLWithPath: paths.first!)
        let url = documentDirectory.appendingPathComponent("\(randomString(length: 2))_FinalVideo.mov")

        if FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.removeItem(at: url)
        }

        return url
    }
}
