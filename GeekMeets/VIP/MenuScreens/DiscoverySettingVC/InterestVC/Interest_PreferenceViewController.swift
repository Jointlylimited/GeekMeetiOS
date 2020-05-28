//
//  Interest_PreferenceViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 20/05/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol Interest_PreferenceProtocol: class {
    func getPreferenceData(response : PreferencesResponse)
}

class Interest_PreferenceViewController: UIViewController, Interest_PreferenceProtocol {
    //var interactor : Interest_PreferenceInteractorProtocol?
    var presenter : Interest_PreferencePresentationProtocol?
    
    @IBOutlet weak var tblInterestList: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var btnUpdate: GradientButton!
    
    var header_title : String = ""
    var objDiscoverData : [PreferencesField] = []
    var DesDetails : [String] = []
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
        let interactor = Interest_PreferenceInteractor()
        let presenter = Interest_PreferencePresenter()
        
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
            self.btnUpdate.alpha = 0.0
        } else {
            self.btnUpdate.alpha = 1.0
        }
        self.registerTableViewCell()
    }
    
    func registerTableViewCell(){
        
        self.lblTitle.text = header_title
        
        if self.lblTitle.text!.count >= (DeviceType.iPhone5orSE ? 40 : 45) {
            self.viewHeightConstant.constant = 185
        } else if self.lblTitle.text!.count >= 20 {
            self.viewHeightConstant.constant = 135
        } else {
            self.viewHeightConstant.constant = 85
        }
        
        self.tblInterestList.register(UINib.init(nibName: Cells.CommonTblListCell, bundle: Bundle.main), forCellReuseIdentifier: Cells.CommonTblListCell)
        
        for data in self.objDiscoverData {
            var textOption = ""
            if data.iPreferenceId == 5 || data.iPreferenceId == 6 {
                for optionAns in data.preferenceAnswer! {
                    textOption = textOption == "" ? optionAns.fAnswer! : "\(textOption)-\(optionAns.fAnswer!)"
                }
                DesDetails.append(textOption)
            } else {
                for option in data.preferenceOption! {
                    for optionAns in data.preferenceAnswer! {
                        if option.iOptionId == optionAns.iOptionId {
                            textOption = textOption == "" ? option.vOption! : "\(textOption), \(option.vOption!)"
                        }
                    }
                }
                DesDetails.append(textOption)
            }
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.popVC()
    }
    @IBAction func btnUpdateAction(_ sender: GradientButton) {
        self.presenter?.callQuestionaryAPI()
    }
    
    func getPreferenceData(response : PreferencesResponse) {
        if response.responseCode == 200 {
            UserDataModel.UserPreferenceResponse = response
            self.popVC()
        }
    }
}

extension Interest_PreferenceViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objDiscoverData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.CommonTblListCell)
        cell?.selectionStyle = .none
        if let cell = cell as? CommonTblListCell {
            
            let data = self.objDiscoverData[indexPath.row]
            print(data)
            cell.lblTitle.text = data.txPreference
            print(DesDetails)
            cell.lblDesc.text = DesDetails[indexPath.row]
            
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.objDiscoverData[indexPath.row]
        
        let queVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.Edit_PreferenceScreen) as? EditPreferenceViewController
        queVC?.index = data.iPreferenceId!
        queVC?.isFromMenu = self.isFromMenu
        
        queVC?.objPreModel.objPrefrence = data
        queVC?.selectedCells = (data.preferenceAnswer?.map({($0.iOptionId!)}))!
        if data.iPreferenceId == 5 || data.iPreferenceId == 6 {
            queVC?.heightData = (data.preferenceAnswer?.map({($0.fAnswer!)}))!
        }
        self.pushVC(queVC!)
    }
}


extension Interest_PreferenceViewController : SelectInterestAgeGenderDelegate {
    func getSelectedValue(index: Int, data: String) {
//        if index == 1 {
//            self.objDiscoverData[0].description = data
//        } else if index == 5 {
//            self.objDiscoverData[1].description = data
//        } else if index == 12 {
//            self.objDiscoverData[2].description = data
//        } else if index == 18 {
//            self.objDiscoverData[3].description = data
//        } else {
//            self.objDiscoverData[4].description = data
//        }
        self.tblInterestList.reloadData()
    }
}
