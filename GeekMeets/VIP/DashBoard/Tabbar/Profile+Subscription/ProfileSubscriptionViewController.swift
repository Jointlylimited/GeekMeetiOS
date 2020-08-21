//
//  ProfileSubscriptionViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 11/08/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileSubscriptionViewController: UIViewController {

    @IBOutlet weak var lblUserNameAge: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblActiveGeek: UILabel!
    @IBOutlet weak var lblActiveBoost: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProfileData()
    }
    
    func setProfileData(){
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        
        //ProfileImage setup
        if UserDataModel.currentUser?.vProfileImage != "" {
            let url = URL(string:"\(UserDataModel.currentUser!.vProfileImage!)")
            print(url!)
            self.imgProfile.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_round"))
        }
        self.callGeeksPlansAPI()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func btnProfileAction(_ sender: UIButton) {
        self.MoveToProfileVC()
    }
    @IBAction func btnEditProfileAction(_ sender: UIButton) {
        self.MoveToEditProfileVC()
    }
    @IBAction func btnTopStoryAction(_ sender: UIButton) {
        self.presentGeeksVC()
    }
    
    @IBAction func btnBoostAction(_ sender: UIButton) {
        self.presentBoostVC()
    }
    
    @IBAction func btnSubscriptionAction(_ sender: UIButton) {
        self.presentSubscriptionVC()
    }
    
    func MoveToProfileVC(){
//         let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.ProfileScreen) as! ProfileViewController
//        self.pushVC(controller)
        let matchVC = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.MatchProfileScreen) as? MatchProfileViewController
        matchVC!.UserID = UserDataModel.currentUser?.iUserId
        matchVC!.isFromHome = false
        self.pushVC(matchVC!)
    }
    
    func MoveToEditProfileVC(){
         let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.EditProfileScreen) as! EditProfileViewController
        self.pushVC(controller)
    }
    
    func presentSubscriptionVC(){
        let subVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.ManageSubscriptionScreen) as! ManageSubscriptionViewController
        subVC.modalTransitionStyle = .crossDissolve
        subVC.modalPresentationStyle = .overCurrentContext
        self.presentVC(subVC)
    }
    
    func presentBoostVC(){
        let boostVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.BoostScreen) as! BoostViewController
        boostVC.modalTransitionStyle = .crossDissolve
        boostVC.modalPresentationStyle = .overCurrentContext
        self.presentVC(boostVC)
    }
    
    func presentGeeksVC(){
        let topVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.TopGeeksScreen) as! TopGeeksViewController
        topVC.modalTransitionStyle = .crossDissolve
        topVC.modalPresentationStyle = .overCurrentContext
        self.presentVC(topVC)
    }
}

extension ProfileSubscriptionViewController {
    func callGeeksPlansAPI(){
        //        LoaderView.sharedInstance.showLoader()
        BoostGeekAPI.boostGeekPlans(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization, tiType: 2) { (response, error) in
            
            //            LoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.getGeeksPlansResponse(response: response!)
            } else if response?.responseCode == 400 {
                self.getGeeksPlansResponse(response: response!)
            }  else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.getGeeksPlansResponse(response: response!)
                }
            }
        }
    }
        
    func callBoostPlansAPI(){
        //        LoaderView.sharedInstance.showLoader()
        BoostGeekAPI.boostGeekPlans(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization, tiType: 1) { (response, error) in
            
            //            LoaderView.sharedInstance.hideLoader()
            if response?.responseCode == 200 {
                self.getBoostPlansResponse(response: response!)
            } else if response?.responseCode == 400 {
                self.getBoostPlansResponse(response: response!)
            }  else {
                if error != nil {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                } else {
                    self.getBoostPlansResponse(response: response!)
                }
            }
        }
    }
    func getGeeksPlansResponse(response : BoostGeekResponse){
        if response.responseCode == 200 {
            self.lblActiveGeek.text = response.responseData?.pendingGeek != 0 ? "\(response.responseData!.pendingGeek!) Pending" : (response.responseData?.iExpireAt != "" ? "Active" : "Inactive")
            self.callBoostPlansAPI()
        } else {
            self.lblActiveGeek.text = "Inactive"
        }
    }
    
    func getBoostPlansResponse(response : BoostGeekResponse) {
        if response.responseCode == 200 {
            self.lblActiveBoost.text = response.responseData?.pendingBoost != 0 ? "\(response.responseData!.pendingBoost!) Pending" : (response.responseData?.iExpireAt != "" ? "Active" : "Inactive")
        } else {
            self.lblActiveBoost.text = "Inactive"
        }
    }
}
