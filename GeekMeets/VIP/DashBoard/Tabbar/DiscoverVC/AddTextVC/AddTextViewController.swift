//
//  AddTextViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 29/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class AddTextViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var ColorCollView: UICollectionView!
    @IBOutlet weak var cusTextView: CustomTextView!
    
    var textSizeSlider: RangeSlider!
    var colors : [UIColor] = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.7098039216, green: 0.3254901961, blue: 0.8941176471, alpha: 0.5), #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1), #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1), #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1), #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1), #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1), #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1), #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1), #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)]
    var dictAttribute : NSMutableDictionary!
    var delegate : TextViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        setTextTheme()
        // Do any additional setup after loading the view.
    }
    
    
    func setTheme(){
        
        self.ColorCollView.register(UINib.init(nibName: Cells.ColorCollCell, bundle: Bundle.main), forCellWithReuseIdentifier: Cells.ColorCollCell)
        self.ColorCollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func setTextTheme(){
        self.textView.setPlaceholder()
        
        textSizeSlider = RangeSlider(frame: CGRect(x: 20, y: 250, w: 30, h: 250))
        textSizeSlider.delegate = self

        self.view.addSubview(textSizeSlider)
        dictAttribute = NSMutableDictionary(object: UIFont(name: FontTypePoppins.Poppins_Regular.rawValue, size: 16.0)!, forKey: NSAttributedString.Key.font as NSCopying)
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismissVC(completion: nil)
    }

    @IBAction func btnDoneAction(_ sender: UIButton) {
//        cusTextView.initwithView(view1: cusTextView)
        self.delegate.textViewDidFinishWithTextView(text: cusTextView)
        self.dismissVC(completion: nil)
    }
}
extension AddTextViewController : TextSizeSelectDelegate {
    func selectTextSize(size : CGFloat) {
        print("value is" ,size)
        self.textView.font = UIFont(name: FontTypePoppins.Poppins_Regular.rawValue, size: size)
        
        cusTextView.attributedString = NSAttributedString.init(string: textView.text, attributes: dictAttribute as? [NSAttributedString.Key : Any])
        cusTextView.text = textView.text
//        textView.size = CGSize(width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        textView.sizeToFit()
    }
}

extension AddTextViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colors.count != 0 ? self.colors.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ColorCollCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.ColorCollCell, for: indexPath) as! ColorCollCell
        let color = colors[indexPath.row]
        cell.btnViewColor.backgroundColor = color
        cusTextView.color = color
        
        cell.clickOnColorBtn = {
            self.textView.textColor = color
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let width = 30
        return CGSize(width: width, height: width)
    }
    
}


extension AddTextViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.checkPlaceholder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let lower = NSCharacterSet.lowercaseLetters
        if text.rangeOfCharacter(from: lower) != nil {
            let uppercaseStr = text //.uppercased()
            if textView.text.isEmpty {
                textView.text = (textView.text as NSString).replacingCharacters(in: range, with: uppercaseStr)
                
            }
            else{
                let beginning = textView.beginningOfDocument
                let start = textView.position(from: beginning, offset: range.location)
                let end = textView.position(from: start!, offset: range.length)
                let range = textView.textRange(from: start!, to: end!)
                textView.replace(range!, withText: uppercaseStr)
            }
            return false
        }
        else{
            return true
        }
    }
}

extension UITextView{
    
    func setPlaceholder() {
        
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Tap to write"
        placeholderLabel.font = UIFont(name: FontTypePoppins.Poppins_Regular.rawValue, size: 16.0)
        
        placeholderLabel.tag = 222
        placeholderLabel.frame = CGRect(origin: CGPoint(x: 0, y: (self.font?.pointSize)! / 2) , size: CGSize(width: UIScreen.main.bounds.w, height: 25))
        placeholderLabel.textAlignment = .center
        placeholderLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        placeholderLabel.isHidden = !self.text.isEmpty
       
        self.addSubview(placeholderLabel)
    }
    
    func checkPlaceholder() {
        
        if self.text.count  <= 100 {
            
        }
        else{
            self.text.removeLast()
        }
        let placeholderLabel = self.viewWithTag(222) as! UILabel
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
}
