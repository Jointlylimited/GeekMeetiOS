//
//  FullScreenImageViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 08/07/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    var chatMsg : Model_ChatMessage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageViewData()
        // Do any additional setup after loading the view.
    }
    
    func setImageViewData(){
        DefaultLoaderView.sharedInstance.hideLoader()
        if chatMsg!.msgType! == "image" {
            if let _url = chatMsg!.getLocalPath() {
                imgView.sd_setImage(with: _url, placeholderImage: #imageLiteral(resourceName: "placeholder_rect"), options: [.scaleDownLargeImages], context: nil)
            }
        } else {
            if let _url = URL(string: "\(fileUploadURL)\(chatMsg!.url)") {
                imgView.sd_setImage(with: _url, placeholderImage: #imageLiteral(resourceName: "placeholder_rect"), options: [.scaleDownLargeImages], context: nil)
            }
        }
    }
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.dismissVC(completion: nil)
    }
}
