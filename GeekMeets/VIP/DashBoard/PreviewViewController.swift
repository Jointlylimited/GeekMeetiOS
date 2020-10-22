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

protocol ResetStoryObjectDelegate {
    func resetObject(status: Bool)
}

protocol PreviewProtocol: class {
    func getPostStoryResponse(response: CommonResponse)
}

class PreviewViewController: UIViewController, PreviewProtocol {
    
    var presenter : PreviewPresentationProtocol?
    var delegate : ResetStoryObjectDelegate?
    
    @IBOutlet weak var photo: JLStickerImageView!
    @IBOutlet weak var PhotoView: UIView!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var playView: UIView!
    @IBOutlet fileprivate weak var scrubber: UISlider!
    @IBOutlet weak var stickerView: JLStickerImageView!
    @IBOutlet weak var cropPickerView: CropPickerView!
    @IBOutlet weak var headerView: UIView!
    
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
    var userResizableView1 = ZDStickerView()
    var transform : CGAffineTransform = CGAffineTransform(rotationAngle: 0.0)
    var editedlabel : JLStickerLabelView = JLStickerLabelView()
    
    private var beginningPoint = CGPoint.zero
    private var beginningCenter = CGPoint.zero
    
    private var initialBounds = CGRect.zero
    private var initialDistance:CGFloat = 0
    private var deltaAngle:CGFloat = 0
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headerView.alpha = 1.0
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
        let bounds = CGRect(x: 0, y: -5, w: self.view.bounds.width, h: self.view.bounds.height + 10)
        imgview = UIImageView(frame: bounds)
        imgview?.image = photo.image
        let gripFrame : CGRect?
        
        
        
        if !self.objPostData.arrMedia[0].captutedFromCamera {
            let image = resetImageSize(image: photo.image!)
            let width = image.size.width
            let height = image.size.height
            imgview?.contentMode = .scaleAspectFill
            
            gripFrame = DeviceType.hasNotch ? CGRect(x: 0, y: (ScreenSize.height - height)/2, width: width, height: height) : CGRect(x: 0, y: (ScreenSize.height - height)/2, width: width, height: height)
        } else {
            let width = photo.image!.size.width
            let height = photo.image!.size.height
            imgview?.contentMode = .scaleToFill
            
            gripFrame = DeviceType.hasNotch ? CGRect(x: 0, y: 0, width: width, height: height) : CGRect(x: 0, y: 0, width: width, height: height)
        }
        
        let contentView = UIView(frame: bounds)
        contentView.backgroundColor = UIColor.black
        contentView.addSubview(imgview!)
        
