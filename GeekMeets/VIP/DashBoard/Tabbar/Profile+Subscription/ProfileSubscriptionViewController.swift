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
