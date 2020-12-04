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
import Photos

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
    @IBOutlet weak var btnAddText: UIButton!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var playView: UIView!
    @IBOutlet fileprivate weak var scrubber: UISlider!
    @IBOutlet weak var stickerView: JLStickerImageView!
    @IBOutlet weak var cropPickerView: CropPickerView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnAddTo: UIButton!
    
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
        let bounds = self.view.bounds //  CGRect(x: 0, y: -5, w: self.view.bounds.width, h: self.view.bounds.height + 10)
        imgview = UIImageView(frame: bounds)
        imgview?.image = photo.image
        imgview?.contentMode = .scaleAspectFill
        stickerView.contentMode = .scaleAspectFill
        
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
        self.playerPauseState(isPause: false)
    }

    @IBAction func cancelButtonTouch(_ sender: Any) {
        self.player?.pause()
        self.delegate?.resetObject(status: true)
        self.dismissVC(completion: nil)
    }
    
    @IBAction func saveButtonTouch(_ sender: Any) {
        self.hideControls()
//        self.playerPauseState(isPause: true)
        self.headerView.alpha = 0.0
        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.AddTextScreen) as? AddTextViewController
        controller!.modalTransitionStyle = .crossDissolve
        controller!.modalPresentationStyle = .overCurrentContext
        controller!.delegate = self
        self.presentVC(controller!)
    }
    
    @IBAction func btnAddtoStoryAction(_ sender: UIButton){
        self.player?.pause()
        if self.objPostData.tiStoryType == "0" {
            stickerView.image = self.photo.image
           
            let img1 = stickerView.renderContentOnView(size : self.view.bounds.size)
            
            stickerView.image = nil
            self.objPostData.arrMedia[0].img = img1
            self.callPostStoryAPI(obj: self.objPostData)
            
        }else {
            if cusText != nil {
                stickerView.image = #imageLiteral(resourceName: "transparent").imageWithColor(color: .clear)
                let img1 = stickerView.renderContentOnView(size : self.view.bounds.size)
                print(img1)
                
                LoaderView.sharedInstance.showLoader()
                self.convertVideoAndSaveTophotoLibrary(videoURL: self.objPostData.arrMedia[0].videoURL!, imgLayer : img1!)
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
    
    func showControls(){
        self.btnAddTo.alpha = 1.0
        self.headerView.alpha = 1.0
    }
    
    func hideControls(){
        self.btnAddTo.alpha = 0.0
        self.headerView.alpha = 0.0
    }
    func moveToTabVC(){
        
        let tabVC = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.TabbarScreen) as! TabbarViewController
        tabVC.isFromStory = true
        AppSingleton.sharedInstance().showHomeVC(fromMatch : false, fromStory: true, userDict: [:])
    }
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        self.player?.seek(to: CMTime.zero)
        self.player?.play()
//        self.playerPauseState(isPause: true)
    }
    
    func playerPauseState(isPause:Bool) {
        self.btnPlayPause.isSelected = !isPause
//        isPause ? self.player?.pause() : self.player?.play()
        self.player?.play()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToYourTabBarController" {
            if let destVC = segue.destination as? TabbarViewController {
                destVC.selectedIndex = 0
            }
        }
    }
    
    func setLabel(text : CustomTextView){
        self.showControls()
        self.btnAddText.alpha = 0.0
        self.cusText = text
        self.textView = UITextView.init(frame: CGRect.init(x: 0, y: 0, width: text.viewSize.width, height: text.viewSize.height))
        textView.text = text.text
        textView.textColor = text.color
        textView.font = text.font
        textView.textAlignment = .center
        textView.backgroundColor = .clear

        textView.delegate = self
        adjustTextViewHeight(textView : textView)
        
        stickerView.addLabel(text : text.text, font: text.font.fontName)
        stickerView.textColor = text.color
        stickerView.textAlpha = 1
        stickerView.textAlignment = .center
        stickerView.currentlyEditingLabel.frame = CGRect(origin: CGPoint(x: (ScreenSize.width - text.viewSize.width)/2, y: (ScreenSize.height - text.viewSize.height)/2), size: CGSize(width: text.viewSize.width, height: text.viewSize.height + 20))
        
        stickerView.currentlyEditingLabel.closeView!.image = UIImage(named: "Close")
        stickerView.currentlyEditingLabel.rotateView?.image = UIImage(named: "Rotate")
        stickerView.currentlyEditingLabel.border?.strokeColor = UIColor.brown.cgColor
        stickerView.currentlyEditingLabel.labelTextView?.font = text.font
        stickerView.currentlyEditingLabel.labelTextView?.delegate = self
        stickerView.currentlyEditingLabel.delegate = self
        self.view.insertSubview(stickerView, at: 2)
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
//        stickerView.currentlyEditingLabel = stickerView.currentlyEditingLabel
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
    
    func getRotateAngle() -> CGFloat {
        let radians = atan2(self.transform.b, self.transform.a)
        var degrees = radians * 180 / .pi
        degrees.round()
        let realDegrees = degrees //>= 0 ? abs(degrees) : 360 + degrees
        print("Degrees:: \(realDegrees)")
        return realDegrees
    }
    
    // Mark :- save a video photoLibrary
    func convertVideoAndSaveTophotoLibrary(videoURL: URL, imgLayer : UIImage) {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let myDocumentPath = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("temp.mp4").absoluteString
        _ = NSURL(fileURLWithPath: myDocumentPath)
        let documentsDirectory2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        let filePath = documentsDirectory2.appendingPathComponent("video.mp4")
        FileManager.default.removeItemIfExisted(filePath as URL)
        
        //Check if the file already exists then remove the previous file
        if FileManager.default.fileExists(atPath: myDocumentPath) {
            do { try FileManager.default.removeItem(atPath: myDocumentPath)
            } catch let error { print(error) }
        }
        
        // File to composit
        let asset = AVURLAsset(url: videoURL as URL)
        let composition = AVMutableComposition.init()
        composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        let clipVideoTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
        
        
        // Rotate to potrait
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: clipVideoTrack)
        
        
        let videoTransform:CGAffineTransform = clipVideoTrack.preferredTransform
        
        //fix orientation
        var videoAssetOrientation_  = UIImage.Orientation.up
        
        var isVideoAssetPortrait_  = false
        
        if videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0 {
            videoAssetOrientation_ = UIImage.Orientation.right
            isVideoAssetPortrait_ = true
        }
        if videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0 {
            videoAssetOrientation_ =  UIImage.Orientation.left
            isVideoAssetPortrait_ = true
        }
        if videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0 {
            videoAssetOrientation_ =  UIImage.Orientation.up
        }
        if videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0 {
            videoAssetOrientation_ = UIImage.Orientation.down;
        }
        
        transformer.setTransform(clipVideoTrack.preferredTransform, at: CMTime.zero)
        transformer.setOpacity(0.0, at: asset.duration)

        //adjust the render size if neccessary
        var naturalSize: CGSize
        if(isVideoAssetPortrait_){
            naturalSize = CGSize(width: clipVideoTrack.naturalSize.height, height: clipVideoTrack.naturalSize.width)
        } else {
            naturalSize = clipVideoTrack.naturalSize;
        }
        
        var renderWidth: CGFloat!
        var renderHeight: CGFloat!
        
        renderWidth = naturalSize.width
        renderHeight = naturalSize.height
        
        let parentlayer = CALayer()
        let videoLayer = CALayer()
        let watermarkLayer = CALayer()
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: renderWidth, height: renderHeight)
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        videoComposition.renderScale = 1.0
        
        let myImage = imgLayer
        watermarkLayer.contents = myImage.cgImage
        
        parentlayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: naturalSize)
        videoLayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: naturalSize)
        watermarkLayer.frame = CGRect(origin: CGPoint(x: (naturalSize.width - imgLayer.size.width)/2, y: (naturalSize.height - imgLayer.size.height)/2), size: imgLayer.size)
        
        let titleLayer = CATextLayer()
        titleLayer.frame = stickerView.currentlyEditingLabel.frame // CGRect(x: cusText.x, y: cusText.y, width: cusText.width, height: cusText.height)
        titleLayer.string = self.cusText.text
        titleLayer.font = stickerView.currentlyEditingLabel.labelTextView?.font
        titleLayer.foregroundColor = self.cusText.color.cgColor
        titleLayer.shadowOpacity = 0.5
        titleLayer.alignmentMode = CATextLayerAlignmentMode.center
        titleLayer.isWrapped = true
        titleLayer.displayIfNeeded()
        
        let radians = CGFloat(45.0)
        titleLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: radians))
        
        parentlayer.addSublayer(videoLayer)
        parentlayer.addSublayer(watermarkLayer)