        userResizableView1 = ZDStickerView(frame: bounds)
        userResizableView1.tag = 0
        userResizableView1.stickerViewDelegate = self
        userResizableView1.contentView = contentView
        userResizableView1.preventsPositionOutsideSuperview = false
        userResizableView1.hideCustomHandle()
        userResizableView1.translucencySticker = false
        userResizableView1.hideEditingHandles() //showEditingHandles() //
        view.insertSubview(userResizableView1, at: 2)
    }
    
    func resetImageSize(image : UIImage) -> UIImage {
        let screenWidth = ScreenSize.width
        let screenHeight = ScreenSize.height
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        var imgRatio : CGFloat = actualWidth/actualHeight
        var maxRatio : CGFloat = screenWidth/screenHeight

        if(imgRatio != maxRatio){
            if(imgRatio < maxRatio){
                imgRatio = screenHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = screenHeight
            }
            else{
                imgRatio = screenWidth / actualWidth;
                actualHeight = imgRatio * actualHeight
                actualWidth = screenWidth
            }
        }
        let rect : CGRect = CGRect(x: 0, y: 0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size);
        image.draw(in: rect)
        let img : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
    
    // MARK: Manual Functions
    func videoProcess() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        self.videoAsset = AVAsset(url: self.objPostData.arrMedia[0].videoURL!)
        let avPlayerItem = AVPlayerItem(asset: (self.videoAsset)!)
        self.player = AVPlayer(playerItem: avPlayerItem)
        self.playerLayer = AVPlayerLayer(player: self.player)
        
        self.playerLayer?.frame = self.playView.frame
        self.playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.playerLayer?.zPosition = -1
        self.playView.layer.addSublayer(playerLayer!)
        self.scrubber.minimumValue = 0
        
        player?.replaceCurrentItem(with: avPlayerItem)
        
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
        
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
         self.delegate?.resetObject(status: true)
         self.dismissVC(completion: nil) //popVC()
    }
    
    @IBAction func saveButtonTouch(_ sender: Any) {
        self.headerView.alpha = 0.0
        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.AddTextScreen) as? AddTextViewController
        controller!.modalTransitionStyle = .crossDissolve
        controller!.modalPresentationStyle = .overCurrentContext
        controller!.delegate = self
        self.presentVC(controller!)
    }
    
    @IBAction func btnAddtoStoryAction(_ sender: UIButton){
        if self.objPostData.tiStoryType == "0" {
            stickerView.image = self.photo.image
            let img = stickerView.resizeImage(transform : userResizableView1.transform, frame : self.view.bounds)
            if cusText != nil {
                stickerView.frame = userResizableView1.bounds
                let image = addTextToImage(text: cusText.text as NSString, inImage: img!, atPoint: cusText.frame.origin)
                    
                   // textToImage(drawText: cusText.text as NSString, inImage: img!, atPoint: self.editedlabel.frame.origin, frame: self.editedlabel.frame, transform: self.transform)
                    
                    //stickerView.renderContentOnView(layer : imageView.layer)
                    
                   // textToImage(drawText: cusText.text as NSString, inImage: img!, atPoint: self.editedlabel.frame.origin, frame: self.editedlabel.frame, transform: self.transform) //addTextToImage(text: cusText.text as NSString, inImage: img!, atPoint: cusText.frame.origin) //stickerView.renderContentOnView()
                stickerView.image = nil
                self.objPostData.arrMedia[0].img = image
                self.callPostStoryAPI(obj: self.objPostData)
            } else {
                stickerView.image = nil
                self.objPostData.arrMedia[0].img = img
                self.callPostStoryAPI(obj: self.objPostData)
            }
        }else {
            if cusText != nil {
                LoaderView.sharedInstance.showLoader()
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
        tabVC.isFromStory = true
//        self.dismissVC(completion: nil) // pop(toLast: tabVC.classForCoder)
        AppSingleton.sharedInstance().showHomeVC(fromMatch : false, fromStory: true, userDict: [:])
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
        self.textView = UITextView.init(frame: CGRect.init(x: 0, y: 0, width: text.viewSize.width, height: text.viewSize.height))
        textView.text = text.text
        textView.textColor = text.color
        textView.font = text.font
        textView.textAlignment = .center
        textView.backgroundColor = .clear
//        let newSize = textView.sizeThatFits(CGSize(width: textView.width, height: CGFloat.greatestFiniteMagnitude))
//        textView.frame.size = CGSize(width: max(newSize.width, textView.width), height: newSize.height)
        textView.delegate = self
        adjustTextViewHeight(textView : textView)
        
//        stickerView.frame = self.textView.bounds
        stickerView.addLabel(text : text.text, font: text.font.fontName)
        stickerView.textColor = text.color
        stickerView.textAlpha = 1
        stickerView.textAlignment = .center
        stickerView.currentlyEditingLabel.closeView!.image = UIImage(named: "Close")
        stickerView.currentlyEditingLabel.rotateView?.image = UIImage(named: "Rotate")
        stickerView.currentlyEditingLabel.border?.strokeColor = UIColor.brown.cgColor
        stickerView.currentlyEditingLabel.labelTextView?.font = text.font
        stickerView.currentlyEditingLabel.labelTextView?.delegate = self
        stickerView.currentlyEditingLabel.delegate = self
        self.view.addSubview(stickerView)
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
   
    func addTextToImage(text: NSString, inImage: UIImage, atPoint:CGPoint) -> UIImage{
        stickerView.currentlyEditingLabel = stickerView.currentlyEditingLabel
        // Setup the font specific variables
        let textColor = cusText.color
        let textFont = cusText.font
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
        ]
        
        
        
        // Create bitmap based graphics context
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, 0.0)

        
        //Put the image into a rectangle as large as the original image.
        inImage.draw(in: CGRect(x: 0, y: 0, w: inImage.size.width, h: inImage.size.height))
        
        // Our drawing bounds
        let drawingBounds = CGRect(x: 0, y: 0, w: inImage.size.width, h: inImage.size.height)
        
        let textSize = text.size(withAttributes: [NSAttributedString.Key.font:textFont])
        let textRect = CGRect(x: drawingBounds.size.width/2 - textSize.width/2, y:  drawingBounds.size.height/2 - textSize.height/2, w: textSize.width, h: textSize.height)
        
//        if stickerView.currentlyEditingLabel != nil {
//            let degrees : CGFloat = CGFloat(atan2f(Float(stickerView.currentlyEditingLabel.transform.b), Float(stickerView.currentlyEditingLabel.transform.a)))
//            text.drawWithBasePoint(basePoint: cusText.frame.origin, andAngle: 0, font : textFont!, color : textColor)
//            text.draw(in: stickerView.currentlyEditingLabel.frame, withAttributes: textFontAttributes)
//        } else {
        text.draw(in: cusText.frame, withAttributes: textFontAttributes as [NSAttributedString.Key : Any])
//        }
         
        // Get the image from the graphics context
        let newImag = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImag

    }
    
    func textToImage(drawText text: NSString, inImage image: UIImage, atPoint point: CGPoint, frame : CGRect, transform : CGAffineTransform) -> UIImage {
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
         
        let rect = CGRect(origin: point, size: image.size)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attrs = [NSAttributedString.Key.font: self.cusText.font,NSAttributedString.Key.foregroundColor : cusText.color, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        // Move orgin.
//        context.translateBy(x: transform.tx, y: transform.ty)
        // Rotate the coordinate system.
        let degrees : CGFloat = CGFloat(atan2f(Float(transform.b), Float(transform.a)))
        context.rotate(by: degrees)
        
        
        let xTranslation = point.x+frame.size.width/2;
        let yTranslation = point.y+frame.size.height/2;

        context.translateBy(x: xTranslation, y: yTranslation);
        context.concatenate(transform);
        context.translateBy(x: -xTranslation, y: -yTranslation);
        // Restore to saved context.
        context.restoreGState()
       
        text.draw(with: frame, options: .usesLineFragmentOrigin, attributes: attrs as [NSAttributedString.Key : Any], context: nil)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func addtextToVideo(){
//        DispatchQueue.main.async {
//            LoaderView.sharedInstance.showLoader()
//        }
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
        if audioTrack != nil {
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
        }
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
//                DispatchQueue.main.async {
                    LoaderView.sharedInstance.hideLoader()
//                }
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

//MARK : Textfield Delegate method
extension PreviewViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.textView.resignFirstResponder()
        stickerView.currentlyEditingLabel.removeFromSuperview()
        self.headerView.alpha = 0.0
        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.AddTextScreen) as? AddTextViewController
        controller!.modalTransitionStyle = .crossDissolve
        controller!.modalPresentationStyle = .overCurrentContext
        let cusTextView = CustomTextView(frame: CGRect.init(x: 0, y: 0, width: self.textView.width, height: self.textView.height))
        cusTextView.text = textView.text
        cusTextView.color = textView.textColor!
        cusTextView.font = textView.font
        controller!.custText = cusTextView
        controller!.delegate = self
        self.presentVC(controller!)
    }
}
//MARK: TextView Delegate Methods
extension PreviewViewController : TextViewControllerDelegate {
    func textviewDidBeginEditing(){
        self.headerView.alpha = 0.0
        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.AddTextScreen) as? AddTextViewController
        controller!.modalTransitionStyle = .crossDissolve
        controller!.modalPresentationStyle = .overCurrentContext
        controller!.cusTextView = self.cusText
        controller!.delegate = self
        self.presentVC(controller!)
    }
    
    func textViewDidFinishWithTextView(text:CustomTextView) {
        print(text)
        self.headerView.alpha = 1.0
        if text.text != "" {
          setLabel(text : text)
        }
    }
}
   
