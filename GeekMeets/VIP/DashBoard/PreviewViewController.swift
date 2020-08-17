//
//  PreviewViewController.swift
//  Custom Camera
//
//  Created by Rudra Jikadra on 08/12/17.
//  Copyright © 2017 Rudra Jikadra. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import CropPickerView

protocol PostStoryDelegate {
    func getSubscriptionResponse(status: Bool)
}

protocol PreviewProtocol: class {
    func getPostStoryResponse(response: CommonResponse)
}

class PreviewViewController: UIViewController, PreviewProtocol {
    
    var presenter : PreviewPresentationProtocol?
    
    @IBOutlet weak var photo: JLStickerImageView!
    @IBOutlet weak var PhotoView: UIView!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var playView: UIView!
    @IBOutlet fileprivate weak var scrubber: UISlider!
    @IBOutlet weak var stickerView: JLStickerImageView!
    @IBOutlet weak var cropPickerView: CropPickerView!
    
    var player: AVPlayer?
    var playerLayer:AVPlayerLayer?
    var thumbImage : UIImage?
    var videoAsset: AVAsset?
    
    var image: UIImage!
    var cusText : CustomTextView!
    var objPostData = PostData()
    var secondExporter : AVAssetExportSession?
    var finalVidURL : URL!
    let commmonPreset = AVAssetExportPreset1280x720
    var stickerView2 : StickerView!
    var textView = UITextView()
    var fontSize : CGFloat = 0.0
    var imgview : UIImageView?
    
    private var beginningPoint = CGPoint.zero
    private var beginningCenter = CGPoint.zero
    
    private var initialBounds = CGRect.zero
    private var initialDistance:CGFloat = 0
    private var deltaAngle:CGFloat = 0
    
