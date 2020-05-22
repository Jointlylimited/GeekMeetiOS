//
//  LoaderView.swift
//  BackPack
//
//  Created by SOTSYS153 on 15/05/18.
//  Copyright © 2018 SOTSYS203. All rights reserved.
//

import Foundation
import NVActivityIndicatorView
import Alamofire
import Lottie

@objc class LoaderView: NSObject {
    
    override init() {
        
    }
    
    var indicatorCount:Int = 0
    var activity:NVActivityIndicatorView!
    let starAnimationView = AnimationView()
    
    @objc static var sharedInstance = LoaderView()
    
    
    @objc func showLoader() {
        if !NetworkReachabilityManager.init()!.isReachable{
            AppSingleton.sharedInstance().showAlert(NoInternetConnection, okTitle: "OK")
            return
        }
        
        indicatorCount = indicatorCount + 1
        let starAnimation = Animation.named("newheart")
        starAnimationView.frame = CGRect(x: (AppDelObj.window!.frame.size.width - 400) / 2.0, y: (AppDelObj.window!.frame.size.height - 400) / 2.0, w: 400, h: 400)
//        starAnimationView.center = self.view.center
        starAnimationView.animation = starAnimation
        starAnimationView.contentMode = .scaleAspectFill
        starAnimationView.loopMode = .repeat(Float(25))
        AppDelObj.window?.addSubview(starAnimationView)
        starAnimationView.play()
        
//        if activity == nil {
//            activity = NVActivityIndicatorView(frame: CGRect(x: (AppDelObj.window!.frame.size.width - 60) / 2.0, y: (AppDelObj.window!.frame.size.height - 60) / 2.0, w: 60, h: 60), type: .ballGridPulse /*.lineScale*/, color: AppCommonColor.firstGradient, padding: NVActivityIndicatorView.DEFAULT_PADDING)
////            activity = NVActivityIndicatorView(frame: CGRect(x: (AppDelObj.window!.frame.size.width - 70) / 2.0, y: (AppDelObj.window!.frame.size.height - 70) / 2.0, w: 70, h: 70), type: .ballClipRotate, color: Constant.Colors.NavBG, padding: NVActivityIndicatorView.DEFAULT_PADDING)
//            activity.startAnimating()
//            AppDelObj.window?.addSubview(activity)
//        }
        
        
        AppDelObj.window!.isUserInteractionEnabled = false
//        AppDelObj.window?.bringSubviewToFront(activity)
        AppDelObj.window?.bringSubviewToFront(starAnimationView)
    }
    
    @objc func hideLoader() {
        
        
//        if indicatorCount > 0 {
//            indicatorCount = indicatorCount - 1
//        }
//
//        if indicatorCount == 0 {
            AppDelObj.window!.isUserInteractionEnabled = true
////            if activity != nil {
                starAnimationView.removeFromSuperview()
//                activity.stopAnimating()
//                activity.removeFromSuperview()
//                activity = nil
//            }
//        }
    }
    
    @objc func hideLoaderCompletely() {
        
//        indicatorCount = 0
//
//        if indicatorCount == 0 {
            AppDelObj.window!.isUserInteractionEnabled = true
            starAnimationView.removeFromSuperview()
//            if activity != nil {
//                activity.stopAnimating()
//                activity.removeFromSuperview()
//                activity = nil
//            }
//        }
    }
}
