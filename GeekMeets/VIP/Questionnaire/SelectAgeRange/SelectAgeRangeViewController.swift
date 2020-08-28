//
//  SelectAgeRangeViewController.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 23/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SelectAgeRangeProtocol: class {
//    func displayQuesionsData(Data : [NSDictionary])
    func displayPreferenceData(response : PreferencesResponse)
    func getPostPreferenceResponse(response : CommonResponse)
}

struct QuestionaryModel {
    var arrQuestionnaire:[NSDictionary]!
    var objQuestionnaire:QuestionnaireModel!
}

struct PrefrenceModel {
    var arrPrefrenceData:[PreferencesField]!
    var objPrefrence:PreferencesField!
}
class SelectAgeRangeViewController: UIViewController, SelectAgeRangeProtocol {
    
    
    //var interactor : SelectAgeRangeInteractorProtocol?
    var presenter : SelectAgeRangePresentationProtocol?
    
    @IBOutlet weak var lblQuestionIndex: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var clnSelectAge: UICollectionView!
    @IBOutlet weak var HeightSliderView: UIView!
    @IBOutlet weak var lblMinHeight: UILabel!
    @IBOutlet weak var lblMaxHeight: UILabel!
    @IBOutlet weak var heightSeekSlider: RangeSeekSlider!
    @IBOutlet weak var lblHeight: UILabel!
    
    var objQuestionModel = QuestionaryModel()
    var objPreModel = PrefrenceModel()
    var intAgeSelected:Int = 0
    var index : Int = 0
    var selectedCells = [Int]()
    var selectedCellValues = [String]()
    var isFromSignUp : Bool = true
    var interest_delegate : SelectInterestAgeGenderDelegate!
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    var feet:Int = 0
    var inch:Int = 0
    
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
        let interactor = SelectAgeRangeInteractor()
        let presenter = SelectAgeRangePresenter()
        
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
        doSomething()
    }
    
    func doSomething() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.isNavigationBarHidden = true
        self.presenter?.callQuestionaryAPI()
    }

    func setHeightPickerData(index : Int){
        
        heightSeekSlider.delegate = self
        heightSeekSlider.hideLabels = true
        heightSeekSlider.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        heightSeekSlider.colorBetweenHandles = #colorLiteral(red: 0.606272161, green: 0.2928337753, blue: 0.8085166812, alpha: 1)
        heightSeekSlider.handleImage = #imageLiteral(resourceName: "icn_rect_1")
        heightSeekSlider.minValue = 0.0
        heightSeekSlider.maxValue = 10.0
        
        if index == 5 {
            heightSeekSlider.disableRange = true
            self.lblHeight.text = "0.0"
            
        } else {
            heightSeekSlider.disableRange = false
            self.lblMinHeight.text = "0.0"
            self.lblMaxHeight.text = "10.0"
        }
    }
    
    func setPreferenceData(index : Int){
        self.objPreModel.objPrefrence = self.objPreModel.arrPrefrenceData[self.index - 1]
        self.lblQuestionIndex.text = "\(self.index)/\(self.objPreModel.arrPrefrenceData.count)"
        self.lblTitle.text = "\(self.objPreModel.objPrefrence.txPreference!)"
        if self.objPreModel.objPrefrence.tiPreferenceType == 1 {
            self.lblDescription.isHidden = false
        }else{
            self.lblDescription.isHidden = true
        }
        if index == 5 {
            setHeightPickerData(index : index)
            self.HeightSliderView.alpha = 1
            self.clnSelectAge.alpha = 0
            self.lblHeight.alpha = 1
            self.lblMinHeight.alpha = 0
            self.lblMaxHeight.alpha = 0
        } else if index == 6 {
            setHeightPickerData(index : index)
            self.HeightSliderView.alpha = 1
            self.clnSelectAge.alpha = 0
            self.lblHeight.alpha = 0
            self.lblMinHeight.alpha = 1
            self.lblMaxHeight.alpha = 1
        }else {
            self.HeightSliderView.alpha = 0
            self.clnSelectAge.alpha = 1
        }
        self.selectedCells = []
        self.selectedCellValues = []
        self.clnSelectAge.reloadData()
    }
    
    @objc func changeVlaue(_ sender: UISlider) {
        let value = CGFloat(sender.value)
        print("value is" ,value)
         self.lblMinHeight.text = "\(sender.minimumValue)"
        self.lblMaxHeight.text = "\(sender.maximumValue)"
    }
    
    //MARK: IBAction Method
    @IBAction func actionContinues(_ sender: Any) {
        if isFromSignUp {
                if self.selectedCells.count != 0 {
                    self.callCreatePreferenceAPI()
                } else {
                    if self.index == 5 || self.index == 6 {
                        self.callCreatePreferenceAPI()
                    } else {
                        AppSingleton.sharedInstance().showAlert(kSelectPreferene, okTitle: "OK")
                    }
                }
        } else {
            let data = self.selectedCellValues.map { String($0) }
            .joined(separator: ", ")
            let value = self.index == 5 ? self.lblHeight.text : (self.index == 6 ? "\(self.lblMinHeight.text ?? "") -\(self.lblMaxHeight.text ?? "")" : data)
            self.interest_delegate.getSelectedValue(index : self.index, data: value!)
            self.popVC()
        }
    }
    
    @IBAction func actionSkip(_ sender: Any) {
        if isFromSignUp {
            if self.index < self.objPreModel.arrPrefrenceData.count{
                self.index = index + 1
                self.setPreferenceData(index: self.index)
            } else {
                self.presenter?.callQuestionaryAPI()
            }
        } else {
            self.popVC()
        }
    }
}

