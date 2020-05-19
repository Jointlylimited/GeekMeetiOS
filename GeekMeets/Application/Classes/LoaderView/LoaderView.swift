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

@objc class LoaderView: NSObject {
    
    override init() {
        
    }
    
    var indicatorCount:Int = 0
    var activity:NVActivityIndicatorView!
    
    @objc static var sharedInstance = LoaderView()
    
    
    @objc func showLoader() {
        if !NetworkReachabilityManager.init()!.isReachable{
            AppSingleton.sharedInstance().showAlert(NoInternetConnection, okTitle: "OK")
            return
        }
        
        indicatorCount = indicatorCount + 1
        if activity == nil {
            activity = NVActivityIndicatorView(frame: CGRect(x: (AppDelObj.window!.frame.size.width - 60) / 2.0, y: (AppDelObj.window!.frame.size.height - 60) / 2.0, w: 60, h: 60), type: .ballGridPulse /*.lineScale*/, color: AppCommonColor.firstGradient, padding: NVActivityIndicatorView.DEFAULT_PADDING)
//            activity = NVActivityIndicatorView(frame: CGRect(x: (AppDelObj.window!.frame.size.width - 70) / 2.0, y: (AppDelObj.window!.frame.size.height - 70) / 2.0, w: 70, h: 70), type: .ballClipRotate, color: Constant.Colors.NavBG, padding: NVActivityIndicatorView.DEFAULT_PADDING)
            activity.startAnimating()
            AppDelObj.window?.addSubview(activity)
        }
        AppDelObj.window!.isUserInteractionEnabled = false
        AppDelObj.window?.bringSubviewToFront(activity)
    }
    
    @objc func hideLoader() {
        
        if indicatorCount > 0 {
            indicatorCount = indicatorCount - 1
        }
        
        if indicatorCount == 0 {
            AppDelObj.window!.isUserInteractionEnabled = true
            if activity != nil {
                activity.stopAnimating()
                activity.removeFromSuperview()
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
