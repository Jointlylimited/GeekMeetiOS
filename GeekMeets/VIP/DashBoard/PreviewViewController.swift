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
    var cusText : CustomTextView!
    
    private var _selectedStickerView:StickerView?
    var selectedStickerView:StickerView? {
        get {
            return _selectedStickerView
        }
        set {
            
            // if other sticker choosed then resign the handler
            if _selectedStickerView != newValue {
                if let selectedStickerView = _selectedStickerView {
                    selectedStickerView.showEditingHandlers = false
                }
                _selectedStickerView = newValue
            }
            
            // assign handler to new sticker added
            if let selectedStickerView = _selectedStickerView {
                selectedStickerView.showEditingHandlers = true
                selectedStickerView.superview?.bringSubviewToFront(selectedStickerView)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        photo.image = hself.image
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
      
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

   
    
    @IBAction func cancelButtonTouch(_ sender: Any) {
        self.popVC()
    }
    
    @IBAction func saveButtonTouch(_ sender: Any) {
        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.AddTextScreen) as? AddTextViewController
        controller!.modalTransitionStyle = .crossDissolve
        controller!.modalPresentationStyle = .overCurrentContext
        controller!.delegate = self
        self.presentVC(controller!)
        //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        //        dismiss(animated: true, completion: nil)
    }
    @IBAction func btnAddtoStoryAction(_ sender: UIButton) {
        if cusText != nil {
            let image = textToImage(drawText: cusText!.text as NSString, inImage: photo.image!, atPoint: CGPoint(x: 0, y: 0))
            print(image)
        }
        
        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.SubscriptionScreen) as? SubscriptionVC
        self.pushVC(controller!)
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
    
    func setLabel(text : CustomTextView){
        self.cusText = text
        let textView = UITextView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 50))
        textView.text = text.text
        textView.textColor = text.color
//        textView.font = UIFont(name: FontTypePoppins.Poppins_Regular.rawValue, size: text.fontSize)
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        
        adjustTextViewHeight(textView : textView)
        
        let stickerView2 = StickerView.init(contentView: textView)
        stickerView2.center = CGPoint.init(x: 100, y: 100)
        stickerView2.delegate = self
        stickerView2.setImage(UIImage.init(named: "Close")!, forHandler: StickerViewHandler.close)
        stickerView2.setImage(UIImage.init(named: "Rotate")!, forHandler: StickerViewHandler.rotate)
        stickerView2.showEditingHandlers = false
        self.view.addSubview(stickerView2)
    }
    
    func adjustTextViewHeight(textView : UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        if newSize.height < ScreenSize.height {
            print(newSize.height)
        }
        self.view.layoutIfNeeded()
    }
    
    func textToImage(drawText text: NSString, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {


        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)

        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))

        let rect = CGRect(origin: point, size: image.size)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center



        let attrs = [NSAttributedString.Key.font: UIFont(name: FontTypePoppins.Poppins_Regular.rawValue, size: cusText.fontSize)!,NSAttributedString.Key.foregroundColor : cusText.color, NSAttributedString.Key.paragraphStyle: paragraphStyle]


        text.draw(with: rect, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }}

extension PreviewViewController : TextViewControllerDelegate {
    func textViewDidFinishWithTextView(text:CustomTextView) {
        print(text)
        setLabel(text : text)
    }
}

// MARK: StickerViewDelegate
extension PreviewViewController: StickerViewDelegate {
    func stickerViewDidBeginMoving(_ stickerView: StickerView) {
        self.selectedStickerView = stickerView
    }
    
    func stickerViewDidChangeMoving(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidEndMoving(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidBeginRotating(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidChangeRotating(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidEndRotating(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidClose(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidTap(_ stickerView: StickerView) {
        self.selectedStickerView = stickerView
    }
}