extension PreviewViewController : JLStickerLabelViewDelegate {
    
    func labelViewDidBeginEditing(_ label: JLStickerLabelView) {}
    func labelViewDidStartEditing(_ label: JLStickerLabelView) {}
    func labelViewDidClose(_ label: JLStickerLabelView) {}
    func labelViewDidSelected(_ label: JLStickerLabelView) {}
    func labelViewDidChangeEditing(_ label: JLStickerLabelView) {}
    func labelViewDidHideEditingHandles(_ label: JLStickerLabelView) {}
    func labelViewDidShowEditingHandles(_ label: JLStickerLabelView) {}
    
    func labelViewDidEndEditing(_ label: JLStickerLabelView) {
        self.editedlabel = label
        self.transform = label.transform
    }
}
extension PreviewViewController : ZDStickerViewDelegate {
    func stickerViewDidClose(_ sticker: ZDStickerView!) {
        print(sticker)
    }
    
    func stickerViewDidEndEditing(_ sticker: ZDStickerView!) {
        print(sticker)
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


extension NSString {
    
    func drawWithBasePoint(basePoint: CGPoint, andAngle angle: CGFloat, font : UIFont, color : UIColor) {
        let radius: CGFloat = 100
        let textFontAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color,
        ]
        let textSize: CGSize = self.size(withAttributes: textFontAttributes)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        let t: CGAffineTransform = CGAffineTransform(translationX: basePoint.x, y: basePoint.y)
        let r: CGAffineTransform = CGAffineTransform(rotationAngle: angle)
        context.concatenate(t)
        context.concatenate(r)
        self.draw(at: CGPoint(x: radius-textSize.width/2, y: -textSize.height/2) , withAttributes: textFontAttributes)
        context.concatenate(r.inverted())
        context.concatenate(t.inverted())
    }
}
