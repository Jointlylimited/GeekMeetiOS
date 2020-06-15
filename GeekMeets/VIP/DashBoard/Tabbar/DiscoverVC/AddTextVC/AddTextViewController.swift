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
    @IBOutlet weak var textViewHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var TextNameCollView: UICollectionView!
    @IBOutlet weak var colorCollBottomConstraint: NSLayoutConstraint!
    var fontSize : CGFloat = 14
    var textSizeSlider: RangeSlider!
    var colors : [UIColor] = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.7098039216, green: 0.3254901961, blue: 0.8941176471, alpha: 0.5), #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1), #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1), #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1), #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1), #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1), #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1), #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1), #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1), #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1), #colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1), #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1), #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1),#colorLiteral(red: 0.5269387364, green: 0.201957494, blue: 0.08749309927, alpha: 1), #colorLiteral(red: 0.120503135, green: 0.7448164821, blue: 0.9430143237, alpha: 1), #colorLiteral(red: 0.4770843983, green: 0.08635065705, blue: 0.1774665415, alpha: 1)]
    var textTypeArray : [String] = ["ExtraLight", "ThinItalic", "ExtraLightItalic", "BoldItalic", "Light", "Medium", "SemiBoldItalic", "ExtraBoldItalic", "ExtraBold", "BlackItalic", "Regular", "LightItalic", "Bold", "Black", "Thin", "SemiBold", "Italic", "MediumItalic"]
    var dictAttribute : NSMutableDictionary!
    var delegate : TextViewControllerDelegate!
    var SelectedIndexArray : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        setTextTheme()
//        setLabel()
        // Do any additional setup after loading the view.
    }
    
    
    func setTheme(){
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        self.ColorCollView.register(UINib.init(nibName: Cells.ColorCollCell, bundle: Bundle.main), forCellWithReuseIdentifier: Cells.ColorCollCell)
        self.ColorCollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let layout = CustomImageLayout()
        layout.scrollDirection = .horizontal
        self.TextNameCollView.collectionViewLayout = layout
        self.TextNameCollView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.cusTextView.fontSize = 16.0
        self.cusTextView.font = UIFont(name: FontTypePoppins.Poppins_Regular.rawValue, size: self.cusTextView.fontSize)!
    }
    
    func setTextTheme(){
        self.textView.setPlaceholder(view : self.textView)
        
        textSizeSlider = RangeSlider(frame: CGRect(x: 20, y: ScreenSize.frame.y + 125, w: 30, h: 250))
        textSizeSlider.delegate = self

        self.view.addSubview(textSizeSlider)
        dictAttribute = NSMutableDictionary(object: UIFont(name: FontTypePoppins.Poppins_Regular.rawValue, size: 16.0)!, forKey: NSAttributedString.Key.font as NSCopying)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismissVC(completion: nil)
    }

    @IBAction func btnDoneAction(_ sender: UIButton) {
        cusTextView.frame = CGRect(x: self.textView.x, y: self.textView.y, w: self.textView.width, h: self.textViewHeightConstant.constant)
        self.delegate.textViewDidFinishWithTextView(text: cusTextView)
        self.dismissVC(completion: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.animateTextField(up: true, height : keyboardHeight)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.animateTextField(up: false, height : 0)
    }
    
    func animateTextField(up: Bool, height : CGFloat) {
        let movement = (up ? -height : height)
        if up == true {
            self.colorCollBottomConstraint?.constant = ScreenSize.frame.y + (ScreenSize.height/2 - (DeviceType.iPhone5orSE ? 40 : 100))
        } else {
            self.colorCollBottomConstraint?.constant = 0
            self.ColorCollView!.contentInset.bottom = 0
            self.ColorCollView!.scrollIndicatorInsets.bottom = 0
        }
        self.view.layoutIfNeeded()
    }
}
extension AddTextViewController : TextSizeSelectDelegate {
    func selectTextSize(size : CGFloat) {
        print("value is" ,size)
        fontSize = size
        adjustTextViewHeight()
        if self.textViewHeightConstant.constant < ScreenSize.height {
            self.textView.font = UIFont(name: cusTextView.font.fontName, size: size)
            cusTextView.font = self.textView.font
            cusTextView.attributedString = NSAttributedString.init(string: textView.text, attributes: dictAttribute as? [NSAttributedString.Key : Any])
            cusTextView.text = textView.text
            cusTextView.fontSize = size
        }
    }
}

