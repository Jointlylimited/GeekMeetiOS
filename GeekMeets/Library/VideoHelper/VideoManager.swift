//
//  KVVideoManager.swift
//  MergeVideos
//
//  Created by Khoa Vo on 12/20/17.
//  Copyright © 2017 Khoa Vo. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import AVKit

class VideoData: NSObject {
    var index:Int?
    var image:UIImage?
    var asset:AVAsset?
    var isVideo = false
}

protocol ExporrtProcess {
    func exportProcess(process:Float)
}

class VideoManager: NSObject {
    
    static let shared = VideoManager()
    
    var mediaTimingRanges = [CMTimeRange]()
    var delegate : ExporrtProcess?
    
    var exporter : AVAssetExportSession!
    var isExportSessionInProgress : Bool = false
    fileprivate var observerForBackGround : NSObjectProtocol!
    var videoTrackSize : [CGSize] = []
    var asspectType : videoAspectType = .fit
    
    typealias Completion = (URL?, Error?) -> Void
    typealias CompletionForComposition = (AVMutableVideoComposition?,AVMutableComposition?,CMTimeRange?, Error?) -> Void
    
    func makeVideoFromWithoutExpoerter(asset:AVAsset, textData:CustomTextView, completion:@escaping CompletionForComposition) -> Void {
        var outputSize : CGSize!
        var insertTime = CMTime.zero
        var arrayLayerInstructions:[AVMutableVideoCompositionLayerInstruction] = []
        self.mediaTimingRanges.removeAll()
        // Init composition
        let videoAsset = asset
        let mixComposition = AVMutableComposition.init()
        autoreleasepool { () -> () in
            
            guard let videoTrack = videoAsset.tracks(withMediaType: AVMediaType.video).first else { return }
            let size = videoTrack.naturalSize
            outputSize = CGSize(width: size.width, height: size.height)
            // Get audio track
            var audioTrack:AVAssetTrack?
            if videoAsset.tracks(withMediaType: AVMediaType.audio).count > 0 {
                audioTrack = videoAsset.tracks(withMediaType: AVMediaType.audio).first
            }
            // Init video & audio composition track
            let videoCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video,
                                                                       preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            let audioCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio,
                                                                       preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            do {
                let startTime = CMTime.zero
                let duration = videoAsset.duration
                // Add video track to video composition at specific time
                try videoCompositionTrack?.insertTimeRange(CMTimeRangeMake(start: startTime, duration: duration),
                                                           of: videoTrack,
                                                           at: insertTime)
                if let audioTrack = audioTrack {
                    try audioCompositionTrack?.insertTimeRange(CMTimeRangeMake(start: startTime, duration: duration),
                                                               of: audioTrack,
                                                               at: insertTime)
                }
                // Add instruction for video track
                let layerInstruction = videoCompositionInstructionForTrack(track: videoCompositionTrack!,
                                                                           asset: videoAsset,
                                                                           standardSize: outputSize,
                                                                           atTime: insertTime)
                // Hide video track before changing to new track
                let endTime = CMTimeAdd(insertTime, duration)
                let timeScale = videoAsset.duration.timescale
                let durationAnimation = CMTime(seconds: 1, preferredTimescale: timeScale)
                layerInstruction.setOpacityRamp(fromStartOpacity: 1.0, toEndOpacity: 0.0, timeRange: CMTimeRange.init(start: endTime, duration: durationAnimation))
                arrayLayerInstructions.append(layerInstruction)
                // Increase the insert time
                insertTime = CMTimeAdd(insertTime, duration)
            }
            catch {
                print("Load track error")
            }
        }
        // Main video composition instruction
        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: insertTime)
        mainInstruction.layerInstructions = arrayLayerInstructions
        
