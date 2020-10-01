//
//  PreViewController.swift
//  ARStories
//
//  Created by Antony Raphel on 05/10/17.
//

import UIKit
import AVFoundation
import AVKit
import CoreMedia
import Alamofire

class PreViewController: UIViewController, SegmentedProgressBarDelegate {

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var deleteView: UIView!
    
    @IBOutlet weak var btnOption: UIButton!
    @IBOutlet weak var lblViews: UILabel!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var imgReconnect: UIImageView!
    var pageIndex : Int = 0
//    var items: [UserDetail] = []
    var items: [StoryResponseFields] = []
    var item : [StoryResponseFields] = []
//    var item: [Content] = []
    var SPB: SegmentedProgressBar!
    var player: AVPlayer!
    let loader = ImageLoader()
    var isFromMatchVC : Bool = false
    var isOwnStory : Bool = false
    var delegate : DeleteStoryDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFromMatchVC {
            self.userProfileImage.alpha = 0
            self.lblUserName.alpha = 0
            self.btnOption.alpha = 1
            self.lblViews.alpha = 0
            self.btnView.alpha = 0
            self.btnDelete.setTitle("Report User", for: .normal)
        } else {
            self.userProfileImage.alpha = 1
            self.lblUserName.alpha = 1
            self.btnOption.alpha = 1
            self.lblViews.alpha = 1
            self.btnView.alpha = 1
            self.btnDelete.setTitle("Delete", for: .normal)
            if isOwnStory {
//                self.deleteView.alpha = 1
                self.btnOption.alpha = 1
                self.lblViews.alpha = 1
                self.btnView.alpha = 1
            } else {
                self.deleteView.alpha = 0
                self.btnOption.alpha = 0
                self.lblViews.alpha = 0
                self.btnView.alpha = 0
            }
        }
        
        userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.height / 2;
        if items[pageIndex].txStory != "" {
            let url = URL(string:"\(items[pageIndex].vProfileImage!)")
            userProfileImage.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_rect"))
        }
        lblViews.text = items[pageIndex].dbTotalViews == "" ? "0 views" : "\(items[pageIndex].dbTotalViews!) views"
       
        item = items
//        item = items[pageIndex].contents as! [Content]
        
