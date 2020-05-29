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
    
    var pageIndex : Int = 0
    var items: [UserDetail] = []
    var item: [Content] = []
    var SPB: SegmentedProgressBar!
    var player: AVPlayer!
    let loader = ImageLoader()
    var isFromMatchVC : Bool = false
    
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
        }
        userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.height / 2;
        userProfileImage.imageFromServerURL(items[pageIndex].imageUrl)
        lblUserName.text = items[pageIndex].name
        item = items[pageIndex].contents as! [Content]
        
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
        if pageIndex == (self.items.count - 1) {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            _ = ContentViewControllerVC.goNextPage(fowardTo: pageIndex + 1)
        }
    }
    
    @objc func tapOn(_ sender: UITapGestureRecognizer) {
        SPB.skip()
    }
    
    //MARK: - Play or show image
    func playVideoOrLoadImage(index: NSInteger) {
        if item[index].type == "image" {
            self.SPB.duration = 5
            self.imagePreview.isHidden = false
            self.videoView.isHidden = true
            self.imagePreview.imageFromServerURL(item[index].url)
        } else {
            self.imagePreview.isHidden = true
            self.videoView.isHidden = false
            
            resetPlayer()
            guard let url = NSURL(string: item[index].url) as URL? else {return}
            self.player = AVPlayer(url: url)
            
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
        var retVal: TimeInterval = 5.0
        if item[index].type == "image" {
            retVal = 5.0
        } else {
            guard let url = NSURL(string: item[index].url) as URL? else { return retVal }
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
            let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.ReportScreen)
            self.presentVC(controller)
        } else {
            
        }
    }
    @IBAction func btnViewStoryAction(_ sender: UIButton) {
        
    }
}
