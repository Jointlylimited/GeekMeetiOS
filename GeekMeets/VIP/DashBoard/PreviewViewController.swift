//
//  PreviewViewController.swift
//  Custom Camera
//
//  Created by Rudra Jikadra on 08/12/17.
//  Copyright © 2017 Rudra Jikadra. All rights reserved.
//

import UIKit


class PreviewViewController: UIViewController {
    
    
    @IBOutlet weak var photo: UIImageView!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = self.image
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
      
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

   
    
    @IBAction func cancelButtonTouch(_ sender: Any) {
     
     
    }
    
    @IBAction func saveButtonTouch(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        dismiss(animated: true, completion: nil)
    }
    
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // Get the new view controller using segue.destination.
      // Pass the selected object to the new view controller.
      if segue.identifier == "SegueToYourTabBarController" {
          if let destVC = segue.destination as? TabbarViewController {
              destVC.selectedIndex = 0
          }
      }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
}