        SPB = SegmentedProgressBar(numberOfSegments: item.count, duration: 5)
        if #available(iOS 11.0, *) {
            SPB.frame = CGRect(x: 18, y: UIApplication.shared.statusBarFrame.height + 5, width: view.frame.width - 35, height: 3)
        } else {
            // Fallback on earlier versions
            SPB.frame = CGRect(x: 18, y: 15, width: view.frame.width - 35, height: 3)
        }
        
        SPB.delegate = self
        SPB.topColor = UIColor.white
        SPB.bottomColor = UIColor.white.withAlphaComponent(0.25)
        SPB.padding = 2
        SPB.isPaused = true
        SPB.currentAnimationIndex = 0
        SPB.duration = getDuration(at: 0)
        view.addSubview(SPB)
        view.bringSubviewToFront(SPB)
        
        let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(tapOn(_:)))
        tapGestureImage.numberOfTapsRequired = 1
        tapGestureImage.numberOfTouchesRequired = 1
        imagePreview.addGestureRecognizer(tapGestureImage)
        
        let tapGestureVideo = UITapGestureRecognizer(target: self, action: #selector(tapOn(_:)))
        tapGestureVideo.numberOfTapsRequired = 1
        tapGestureVideo.numberOfTouchesRequired = 1
        videoView.addGestureRecognizer(tapGestureVideo)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.8) {
            self.view.transform = .identity
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.SPB.startAnimation()
            self.playVideoOrLoadImage(index: 0)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DispatchQueue.main.async {
            self.SPB.currentAnimationIndex = 0
            self.SPB.cancel()
            self.SPB.isPaused = true
            self.resetPlayer()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - SegmentedProgressBarDelegate
    //1
    func segmentedProgressBarChangedIndex(index: Int) {
        playVideoOrLoadImage(index: index)
    }
    
    //2
    func segmentedProgressBarFinished() {
     //   if pageIndex == (self.items.count - 1) {
            self.dismiss(animated: true, completion: nil)
//        }
//        else {
//            _ = ContentViewControllerVC.goNextPage(fowardTo: pageIndex + 1)
//        }
    }
    
    @objc func tapOn(_ sender: UITapGestureRecognizer) {
        SPB.skip()
    }
    
    //MARK: - Play or show image
    func playVideoOrLoadImage(index: NSInteger) {
        
        let attributedString = NSMutableAttributedString(string: items[index].vName!, attributes: [NSAttributedString.Key.font:UIFont(name: FontTypePoppins.Poppins_SemiBold.rawValue, size: 12.0)!])
        let range = (items[index].vName! as NSString).range(of: items[index].iCreatedAt!)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
         
        let attributedString2 = NSMutableAttributedString(string: " \(items[index].iCreatedAt!)", attributes: [NSAttributedString.Key.font:UIFont(name: FontTypePoppins.Poppins_Medium.rawValue, size: 12.0)!])
        let range2 = (" \(items[index].iCreatedAt!)" as NSString).range(of: " \(items[index].iCreatedAt!)")
        attributedString2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white.withAlphaComponent(0.5), range: range2)
        
        attributedString.append(attributedString2)
        lblUserName.attributedText = attributedString
        
        if item[index].tiStoryType! == "0" {
            self.SPB.duration = 5
            
            if !NetworkReachabilityManager.init()!.isReachable{
                self.imgReconnect.alpha = 1.0
                self.imagePreview.isHidden = true
                self.videoView.isHidden = true
                return
            }
            self.imgReconnect.alpha = 0.0
            self.imagePreview.isHidden = false
            self.videoView.isHidden = true
            print("\(items[pageIndex].txStory!)")
            let url = URL(string:"\(items[index].txStory!)")
            self.imagePreview.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_rect"))
            self.player.pause()
        } else {
            
            print("\(items[index].txStory!)")
            resetPlayer()
            guard let url = NSURL(string: items[index].txStory!) as URL? else {return}
            self.player = AVPlayer(url: url)
            
            if !NetworkReachabilityManager.init()!.isReachable{
                self.imgReconnect.alpha = 1.0
                self.imagePreview.isHidden = true
                self.videoView.isHidden = true
                return
            }
            self.imagePreview.isHidden = true
            self.videoView.isHidden = false
            self.imgReconnect.alpha = 0.0
            let videoLayer = AVPlayerLayer(player: self.player)
            videoLayer.frame = view.bounds
            videoLayer.videoGravity = .resizeAspect
            self.videoView.layer.addSublayer(videoLayer)
            
            let asset = AVAsset(url: url)
            let duration = asset.duration
            let durationTime = CMTimeGetSeconds(duration)
            
            self.SPB.duration = durationTime
            self.player.play()
        }
    }
    
    // MARK: Private func
    private func getDuration(at index: Int) -> TimeInterval {
        var retVal: TimeInterval = 10.0
        if item[index].tiStoryType! == "0" /*"image"*/ {
            retVal = 10.0
        } else {
            guard let url = NSURL(string: items[index].txStory!) as URL? else { return retVal }
            let asset = AVAsset(url: url)
            let duration = asset.duration
            retVal = CMTimeGetSeconds(duration)
        }
        return retVal
    }
    
    private func resetPlayer() {
        if player != nil {
            player.pause()
            player.replaceCurrentItem(with: nil)
            player = nil
        }
    }
    
    //MARK: - Button actions
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        resetPlayer()
    }
    
    @IBAction func btnOptionAction(_ sender: UIButton) {
        if self.deleteView.alpha == 0.0 {
            self.deleteView.alpha = 1.0
        } else {
            self.deleteView.alpha = 0.0
        }
    }
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        if isFromMatchVC {
            let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.ReportScreen) as! ReportViewController
            controller.iStoryId = "\(items[pageIndex].iStoryId!)"
            controller.ReportFor = "\(items[pageIndex].iUserId!)"
            controller.tiReportType = 2
            self.presentVC(controller)
        } else {
            self.callDeleteStoryAPI(id : "\(items[pageIndex].iStoryId!)")
        }
    }
    @IBAction func btnViewStoryAction(_ sender: UIButton) {
        
    }
}

extension PreViewController {
    func callDeleteStoryAPI(id : String){
        LoaderView.sharedInstance.showLoader()
        MediaAPI.deleteStory(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization, _id: id) { (response, error) in
            
            LoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.dismissVC {
                    self.delegate.getDeleteStoryResponse(deleted: true)
                }
            }  else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.dismissVC {
                        self.delegate.getDeleteStoryResponse(deleted: false)
                    }
                }
            }
        }
    }
}