        // Init Video layer
        let videoLayer = CALayer()
        videoLayer.frame = CGRect.init(x: 0, y: 0, width: outputSize.width, height: outputSize.height)
        let parentlayer = CALayer()
        parentlayer.frame = CGRect.init(x: 0, y: 0, width: outputSize.width, height: outputSize.height)
        
        
        // Add Text layer
        let titleLayer = CATextLayer()
        titleLayer.backgroundColor = UIColor.white.cgColor
        titleLayer.string = textData.text
        titleLayer.foregroundColor = textData.color.cgColor
        titleLayer.font = textData.font
        titleLayer.shadowOpacity = 0.5
        titleLayer.alignmentMode = CATextLayerAlignmentMode.center
        titleLayer.frame = CGRect(x: 0, y: 0, width: outputSize.width, height: outputSize.height)
        
        
        let backgroundLayer = CALayer()
        backgroundLayer.frame = CGRect(x: 0, y: 0, width: outputSize.width, height: outputSize.height)
        backgroundLayer.masksToBounds = true
        backgroundLayer.addSublayer(titleLayer)
        parentlayer.addSublayer(backgroundLayer)
        parentlayer.addSublayer(videoLayer)
//                if let textData = textData {
        //            for aTextData in textData {
//        let textLayer = makeTextLayer(string: textData.text, fontSize: textData.fontSize, textColor: textData.color, frame: textData.frame, showTime: 0, hideTime: CGFloat(videoAsset.duration.seconds), size: outputSize)
//        textLayer.frame = CGRect(x: 0, y: 0, w: outputSize.width, h: outputSize.height)
//                        parentlayer.addSublayer(textLayer)
        //            }
//                }
        
        // Main video composition
        let mainComposition = AVMutableVideoComposition()
        mainComposition.instructions = [mainInstruction]
        mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        mainComposition.renderSize = outputSize
        mainComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentlayer)
        completion(mainComposition, mixComposition,nil,nil)
        
        
    }
    

    deinit {
        print("VideoManager Deinit")
        self.delegate = nil
        self.exporter = nil
    }

    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    
}

// MARK:- Private methods
extension VideoManager {
    
