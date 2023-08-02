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
    var starAnimationView = LottieAnimationView()
    var view = UIView()
    @objc static var sharedInstance = LoaderView()
    
    
    @objc func showLoader() {
        if !NetworkReachabilityManager.init()!.isReachable{
            AppSingleton.sharedInstance().showAlert(NoInternetConnection, okTitle: "OK")
            return
        }
        
        view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height))
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        let blurEffectView = UIView()
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        indicatorCount = indicatorCount + 1
        starAnimationView = .init(name: "coffee")
        let starAnimation = AnimationKeypath(keypath: "Purple_heart_Updated")
        starAnimationView.frame = CGRect(x: (AppDelObj.window!.frame.size.width - 400) / 2.0, y: (AppDelObj.window!.frame.size.height - 400) / 2.0, w: 400, h: 400)
//        starAnimationView.center = self.view.center
//        starAnimationView.animation = starAnimation
        starAnimationView.contentMode = .scaleAspectFill
        starAnimationView.loopMode = .repeat(Float(100))
        view.addSubview(starAnimationView)
        delay(0.2) {
            AppDelObj.window?.addSubview(self.view)
        }
        starAnimationView.play()
        
//        if activity == nil {
//            activity = NVActivityIndicatorView(frame: CGRect(x: (AppDelObj.window!.frame.size.width - 60) / 2.0, y: (AppDelObj.window!.frame.size.height - 60) / 2.0, w: 60, h: 60), type: .ballGridPulse /*.lineScale*/, color: AppCommonColor.firstGradient, padding: NVActivityIndicatorView.DEFAULT_PADDING)
////            activity = NVActivityIndicatorView(frame: CGRect(x: (AppDelObj.window!.frame.size.width - 70) / 2.0, y: (AppDelObj.window!.frame.size.height - 70) / 2.0, w: 70, h: 70), type: .ballClipRotate, color: Constant.Colors.NavBG, padding: NVActivityIndicatorView.DEFAULT_PADDING)
//            activity.startAnimating()
//            AppDelObj.window?.addSubview(activity)
//        }
        
        
        AppDelObj.window!.isUserInteractionEnabled = false
//        AppDelObj.window?.bringSubviewToFront(activity)
        AppDelObj.window?.bringSubviewToFront(view)
    }
    
    @objc func hideLoader() {
        
        
//        if indicatorCount > 0 {
//            indicatorCount = indicatorCount - 1
//        }
//
//        if indicatorCount == 0 {
            AppDelObj.window!.isUserInteractionEnabled = true
////            if activity != nil {
                view.removeFromSuperview()
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
            view.removeFromSuperview()
//            if activity != nil {
//                activity.stopAnimating()
//                activity.removeFromSuperview()
//                activity = nil
//            }
//        }
    }
}


@objc class DefaultLoaderView: NSObject {
    
    override init() {
        
    }
    
    var containerView = UIView()
    var progressView = UIView()
    
    var indicatorCount:Int = 0
    var activity:NVActivityIndicatorView!
    var indicatorSize:CGFloat = 100
    
    @objc static var sharedInstance = DefaultLoaderView()
    
    
    @objc func showLoader() {
        if !NetworkReachabilityManager.init()!.isReachable{
            AppSingleton.sharedInstance().showAlert(kInternetConnection, okTitle: "OK")
            return
        }
        
        let holdingView = AppDelObj.window!
        
        containerView.frame = holdingView.frame
        containerView.center = holdingView.center
        containerView.backgroundColor = UIColor(hex: 0xffffff, alpha: 0.3)
        
        progressView.frame = holdingView.frame //CGRect(x: 0, y: 0, width: 120, height: 120)
        progressView.center = holdingView.center
        progressView.backgroundColor = UIColor(hex: 0xB2B2B2, alpha: 0.7)
        progressView.clipsToBounds = true
        
        indicatorCount = indicatorCount + 1
        if activity == nil {
            activity = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .ballClipRotatePulse, color: AppCommonColor.firstGradient, padding: NVActivityIndicatorView.DEFAULT_PADDING)
            activity.center = CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.height / 2)
            activity.startAnimating()
            
            progressView.addSubview(activity)
            containerView.addSubview(progressView)
            AppDelObj.window?.addSubview(containerView)
        }
        AppDelObj.window!.isUserInteractionEnabled = false
        AppDelObj.window?.bringSubviewToFront(containerView)
    }
    
    @objc func hideLoader() {
        
        if indicatorCount > 0 {
            indicatorCount = indicatorCount - 1
        }
        
        if indicatorCount == 0 {
            AppDelObj.window!.isUserInteractionEnabled = true
            if activity != nil {
                activity.stopAnimating()
                containerView.removeFromSuperview()
                activity = nil
            }
        }
    }
    
    @objc func hideLoaderCompletely() {
        
        indicatorCount = 0
        
        if indicatorCount == 0 {
            AppDelObj.window!.isUserInteractionEnabled = true
            if activity != nil {
                activity.stopAnimating()
                activity.removeFromSuperview()
                activity = nil
            }
        }
    }
}
extension UIColor {
    
    convenience init(hex: UInt32, alpha: CGFloat) {
        let red = CGFloat((hex & 0xFF0000) >> 16)/256.0
        let green = CGFloat((hex & 0xFF00) >> 8)/256.0
        let blue = CGFloat(hex & 0xFF)/256.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