    private lazy var moveGesture = {
        return UIPanGestureRecognizer(target: self, action: #selector(handleMoveGesture(_:)))
    }()
    private lazy var rotateGesture = {
        return UIPanGestureRecognizer(target: self, action: #selector(handleRotateGesture(_:)))
    }()
    
    private var _selectedStickerView:StickerView?
    var selectedStickerView:StickerView? {
        get {
            return _selectedStickerView
        }
        set {
            
            // if other sticker choosed then resign the handler
            if _selectedStickerView != newValue {
                if let selectedStickerView = _selectedStickerView {
                    selectedStickerView.showEditingHandlers = false
                }
                _selectedStickerView = newValue
            }
            
            // assign handler to new sticker added
            if let selectedStickerView = _selectedStickerView {
                selectedStickerView.showEditingHandlers = true
                selectedStickerView.superview?.bringSubviewToFront(selectedStickerView)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.objPostData.tiStoryType == "0" {
            self.previewView.alpha = 0
            self.PhotoView.alpha = 1
            self.ImageProcess()
        } else {
            self.previewView.alpha = 1
            self.PhotoView.alpha = 0
            self.videoProcess()
        }
        // Do any additional setup after loading the view.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = PreviewInteractor()
        let presenter = PreviewPresenter()
        
        //View Controller will communicate with only presenter
        viewController.presenter = presenter
        //viewController.interactor = interactor
        
        //Presenter will communicate with Interector and Viewcontroller
        presenter.viewController = viewController
        presenter.interactor = interactor
        
        //Interactor will communucate with only presenter.
        interactor.presenter = presenter
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func ImageProcess(){
        self.cropPickerView.image = self.objPostData.arrMedia[0].img
        photo.image = self.objPostData.arrMedia[0].img
        self.navigationController?.isNavigationBarHidden = true
        self.cropPickerView.delegate = self
        
       /* imgview = UIImageView(image: photo.image)
        
        if photo.image!.size.width > ScreenSize.width ||
            photo.image!.size.height > ScreenSize.height {
            imgview?.contentMode = .scaleAspectFit
        } else {
            imgview?.contentMode = .center
        }
        let gripFrame = CGRect(x: 50, y: ((ScreenSize.height - ScreenSize.width - 100)/2), width: ScreenSize.width - 100, height: ScreenSize.width - 100)
        let contentView = UIView(frame: photo.frame)
        contentView.backgroundColor = UIColor.black
        contentView.addSubview(imgview!)

        let userResizableView1 = ZDStickerView(frame: gripFrame)
        userResizableView1.tag = 0
        userResizableView1.stickerViewDelegate = self
        userResizableView1.contentView = contentView //contentView;
        userResizableView1.preventsPositionOutsideSuperview = false
        userResizableView1.translucencySticker = false
        userResizableView1.showEditingHandles()
        view.addSubview(userResizableView1)*/
//        self.cropPickerView.addGestureRecognizer(self.moveGesture)
//        self.PhotoView.addGestureRecognizer(self.rotateGesture)
    }
    
    // MARK: Manual Functions
    func videoProcess() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        self.videoAsset = AVAsset(url: self.objPostData.arrMedia[0].videoURL!)
        let avPlayerItem = AVPlayerItem(asset: (self.videoAsset)!)
        self.player = AVPlayer(playerItem: avPlayerItem)
        self.playerLayer = AVPlayerLayer(player: self.player)
        
        self.playerLayer?.frame =  CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        self.playerLayer?.zPosition = -1
        self.playView.layer.addSublayer(playerLayer!)
        self.scrubber.minimumValue = 0
        
        player?.replaceCurrentItem(with: avPlayerItem)
        
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
        
        playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        let duration : CMTime = self.videoAsset!.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        self.scrubber.maximumValue = Float(seconds)
        self.scrubber.isContinuous = true
        self.player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(0.01, preferredTimescale: 600), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                self.scrubber.setValue(Float(time), animated: false)
            }
        }
    }
    
    @IBAction func cancelButtonTouch(_ sender: Any) {
        self.popVC()
    }
    
    @IBAction func saveButtonTouch(_ sender: Any) {
        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.AddTextScreen) as? AddTextViewController
        controller!.modalTransitionStyle = .crossDissolve
        controller!.modalPresentationStyle = .overCurrentContext
        controller!.delegate = self
        self.presentVC(controller!)
    }
    @IBAction func btnAddtoStoryAction(_ sender: UIButton){
        if self.objPostData.tiStoryType == "0" {
            self.cropPickerView.crop { (error, image) in
                if let error = (error as NSError?) {
                    let alertController = UIAlertController(title: "Error", message: error.domain, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                self.photo.image = image
                self.objPostData.arrMedia[0].img = image
            }
            
            if cusText != nil {
//                stickerView.frame = ScreenSize.frame
                stickerView.image = self.photo.image //imgview?.image!
//                stickerView.transform = imgview!.transform
                let image = stickerView.renderContentOnView()
//                let textImage = textToImage(drawText: cusText!.text as NSString, inImage: photo.image!, atPoint: CGPoint(x: self.cusText.x, y: self.cusText.y))
                self.objPostData.arrMedia[0].img = image
            }
            self.callPostStoryAPI(obj: self.objPostData)
        } else {
            if cusText != nil {
                self.addtextToVideo()
            } else {
                self.callPostStoryAPI(obj: self.objPostData)
            }
        }
    }
    
    @IBAction func actionPlayPause(_ sender: UIButton) {
           sender.isSelected = !(sender.isSelected)
           if player?.timeControlStatus == AVPlayer.TimeControlStatus.paused {
               player?.play()
               sender.isSelected = true
           }
           else{
               sender.isSelected = false
                player?.pause()
           }
           
       }
    
    @IBAction func scrub(_ sender: ThemeSlider) {
        self.playerPauseState(isPause: true)
        let targetTime:CMTime = CMTime(seconds: Double(sender.value), preferredTimescale: 1)
        player!.seek(to: targetTime)
        
        if player!.rate == 0
        {
            player?.play()
        }
    }
    
    func moveToTabVC(){
        let tabVC = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.TabbarScreen) as! TabbarViewController
        tabVC.isFromMatch = false
        self.pop(toLast: tabVC.classForCoder)
    }
    
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        self.player?.seek(to: CMTime.zero)
        self.playerPauseState(isPause: true)
    }
    
    func playerPauseState(isPause:Bool) {
        self.btnPlayPause.isSelected = !isPause
        isPause ? self.player?.pause() : self.player?.play()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToYourTabBarController" {
            if let destVC = segue.destination as? TabbarViewController {
                destVC.selectedIndex = 0
            }
        }
    }
    