extension AddTextViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.ColorCollView {
            return self.colors.count != 0 ? self.colors.count : 0
        } else {
            return self.textTypeArray.count != 0 ? self.textTypeArray.count : 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.ColorCollView {
            let cell : ColorCollCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.ColorCollCell, for: indexPath) as! ColorCollCell
            let color = colors[indexPath.row]
            cell.btnViewColor.backgroundColor = color
            
            cell.clickOnColorBtn = {
                self.textView.textColor = color
                self.cusTextView.color = color
            }
            return cell
        } else {
            let cell : SelectTextTypeCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.SelectTextTypeCell, for: indexPath) as! SelectTextTypeCell
            let text = self.textTypeArray[indexPath.row]
            cell.btnText.setTitle(text, for: .normal)
            
            if self.SelectedIndexArray.contains(indexPath.row) {
                cell.btnText.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                let font = UIFont(name: "Poppins-\(text)", size: cusTextView.fontSize)
                self.textView.font = font
                self.cusTextView.font = font
            } else {
                cell.btnText.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
            }

            cell.clickOnText = {
                if self.SelectedIndexArray.count == 0 {
                    let index = self.SelectedIndexArray.firstIndex { (index) -> Bool in
                        return index == indexPath.row
                    }
                    if self.SelectedIndexArray.contains(indexPath.row) {
                        self.SelectedIndexArray.remove(at: index!)
                    } else {
                        self.SelectedIndexArray.removeAll()
                        if self.SelectedIndexArray.count == 0 {
                            self.SelectedIndexArray.append(indexPath.row)
                        }
                    }
                } else {
                    if self.SelectedIndexArray.count > 0 {
                        self.SelectedIndexArray.removeAll()
                        self.SelectedIndexArray.append(indexPath.row)
                    }
                }
                self.TextNameCollView.reloadData()
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 30
        
        if collectionView == self.ColorCollView {
            return CGSize(width: width, height: width)
        } else {
            let yourHeight = CGFloat(50)
            
            let name = self.textTypeArray[indexPath.row]
            let size = (name as NSString).size(withAttributes: [
                NSAttributedString.Key.font : UIFont(name: FontTypePoppins.Poppins_SemiBold.rawValue, size: FontSizePoppins.sizeNormalTitleNav.rawValue)!
            ])
            return CGSize(width: size.width + 20, height: yourHeight)
        }
    }
}


extension AddTextViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.checkPlaceholder()
        adjustTextViewHeight()
        textView.centerVertically()
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
    
    func adjustTextViewHeight() {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        if newSize.height < ScreenSize.height {
            print(newSize.height)
            self.textViewHeightConstant.constant = newSize.height
            textView.centerVertically()
        }
        self.view.layoutIfNeeded()
    }
}

extension UITextView{
    
    func setPlaceholder(view : UITextView) {
        
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Tap to write"
        placeholderLabel.font = UIFont(name: FontTypePoppins.Poppins_Regular.rawValue, size: 16.0)
        
        placeholderLabel.tag = 222
        placeholderLabel.frame = CGRect(origin: CGPoint(x: 0, y: (view.frame.height) / 2) , size: CGSize(width: UIScreen.main.bounds.w, height: 25))
        placeholderLabel.textAlignment = .center
        placeholderLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        placeholderLabel.isHidden = !self.text.isEmpty
       
        self.addSubview(placeholderLabel)
    }
    
    func checkPlaceholder() {
        
        if self.text.count  <= 100 {
            
        }
        else{
//            self.text.removeLast()
        }
        let placeholderLabel = self.viewWithTag(222) as! UILabel
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(0, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}


