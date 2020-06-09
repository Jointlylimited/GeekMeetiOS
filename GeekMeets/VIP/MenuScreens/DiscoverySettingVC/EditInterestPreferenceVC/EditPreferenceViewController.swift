//
//  EditPreferenceViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 27/05/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol EditPreferenceProtocol: class {
     func getPostPreferenceResponse(response : CommonResponse)
}

class EditPreferenceViewController: UIViewController, EditPreferenceProtocol {
    //var interactor : EditPreferenceInteractorProtocol?
    var presenter : EditPreferencePresentationProtocol?
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var preferenceCollView: UICollectionView!
    @IBOutlet weak var HeightSliderView: UIView!
    @IBOutlet weak var lblMinHeight: UILabel!
    @IBOutlet weak var lblMaxHeight: UILabel!
    @IBOutlet weak var heightSeekSlider: RangeSeekSlider!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var viewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var btnDone: GradientButton!
    @IBOutlet weak var collectopnViewBottomConstraint: NSLayoutConstraint!
    
    var objPreModel = PrefrenceModel()
    var selectedCells = [Int]()
    var heightData = [String]()
    var intAgeSelected:Int = 0
    var index : Int = 0
     var isFromMenu : Bool = true
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = EditPreferenceInteractor()
        let presenter = EditPreferencePresenter()
        
        //View Controller will communicate with only presenter
        viewController.presenter = presenter
        //viewController.interactor = interactor
        
        //Presenter will communicate with Interector and Viewcontroller
        presenter.viewController = viewController
        presenter.interactor = interactor
        
        //Interactor will communucate with only presenter.
        interactor.presenter = presenter
    }
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFromMenu {
            self.collectopnViewBottomConstraint.constant = 0
            self.btnDone.alpha = 0.0
        } else {
            self.collectopnViewBottomConstraint.constant = 90
            self.btnDone.alpha = 1.0
        }
        self.setPreferenceData(index: self.index)
    }
    
    func setPreferenceData(index : Int){
        self.objPreModel.objPrefrence = self.objPreModel.objPrefrence
        self.lblTitle.text = "\(self.objPreModel.objPrefrence.txPreference!)"
        
        if self.lblTitle.text!.count >= (DeviceType.iPhone5orSE ? 40 : 45) {
            self.viewHeightConstant.constant = 185
        } else if self.lblTitle.text!.count >= 20 {
            self.viewHeightConstant.constant = 135
        } else {
            self.viewHeightConstant.constant = 85
        }
        
        if index == 5 {
            setHeightPickerData(index : index)
            self.HeightSliderView.alpha = 1
            self.preferenceCollView.alpha = 0
            self.lblHeight.alpha = 1
            self.lblHeight.text = heightData.count == 0 ? "0.0" : self.heightData[0]
            self.lblMinHeight.alpha = 0
            self.lblMaxHeight.alpha = 0
            
        } else if index == 6 {
            setHeightPickerData(index : index)
            self.HeightSliderView.alpha = 1
            self.preferenceCollView.alpha = 0
            self.lblHeight.alpha = 0
            self.lblMinHeight.alpha = 1
            self.lblMaxHeight.alpha = 1
            
            self.lblMinHeight.text = heightData.count == 0 ? "0.0" : "\(self.heightData[0])"
            self.lblMaxHeight.text = heightData.count == 0 ? "10.0" : "\(self.heightData[1])"
        }else {
            self.HeightSliderView.alpha = 0
            self.preferenceCollView.alpha = 1
        }
//        self.selectedCells = []
        self.preferenceCollView.reloadData()
    }
    
    func setHeightPickerData(index : Int){
        
        heightSeekSlider.delegate = self
        
        heightSeekSlider.hideLabels = true
        heightSeekSlider.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        heightSeekSlider.colorBetweenHandles = #colorLiteral(red: 0.606272161, green: 0.2928337753, blue: 0.8085166812, alpha: 1)
        heightSeekSlider.handleImage = #imageLiteral(resourceName: "icn_rect_1")
        
        heightSeekSlider.minValue = 0.0
        heightSeekSlider.maxValue = 10.0
        
        heightSeekSlider.selectedMinValue = heightData.count == 0 ? 0 : (heightData.count == 1 ? 0.0 : CGFloat(Double(self.heightData[0])!))
        heightSeekSlider.selectedMaxValue = heightData.count == 0 ? 0 : (heightData.count == 1 ? CGFloat(Double(self.heightData[0])!)  : CGFloat(Double(self.heightData[1])!))
        
        if index == 5 {
            heightSeekSlider.disableRange = true
        } else {
            heightSeekSlider.disableRange = false
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.popVC()
    }
    @IBAction func btnDoneAction(_ sender: GradientButton) {
        self.callCreatePreferenceAPI()
    }
}