    func setLabel(text : CustomTextView){
        self.cusText = text
        self.textView = UITextView.init(frame: CGRect.init(x: 0, y: 0, width: self.cusText.width, height: self.cusText.height))
        textView.text = text.text
        textView.textColor = text.color
        textView.font = text.font
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        let newSize = textView.sizeThatFits(CGSize(width: textView.width, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, textView.width), height: newSize.height)
        
        adjustTextViewHeight(textView : textView)
        
        stickerView.addLabel(text : text.text)
        stickerView.textColor = text.color
        stickerView.textAlpha = 1
        stickerView.currentlyEditingLabel.closeView!.image = UIImage(named: "Close")
        stickerView.currentlyEditingLabel.rotateView?.image = UIImage(named: "Rotate")
        stickerView.currentlyEditingLabel.border?.strokeColor = UIColor.brown.cgColor
        stickerView.currentlyEditingLabel.labelTextView?.font = text.font
       // stickerView.currentlyEditingLabel.labelTextView?.becomeFirstResponder()
        self.view.addSubview(stickerView)
        /*
        stickerView2 = StickerView.init(contentView: textView)
        stickerView2.center = CGPoint.init(x: self.cusText.width/2, y: self.cusText.height/2)
        stickerView2.delegate = self
        stickerView2.setImage(UIImage.init(named: "Close")!, forHandler: StickerViewHandler.close)
        stickerView2.setImage(UIImage.init(named: "Rotate")!, forHandler: StickerViewHandler.rotate)
        stickerView2.showEditingHandlers = false
        self.view.addSubview(stickerView2)*/
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            // do something with your currentPoint
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            // do something with your currentPoint
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            // do something with your currentPoint
        }
    }
    
    func adjustTextViewHeight(textView : UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        if newSize.height < ScreenSize.height {
            print(newSize.height)
        }
        self.view.layoutIfNeeded()
    }
    
    func textToImage(drawText text: NSString, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attrs = [NSAttributedString.Key.font: self.cusText.font,NSAttributedString.Key.foregroundColor : cusText.color, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        text.draw(with: rect, options: .usesLineFragmentOrigin, attributes: attrs as [NSAttributedString.Key : Any], context: nil)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func addtextToVideo(){

        let composition = AVMutableComposition()
        let vidAsset = AVURLAsset(url: self.objPostData.arrMedia[0].videoURL!, options: nil)

        // get video track
        let vtrack =  vidAsset.tracks(withMediaType: AVMediaType.video)
        let videoTrack: AVAssetTrack = vtrack[0]
      let audioTrack = vidAsset.tracks(withMediaType: AVMediaType.audio).first
        let vid_timerange = CMTimeRangeMake(start: CMTime.zero, duration: vidAsset.duration)

        let tr: CMTimeRange = CMTimeRange(start: CMTime.zero, duration: CMTime(seconds: 10.0, preferredTimescale: 600))
        composition.insertEmptyTimeRange(tr)

        let trackID:CMPersistentTrackID = CMPersistentTrackID(kCMPersistentTrackID_Invalid)

        if let compositionvideoTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: trackID) {
            do {
                try compositionvideoTrack.insertTimeRange(vid_timerange, of: videoTrack, at: CMTime.zero)
                
            } catch {
                print("error")
            }
            compositionvideoTrack.preferredTransform = videoTrack.preferredTransform

        } else {
            print("unable to add video track")
            return
        }
//      if audioTrack != nil{
        if let compositionaudioTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: trackID) {
            do {
              try compositionaudioTrack.insertTimeRange(vid_timerange, of: audioTrack!, at: CMTime.zero)
                
            } catch {
                print("error")
            }
          compositionaudioTrack.preferredTransform = audioTrack!.preferredTransform

        } else {
            print("unable to add audio track")
            return
        }
        
//      }
        let size = videoTrack.naturalSize
        
        // create text Layer
        let titleLayer = CATextLayer()
        titleLayer.frame = CGRect(x: self.stickerView.x, y: self.stickerView.y, width: size.width, height: size.height)
        titleLayer.string = self.cusText.text
        titleLayer.font = self.cusText.font
        titleLayer.foregroundColor = self.cusText.color.cgColor
        titleLayer.shadowOpacity = 0.5
        titleLayer.alignmentMode = CATextLayerAlignmentMode.center
        titleLayer.isWrapped = true
        titleLayer.displayIfNeeded()

        let videolayer = CALayer()
        videolayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        let parentlayer = CALayer()
        parentlayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        parentlayer.addSublayer(videolayer)
        parentlayer.addSublayer(titleLayer)
        parentlayer.isGeometryFlipped = true

        let layercomposition = AVMutableVideoComposition()
        layercomposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        layercomposition.renderSize = size
        layercomposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videolayer, in: parentlayer)

        // instruction for watermark
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: composition.duration)
        let videotrack = composition.tracks(withMediaType: AVMediaType.video)[0] as AVAssetTrack
        let layerinstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videotrack)
        instruction.layerInstructions = NSArray(object: layerinstruction) as [AnyObject] as! [AVVideoCompositionLayerInstruction]
        layercomposition.instructions = NSArray(object: instruction) as [AnyObject] as! [AVVideoCompositionInstructionProtocol]

        //  create new file to receive data
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        let movieFilePath = docsDir.appendingPathComponent("result.mov")
        let movieDestinationUrl = NSURL(fileURLWithPath: movieFilePath)

        // use AVAssetExportSession to export video
        let assetExport = AVAssetExportSession(asset: composition, presetName:AVAssetExportPresetHighestQuality)
        assetExport?.outputFileType = AVFileType.mov
        assetExport?.videoComposition = layercomposition

        // Check exist and remove old file
        FileManager.default.removeItemIfExisted(movieDestinationUrl as URL)

        assetExport?.outputURL = movieDestinationUrl as URL
        assetExport?.exportAsynchronously(completionHandler: {
            switch assetExport!.status {
            case AVAssetExportSession.Status.failed:
                print("failed")
                print(assetExport?.error ?? "unknown error")
            case AVAssetExportSession.Status.cancelled:
                print("cancelled")
                print(assetExport?.error ?? "unknown error")
            default:
                print("Movie complete : \(movieDestinationUrl)")
                self.objPostData.arrMedia[0].videoURL = movieDestinationUrl as URL
                self.callPostStoryAPI(obj: self.objPostData)
            }
        })
    }
    
    func ManageSubscriptionScreen(){
        
        if UserDataModel.currentUser?.tiIsSubscribed == 0 {
            let subVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.ManageSubscriptionScreen) as! ManageSubscriptionViewController
            subVC.modalTransitionStyle = .crossDissolve
            subVC.modalPresentationStyle = .overCurrentContext
            subVC.isFromStory = true
            subVC.postStoryDelegate = self
            self.presentVC(subVC)
        } else {
            self.callPostStoryAPI(obj: self.objPostData)
        }
    }
    
    // MARK: - Gesture Handlers
    @objc
    func handleMoveGesture(_ recognizer: UIPanGestureRecognizer) {
        let touchLocation = recognizer.location(in: self.PhotoView)
        switch recognizer.state {
        case .began:
            self.beginningPoint = touchLocation
            self.beginningCenter = self.PhotoView.center
//            if let delegate = self.delegate {
//                delegate.stickerViewDidBeginMoving(self)
//            }
        case .changed:
            self.PhotoView.center = CGPoint(x: self.beginningCenter.x + (touchLocation.x - self.beginningPoint.x), y: self.beginningCenter.y + (touchLocation.y - self.beginningPoint.y))
//            if let delegate = self.delegate {
//                delegate.stickerViewDidChangeMoving(self)
//            }
        case .ended:
            self.PhotoView.center = CGPoint(x: self.beginningCenter.x + (touchLocation.x - self.beginningPoint.x), y: self.beginningCenter.y + (touchLocation.y - self.beginningPoint.y))
//            if let delegate = self.delegate {
//                delegate.stickerViewDidEndMoving(self)
//            }
        default:
            break
        }
//        self.view.layoutIfNeeded()
    }
    
    @objc
    func handleRotateGesture(_ recognizer: UIPanGestureRecognizer) {
        let touchLocation = recognizer.location(in: self.PhotoView)
        let center = self.PhotoView.center
        
        switch recognizer.state {
        case .began:
            self.deltaAngle = CGFloat(atan2f(Float(touchLocation.y - center.y), Float(touchLocation.x - center.x))) - CGAffineTransformGetAngle(self.PhotoView.transform)
            self.initialBounds = self.PhotoView.bounds
            self.initialDistance = CGPointGetDistance(point1: center, point2: touchLocation)
//            if let delegate = self.delegate {
//                delegate.stickerViewDidBeginRotating(self)
//            }
        case .changed:
            let angle = atan2f(Float(touchLocation.y - center.y), Float(touchLocation.x - center.x))
            let angleDiff = Float(self.deltaAngle) - angle
            self.PhotoView.transform = CGAffineTransform(rotationAngle: CGFloat(-angleDiff))
            
            var scale = CGPointGetDistance(point1: center, point2: touchLocation) / self.initialDistance
//            let minimumScale = CGFloat(self.minimumSize)/min(self.initialBounds.size.width, self.initialBounds.size.height)
//            scale = max(scale, minimumScale)
            let scaledBounds = CGRectScale(self.initialBounds, wScale: scale, hScale: scale)
            self.PhotoView.bounds = scaledBounds
//            self.PhotoView.setN-eedsDisplay()
            
//            if let delegate = self.delegate {
//                delegate.stickerViewDidChangeRotating(self)
//            }
        case .ended:
            print("Ended")
//            if let delegate = self.delegate {
//                delegate.stickerViewDidEndRotating(self)
//            }
        default:
            break
        }
    }
}