    fileprivate func orientationFromTransform(transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
        var assetOrientation = UIImage.Orientation.up
        var isPortrait = false
        if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
            assetOrientation = .right
            isPortrait = true
        } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
            assetOrientation = .left
            isPortrait = true
        } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
            assetOrientation = .up
        } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
            assetOrientation = .down
        }
        return (assetOrientation, isPortrait)
    }
    
    //MARK: Setup output video outputVideoSize
    func setUpSize(OrientationType:orientation)->CGSize{
    
        return CGSize(width: 1920, height: 1080)
    }
    
    func videoOrientation(asset:AVAsset)->AVCaptureVideoOrientation{
        var result : AVCaptureVideoOrientation = .portrait
        
        let tracks = asset.tracks(withMediaType: .video)
        if tracks.count > 0{
            let videoTrack = tracks[0]
            let t = videoTrack.preferredTransform
            // Portrait
            if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0)
            {
                result = .portrait
            }
            // PortraitUpsideDown
            if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0)  {
                
                result = .portraitUpsideDown
            }
            // LandscapeRight
            if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0)
            {
                result = .landscapeRight
            }
            // LandscapeLeft
            if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0)
            {
                result = .landscapeLeft
            }
        }
        return result;
    }
    
    
    fileprivate func videoCompositionInstructionForTrack(track: AVCompositionTrack, asset: AVAsset, standardSize:CGSize, atTime: CMTime) -> AVMutableVideoCompositionLayerInstruction {
        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        let assetTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
        
        let transform = assetTrack.preferredTransform
        let assetInfo = orientationFromTransform(transform: transform)
        
        var aspectFillRatio:CGFloat = 1
        if assetTrack.naturalSize.height < assetTrack.naturalSize.width {
            aspectFillRatio = standardSize.height / assetTrack.naturalSize.height
        }
        else {
            aspectFillRatio = standardSize.width / assetTrack.naturalSize.width
        }
        
        if assetInfo.isPortrait {
            let scaleFactor = CGAffineTransform(scaleX: aspectFillRatio, y: aspectFillRatio)
            
            let posX = standardSize.width/2 - (assetTrack.naturalSize.height * aspectFillRatio)/2
            let posY = standardSize.height/2 - (assetTrack.naturalSize.width * aspectFillRatio)/2
            let moveFactor = CGAffineTransform(translationX: posX, y: posY)
            
            instruction.setTransform(assetTrack.preferredTransform.concatenating(scaleFactor).concatenating(moveFactor), at: atTime)
            
        } else {
            let scaleFactor = CGAffineTransform(scaleX: aspectFillRatio, y: aspectFillRatio)
            
            let posX = standardSize.width/2 - (assetTrack.naturalSize.width * aspectFillRatio)/2
            let posY = standardSize.height/2 - (assetTrack.naturalSize.height * aspectFillRatio)/2
            let moveFactor = CGAffineTransform(translationX: posX, y: posY)
            
            var concat = assetTrack.preferredTransform.concatenating(scaleFactor).concatenating(moveFactor)
            
            if assetInfo.orientation == .down {
                let fixUpsideDown = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                concat = fixUpsideDown.concatenating(scaleFactor).concatenating(moveFactor)
            }
            
            instruction.setTransform(concat, at: atTime)
        }
        return instruction
    }
    
    fileprivate func setOrientation(image:UIImage?, onLayer:CALayer, outputSize:CGSize) -> Void {
        guard let image = image else { return }

        if image.imageOrientation == UIImage.Orientation.up {
            // Do nothing
        }
        else if image.imageOrientation == UIImage.Orientation.left {
            let rotate = CGAffineTransform(rotationAngle: .pi/2)
            onLayer.setAffineTransform(rotate)
        }
        else if image.imageOrientation == UIImage.Orientation.down {
            let rotate = CGAffineTransform(rotationAngle: .pi)
            onLayer.setAffineTransform(rotate)
        }
        else if image.imageOrientation == UIImage.Orientation.right {
            let rotate = CGAffineTransform(rotationAngle: -.pi/2)
            onLayer.setAffineTransform(rotate)
        }
    }
    
 
    fileprivate func makeTextLayer(string:String, fontSize:CGFloat, textColor:UIColor, frame:CGRect, showTime:CGFloat, hideTime:CGFloat, size: CGSize) -> CXETextLayer {
        
        var intTextSize = 0
        if (string.count) < 5 {
            intTextSize = 100
        }
        else if (string.count) > 15 {
            intTextSize = 80
        }
        else{
            intTextSize = 80
        }

        let textLayer = CXETextLayer()
        textLayer.string = "Test Video"
        textLayer.font = UIFont(name: FontTypePoppins.Poppins_SemiBold.rawValue, size: CGFloat(intTextSize))
        textLayer.foregroundColor = UIColor.blue.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.opacity = 0
        textLayer.isWrapped = true
        let cgSizeSubtitle = CGSize(width: size.width, height: size.height)
        let findcenterX = (size.width / 2) - (cgSizeSubtitle.width / 2)
        let findcenterY = (size.height / 2) - (cgSizeSubtitle.height / 2)
        
        textLayer.frame = CGRect(origin: CGPoint(x: 0.0 , y: 0.0), size: cgSizeSubtitle)
    
        let fadeInAnimation = CABasicAnimation.init(keyPath: "opacity")
        fadeInAnimation.duration = 0.5
        fadeInAnimation.fromValue = NSNumber(value: 0)
        fadeInAnimation.toValue = NSNumber(value: 1)
        fadeInAnimation.isRemovedOnCompletion = false
        fadeInAnimation.beginTime = CFTimeInterval(showTime)
        fadeInAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        textLayer.add(fadeInAnimation, forKey: "textOpacityIN")
        
        if hideTime > 0 {
            let fadeOutAnimation = CABasicAnimation.init(keyPath: "opacity")
            fadeOutAnimation.duration = 1
            fadeOutAnimation.fromValue = NSNumber(value: 1)
            fadeOutAnimation.toValue = NSNumber(value: 0)
            fadeOutAnimation.isRemovedOnCompletion = false
            fadeOutAnimation.beginTime = CFTimeInterval(hideTime)
            fadeOutAnimation.fillMode = CAMediaTimingFillMode.forwards
            
            textLayer.add(fadeOutAnimation, forKey: "textOpacityOUT")
        }
        
        return textLayer
        
        
    }

    
  /*  fileprivate func makeTextLayer(string:String, fontSize:CGFloat, textColor:UIColor, frame:CGRect, showTime:CGFloat, hideTime:CGFloat, size: CGSize) -> CXETextLayer {
        
        let subtitle1Text = CXETextLayer()
        var intTextSize = 0
        if (string.count) < 8 {
            intTextSize = 100
        }
        else if (string.count) > 15 {
            intTextSize = 90
        }
        else{
            intTextSize = 80
        }
        intTextSize = 100
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.duration = 1
        fadeInAnimation.fromValue = NSNumber(value: 0)
        fadeInAnimation.toValue = NSNumber(value: 1)
        fadeInAnimation.isRemovedOnCompletion = false
        fadeInAnimation.beginTime = CFTimeInterval(2.0)
        fadeInAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        subtitle1Text.font = UIFont(name: Constant.ThemeFont.AbelBold, size: CGFloat(intTextSize))
        subtitle1Text.fontSize = CGFloat(intTextSize)
        
        let cgSizeSubtitle = CGSize(width: size.width, height: 200)
        let findcenterX = (size.width / 2) - (cgSizeSubtitle.width / 2)
        let findcenterY = (size.height / 2) - (cgSizeSubtitle.height / 2)
        
        subtitle1Text.frame = CGRect(origin: CGPoint(x: findcenterX, y: findcenterY), size: cgSizeSubtitle)
        subtitle1Text.string = string
        subtitle1Text.alignmentMode = .center
        subtitle1Text.foregroundColor = UIColor.white.cgColor
        subtitle1Text.opacity = 1.0
        subtitle1Text.add(fadeInAnimation, forKey: "textOpacityIN")
        
        let fadeOutAnimation = CABasicAnimation.init(keyPath: "opacity")
        fadeOutAnimation.duration = 1
        fadeOutAnimation.fromValue = NSNumber(value: 1)
        fadeOutAnimation.toValue = NSNumber(value: 0)
        fadeOutAnimation.isRemovedOnCompletion = false
        fadeOutAnimation.beginTime = CFTimeInterval(hideTime)
        fadeOutAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        subtitle1Text.add(fadeOutAnimation, forKey: "textOpacityOUT")
        
        return subtitle1Text
        
    }*/
    
    func themeDocumentPath() -> String {
        let tempPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let tempDocumentsDirectory: AnyObject = tempPath[0] as AnyObject
        let themePath = tempDocumentsDirectory.appending("/Jointly")
        if (!FileManager.default.fileExists(atPath: themePath)){
            do {
                try FileManager.default.createDirectory(atPath: themePath, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
        }
        return themePath
    }
}

extension FileManager {
    
    func removeItemIfExisted(_ url:URL) -> Void {
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(atPath: url.path)
            }
            catch {
                print("Failed to delete file")
            }
        }
    }
}

public enum videoAspectType : Int{
    case fit = 0
    case fill = 1
}

public enum orientation : Int{
    case landscape = 0
    case potrait = 1
    case square = 2
}


public enum performTransition : Int{
    case regular
    case inverse
    case negativeInverse
    case regularInverse
}

class CXETextLayer : CATextLayer {
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(layer: aDecoder)
    }
    
    override func draw(in ctx: CGContext) {
        let height = self.bounds.size.height
        let fontSize = self.fontSize
        let yDiff = (height-fontSize)/2 - fontSize/10
        
        ctx.saveGState()
        ctx.translateBy(x: 0.0, y: yDiff)
        super.draw(in: ctx)
        ctx.restoreGState()
    }
}

