//
//  SocialMediaLinkVC.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 15/05/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class SocialMediaLinkModel {
    var image: UIImage?
    var title: String
    var link: String?
    
    init(image: UIImage?, title: String, link: String) {
        self.image = image
        self.title = title
        self.link = link
    }
}

class SocialMediaLinkVC: UIViewController {

    @IBOutlet weak var tblSocialLinkList: UITableView!
    var objSocialMediaModel : [SocialMediaLinkModel] = []
    var userProfileModel : UserProfileModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCell()
        // Do any additional setup after loading the view.
    }
    
    func registerTableViewCell(){
        self.objSocialMediaModel = [SocialMediaLinkModel(image: #imageLiteral(resourceName: "icn_Instagaram"), title: "Instagram", link: "https://www.instagram.com/Shopie Lee"), SocialMediaLinkModel(image: #imageLiteral(resourceName: "snapchat"), title: "Snapchat", link: "https://www.snapchat.com/Shopie Lee"), SocialMediaLinkModel(image: #imageLiteral(resourceName: "icn_facebook"), title: "Facebook", link: "https://www.facebook.com/Shopie Lee")]
        self.tblSocialLinkList.register(UINib.init(nibName: Cells.SocialLinkCell, bundle: Bundle.main), forCellReuseIdentifier: Cells.SocialLinkCell)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.popVC()
    }
    @IBAction func btnSaveAction(_ sender: GradientButton) {
        self.userProfileModel?.vFacebookLink = self.objSocialMediaModel[2].link
        self.userProfileModel?.vSnapchatLink = self.objSocialMediaModel[1].link
        self.userProfileModel?.vInstagramLink = self.objSocialMediaModel[0].link
        self.popVC()
    }
}

extension SocialMediaLinkVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objSocialMediaModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.SocialLinkCell)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? SocialLinkCell {
            
            let data = self.objSocialMediaModel[indexPath.row]
            cell.btnTitle.setImage(data.image, for: .normal)
            cell.btnTitle.setTitle(data.title, for: .normal)
            cell.txtSocialLink.text = data.link
            cell.txtSocialLink.delegate = self
            cell.txtSocialLink.tag = indexPath.row
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}

extension SocialMediaLinkVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            self.objSocialMediaModel[0].link = textField.text
        } else if textField.tag == 1 {
            self.objSocialMediaModel[1].link = textField.text
        } else {
            self.objSocialMediaModel[2].link = textField.text
        }
    }
}