extension PreviewViewController : PostStoryDelegate {
    func getSubscriptionResponse(status: Bool){
        self.callPostStoryAPI(obj: self.objPostData)
    }
}
//MARK: API Methods
extension PreviewViewController {
    
    func callPostStoryAPI(obj : PostData){
        self.presenter?.callPostStoryAPI(obj: obj)
    }
    
    func getPostStoryResponse(response: CommonResponse){
        if response.responseCode == 200 {
            self.moveToTabVC()
            AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle: "OK")
        }
    }
}

//MARK: TextView Delegate Methods
extension PreviewViewController : TextViewControllerDelegate {
    func textViewDidFinishWithTextView(text:CustomTextView) {
        print(text)
        setLabel(text : text)
    }
}

//extension PreviewViewController : ZDStickerViewDelegate {
//    func stickerViewDidClose(_ sticker: ZDStickerView!) {
//        print(sticker)
//    }
//    func stickerViewDidEndEditing(_ sticker: ZDStickerView!) {
////        self.imgview?.frame = sticker.frame
//        print(sticker)
//    }
//}

// MARK: StickerViewDelegate
extension PreviewViewController: StickerViewDelegate {
    func stickerViewDidBeginMoving(_ stickerView: StickerView) {
        self.selectedStickerView = stickerView
    }