extension EditPreferenceViewController {
    func callCreatePreferenceAPI(){
        
        let data = self.selectedCells.map { String($0) }
            .joined(separator: ",")
        let answerID = self.objPreModel.objPrefrence!.preferenceAnswer!.map { String($0.iAnswerId!) }
        .joined(separator: ",")
        
        var value = ""
        if self.index == 5 {
            value = self.lblHeight.text ?? ""
        } else if self.index == 6 {
            value = "\(self.lblMinHeight.text ?? "")-\(self.lblMaxHeight.text ?? "")"
        } else {
            value = ""
        }
        
        let params = RequestParameter.sharedInstance().updatePrefrence(tiPreferenceType: "\(self.objPreModel.objPrefrence.tiPreferenceType!)", iPreferenceId: "\(self.objPreModel.objPrefrence.iPreferenceId!)", iOptionId: (self.index == 5 || self.index == 6) ? value : data, iAnswerId: self.objPreModel.objPrefrence.tiPreferenceType == 1 ? "" : answerID)
        self.presenter?.callCreatePreferenceAPI(params : params)
    }
    
    func getPostPreferenceResponse(response : CommonResponse){
        if response.responseCode == 200 {
                self.popVC()
            } else {
                AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle: "OK")
            }
    }
}

//MARK:UICollectionview
extension EditPreferenceViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,SelectAgeDelegate
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objPreModel.objPrefrence != nil ? self.objPreModel.objPrefrence.preferenceOption!.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell : SelectAgeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectAgeCell", for: indexPath) as! SelectAgeCell
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? SelectAgeCell {
            cell.indexPath = indexPath
            let name = self.objPreModel.objPrefrence.preferenceOption![indexPath.row].vOption
            let optionID = self.objPreModel.objPrefrence.preferenceOption![indexPath.row].iOptionId
            cell.lblTitle.text = name
            
            if self.selectedCells.contains(optionID!) {
                cell.btnSelectAge.layer.borderColor = #colorLiteral(red: 0.7098039216, green: 0.3254901961, blue: 0.8941176471, alpha: 1)
                cell.btnSelectAge.setTitleColor(#colorLiteral(red: 0.7098039216, green: 0.3254901961, blue: 0.8941176471, alpha: 1), for: .normal)
                cell.lblTitle.textColor = #colorLiteral(red: 0.7098039216, green: 0.3254901961, blue: 0.8941176471, alpha: 1)
            } else {
                cell.btnSelectAge.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
                cell.btnSelectAge.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5), for: .normal)
                cell.lblTitle.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
            }
            
            cell.clickOnCell = {
                if self.objPreModel.objPrefrence.tiPreferenceType == 0 {
                    if self.selectedCells.count != 0 {
                        let index = self.selectedCells.firstIndex { (index) -> Bool in
                            return index == optionID
                        }
                        if self.selectedCells.contains(optionID!) {
                            self.selectedCells.remove(at: index!)
                        } else {
                            self.selectedCells.removeAll()
                            if self.selectedCells.count == 0 {
                                self.selectedCells.append(optionID!)
                            }
                        }
                    } else {
                        if self.selectedCells.count == 0 {
                            self.selectedCells.append(optionID!)
                        }
                    }
                } else {
                    if self.selectedCells.contains(optionID!) {
                        let index = self.selectedCells.firstIndex { (index) -> Bool in
                            return index == optionID
                        }
                        self.selectedCells.remove(at: index!)
                    } else {
                        self.selectedCells.append(optionID!)
                    }
                }
                self.preferenceCollView.reloadData()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let name = self.objPreModel.objPrefrence.preferenceOption![indexPath.row].vOption
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight = CGFloat(50)
        let size = (name! as NSString).size(withAttributes: [
            NSAttributedString.Key.font : UIFont(name: FontTypePoppins.Poppins_Medium.rawValue, size: FontSizePoppins.sizePopupMenuTitle.rawValue)!
        ])
        
        if size.width > yourWidth {
            return CGSize(width: size.width, height: yourHeight)
        } else {
            return CGSize(width: yourWidth, height: yourHeight)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func actionSelectAge(at index:IndexPath){
        intAgeSelected = index.row
        preferenceCollView.reloadData()
    }
}

//MARK:- Range Seek Slider delegate
extension EditPreferenceViewController: RangeSeekSliderDelegate {

    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === heightSeekSlider {
            print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
            
            let min_value = String(format: "%.2f",Double(minValue))
            let max_value = String(format: "%.2f",Double(maxValue))
            
            let minvalue = String(format: "%.2f",Double(minValue)).split(".").last
            let maxvalue = String(format: "%.2f",Double(maxValue)).split(".").last
            
            if minvalue! == 10 || minvalue! == 11 {
                self.lblMinHeight.text = min_value
            } else {
                self.lblMinHeight.text = String(format: "%.1f",minValue)
            }
            
            if maxvalue! == 10 ||  maxvalue! == 11 {
                self.lblHeight.text = max_value
                self.lblMaxHeight.text = max_value
            } else {
                self.lblHeight.text = String(format: "%.1f",maxValue)
                self.lblMaxHeight.text = String(format: "%.1f",maxValue)
            }
        }
    }

    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }

    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}