//        parentlayer.addSublayer(titleLayer)
        
        // Add watermark to video
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayers: [videoLayer], in: parentlayer)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: CMTime(seconds: 10.0, preferredTimescale: 600))
        
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        let exporter = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPresetHighestQuality)
        exporter?.outputFileType = AVFileType.mov
        exporter?.outputURL = filePath
        exporter?.videoComposition = videoComposition
        
        exporter!.exportAsynchronously(completionHandler: {() -> Void in
            if exporter?.status == .completed {
                DispatchQueue.main.async {
                    LoaderView.sharedInstance.hideLoader()
                }
                
                let outputURL: URL? = exporter?.outputURL
                self.objPostData.arrMedia[0].videoURL = outputURL
                self.objPostData.arrMedia[0].thumbImg = self.generateThumb(from: outputURL!)
                self.callPostStoryAPI(obj: self.objPostData)
                PhotoVideoEditor().saveVideoToAlbum(outputURL!) { (error) in
                    print(error)
                }
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
    func generateThumb(from videoURL: URL) -> UIImage? {
        return videoURL.getVideoThumbImage()
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
            self.player?.pause()
            self.player?.seek(to: CMTime.zero)
            self.moveToTabVC()
            AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle: "OK")
        }
    }
}

//MARK : Textfield Delegate method
extension PreviewViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
//        self.textView.resignFirstResponder()
//        stickerView.currentlyEditingLabel.removeFromSuperview()
//        self.headerView.alpha = 0.0
//        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.AddTextScreen) as? AddTextViewController
//        controller!.modalTransitionStyle = .crossDissolve
//        controller!.modalPresentationStyle = .overCurrentContext
//        let cusTextView = CustomTextView(frame: CGRect.init(x: 0, y: 0, width: self.textView.width, height: self.textView.height))
//        cusTextView.text = self.textView.text
//        cusTextView.color = self.textView.textColor!
//        cusTextView.font = self.textView.font
//        controller!.custText = cusTextView
//        controller!.delegate = self
//        self.presentVC(controller!)
    }
}
//MARK: TextView Delegate Methods
extension PreviewViewController : TextViewControllerDelegate {
    func textviewDidBeginEditing(){
//        self.headerView.alpha = 0.0
//        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.AddTextScreen) as? AddTextViewController
//        controller!.modalTransitionStyle = .crossDissolve
//        controller!.modalPresentationStyle = .overCurrentContext
//        controller!.cusTextView = self.cusText
//        controller!.delegate = self
//        self.presentVC(controller!)
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
    func labelViewDidClose(_ label: JLStickerLabelView) {
        self.btnAddText.alpha = 1.0
    }
    func labelViewDidSelected(_ label: JLStickerLabelView) {}
    func labelViewDidChangeEditing(_ label: JLStickerLabelView) {}
    func labelViewDidHideEditingHandles(_ label: JLStickerLabelView) {}
    func labelViewDidShowEditingHandles(_ label: JLStickerLabelView) {}
    
    func labelViewDidEndEditing(_ label: JLStickerLabelView) {
        self.editedlabel = label
        self.transform = label.transform
        let angle = getRotateAngle()
        print(angle)
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

extension UIImage {
    func imageWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()

        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