    func stickerViewDidChangeMoving(_ stickerView: StickerView) {

    }

    func stickerViewDidEndMoving(_ stickerView: StickerView) {

    }

    func stickerViewDidBeginRotating(_ stickerView: StickerView) {

    }

    func stickerViewDidChangeRotating(_ stickerView: StickerView) {
//        self.fontSize = self.cusText.fontSize
////        textView.size = stickerView2.size
////        textView.sizeToFit()
////        adjustTextViewHeight(textView : self.textView)
//        print("Before : \(self.fontSize)")
//        if self.fontSize > 8 {
//            print("After : \(self.fontSize)")
//            self.fontSize = self.fontSize - 1
//            textView.font = UIFont(name: self.cusText.font.familyName, size: self.fontSize)
//        }
    }

    func stickerViewDidEndRotating(_ stickerView: StickerView) {

    }

    func stickerViewDidClose(_ stickerView: StickerView) {
        self.cusText = nil
    }

    func stickerViewDidTap(_ stickerView: StickerView) {
        self.selectedStickerView = stickerView
    }
}

// MARK: CropPickerViewDelegate
extension PreviewViewController: CropPickerViewDelegate {
    func cropPickerView(_ cropPickerView: CropPickerView, error: Error) {
        
    }
    func cropPickerView(_ cropPickerView: CropPickerView, image: UIImage) {
        
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