extension SelectAgeRangeViewController {
    
    func displayPreferenceData(response : PreferencesResponse) {
        self.objPreModel.arrPrefrenceData = response.responseData
        if isFromSignUp {
            if index == 0 {
                self.objPreModel.objPrefrence = self.objPreModel.arrPrefrenceData[self.index]
                self.lblTitle.text = "\(self.objPreModel.arrPrefrenceData[self.index].txPreference!)"
                self.index = self.index + 1
                self.lblQuestionIndex.text = "\(self.index)/\(self.objPreModel.arrPrefrenceData.count)"
                setPreferenceData(index: self.index)
            } else {
                UserDataModel.UserPreferenceResponse = response
                self.presenter?.actionContinue()
            }
        } else {
            setPreferenceData(index: self.index)
        }
        self.selectedCells = []
        self.selectedCellValues = []
        self.clnSelectAge.reloadData()
    }
    
    func callCreatePreferenceAPI(){
        let data = self.selectedCells.map { String($0) }
        .joined(separator: ",")
        
        var value = ""
        if self.index == 5 {
            value = self.lblHeight.text ?? ""
        } else if self.index == 6 {
            value = "\(self.lblMinHeight.text ?? "")-\(self.lblMaxHeight.text ?? "")"
        } else {
            value = ""
        }
        
        let params = RequestParameter.sharedInstance().createPrefrence(tiPreferenceType: "\(self.objPreModel.objPrefrence.tiPreferenceType!)", iPreferenceId: "\(self.objPreModel.objPrefrence.iPreferenceId!)", iOptionId: data, vAnswer: value)
        self.presenter?.callCreatePreferenceAPI(params : params)
    }
    
    func getPostPreferenceResponse(response : CommonResponse){
        if response.responseCode == 200 {
            if self.index < self.objPreModel.arrPrefrenceData.count {
                self.index = index + 1
                self.setPreferenceData(index: self.index)
            } else {
                self.presenter?.callQuestionaryAPI()
            }
        }
    }
}

//MARK:UICollectionview
extension SelectAgeRangeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,SelectAgeDelegate
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
                            self.selectedCellValues.remove(at: index!)
                        } else {
                            self.selectedCells.removeAll()
                            self.selectedCellValues.removeAll()
                            if self.selectedCells.count == 0 {
                                self.selectedCells.append(optionID!)
                                self.selectedCellValues.append(name!)
                            }
                        }
                    } else {
                        if self.selectedCells.count == 0 {
                            self.selectedCells.append(optionID!)
                            self.selectedCellValues.append(name!)
                        }
                    }
                } else {
                    if self.selectedCells.contains(optionID!) {
                        let index = self.selectedCells.firstIndex { (index) -> Bool in
                            return index == optionID
                        }
                        self.selectedCells.remove(at: index!)
                        self.selectedCellValues.remove(at: index!)
                    } else {
                        self.selectedCells.append(optionID!)
                        self.selectedCellValues.append(name!)
                    }
                }
                self.clnSelectAge.reloadData()
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
        clnSelectAge.reloadData()
    }
}

extension SelectAgeRangeViewController: RangeSeekSliderDelegate {

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

