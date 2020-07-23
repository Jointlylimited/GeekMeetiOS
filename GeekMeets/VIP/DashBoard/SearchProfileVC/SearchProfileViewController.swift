//
//  SearchProfileViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 27/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SearchProfileProtocol: class {
}

class SearchProfileViewController: UIViewController, SearchProfileProtocol {
    //var interactor : SearchProfileInteractorProtocol?
    var presenter : SearchProfilePresentationProtocol?
    
    @IBOutlet weak var tblSearchList: UITableView!
    @IBOutlet weak var txtSearchField: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var lblNoResult: UILabel!
    
    var objMsgData : [SwipeUserFields] = []
    var objStoryData : [StoryResponseArray] = []
    var objFilterMsgData : [SwipeUserFields] = []
    var objFilterStoryData : [StoryResponseArray] = []
    var objAllMsgData : [SwipeUserFields] = []
    var objAllFilterStoryData : [StoryResponseArray] = []
    var isFromDiscover : Bool = true
    
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
        let interactor = SearchProfileInteractor()
        let presenter = SearchProfilePresenter()
        
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
        setFilterData()
    }
    
    func setFilterData(){
        if !self.isFromDiscover {
            self.objFilterMsgData = self.objMsgData
            self.objAllMsgData = self.objMsgData
        } else {
            self.objFilterStoryData = self.objStoryData
            self.objAllFilterStoryData = self.objStoryData
        }
        self.tblSearchList.reloadData()
    }
    
    @objc func btnClearAllAction(){
        self.btnSearch.alpha = 0.0
        self.txtSearchField.text = ""
        self.lblNoResult.alpha = 0
        
        if !self.isFromDiscover {
            self.objFilterMsgData.removeAll()
            self.objFilterMsgData = self.objAllMsgData
        } else {
            self.objFilterStoryData.removeAll()
            self.objFilterStoryData = self.objAllFilterStoryData
        }
        self.tblSearchList.reloadData()
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.popVC()
    }
}

//MARK: UITableView Delegate & Datasource Methods
extension SearchProfileViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.isFromDiscover {
            return self.objFilterMsgData.count != 0 ? self.objFilterMsgData.count : 0
        } else {
            return self.objFilterStoryData.count != 0 ? self.objFilterStoryData.count : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.SearchListCell)
        cell?.selectionStyle = .none
        
        if let cell = cell as? SearchListCell {
            if !self.isFromDiscover {
                let data = objFilterMsgData[indexPath.row]
                let url = URL(string:"\(data.vProfileImage!)")
                cell.imgProfile.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_round"))
                cell.lblName.text = data.vProfileName
                if self.txtSearchField.text != "" {
                    cell.btnClose.alpha = 1
                } else {
                    cell.btnClose.alpha = 0
                }
                
                cell.clickOnCloseBtn = {
                    print("Click on close button.")
                    if self.objFilterMsgData.count != 0 {
                        self.objFilterMsgData.remove(at: indexPath.row)
                        self.tblSearchList.reloadData()
                        if self.objFilterMsgData.count == 0 {
                            self.lblNoResult.alpha = 1
                        } else {
                            self.lblNoResult.alpha = 0
                        }
                    }
                }
            } else {
                let data = objFilterStoryData[indexPath.row][0]
                if data.vProfileImage != "" {
                    let url = URL(string:"\(data.vProfileImage!)")
                    print(url!)
                    cell.imgProfile.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_rect"))
                }
                cell.lblName.text = data.vName
                if self.txtSearchField.text != "" {
                    cell.btnClose.alpha = 1
                } else {
                    cell.btnClose.alpha = 0
                }
                cell.clickOnCloseBtn = {
                    print("Click on close button.")
                    if self.objFilterStoryData.count != 0 {
                        self.objFilterStoryData.remove(at: indexPath.row)
                        self.tblSearchList.reloadData()
                        if self.objFilterStoryData.count == 0 {
                            self.lblNoResult.alpha = 1
                        } else {
                            self.lblNoResult.alpha = 0
                        }
                    }
                }
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:UIView =  UIView()
        headerView.backgroundColor = .white
        
        let headerTitle = UILabel()
        headerTitle.frame = CGRect(x: 20, y: headerView.frame.origin.y + 5, w: ScreenSize.width - 60, h: 30)
        headerTitle.text = "Recents"
        headerTitle.textColor = .black
        headerTitle.font = UIFont(name: "Poppins-SemiBold", size: 14)
        headerView.addSubview(headerTitle)
        
        if self.txtSearchField.text != "" {
            let buttonClr = UIButton(frame: CGRect(x: ScreenSize.width - 110, y: headerView.frame.origin.y + 5, w: 100, h: 30))
            buttonClr.backgroundColor = .clear
            buttonClr.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 14)
            buttonClr.setTitleColor(#colorLiteral(red: 0.5294117647, green: 0.1803921569, blue: 0.7647058824, alpha: 1), for: .normal)
            buttonClr.setTitle("Clear All", for: .normal)
            buttonClr.addTarget(self, action: #selector(btnClearAllAction), for: .touchUpInside)
            headerView.addSubview(buttonClr)
        }
        return headerView
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let matchVC = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.MatchProfileScreen) as? MatchProfileViewController
        if self.isFromDiscover {
            if objFilterStoryData.count != 0 {
                matchVC!.UserID = objFilterStoryData[indexPath.row][0].iUserId
            }
        } else {
            if objFilterMsgData.count != 0 {
                matchVC!.UserID = objFilterMsgData[indexPath.row].iOtherUserId
            }
        }
        matchVC!.isFromHome = false
        self.pushVC(matchVC!)
    }
}

//MARK:- Textfield Delegate
extension SearchProfileViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtSearchField {
            textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
            if !self.isFromDiscover {
                self.objFilterMsgData.removeAll()
            } else {
                self.objFilterStoryData.removeAll()
            }
            return true
        }
        return false
    }
    
    @objc func textFieldDidChange(textField : UITextField){
        
        if !self.isFromDiscover {
            if textField.text == "" {
                self.btnSearch.alpha = 0.0
                self.objFilterMsgData = self.objMsgData
                print(self.objFilterMsgData.count)
            } else {
                self.btnSearch.alpha = 1.0
                self.objFilterMsgData.removeAll()
                for data in self.objMsgData {
                    print(self.objFilterMsgData.count)
                    if data.vProfileName!.lowercased().contains(textField.text!) {
                            self.objFilterMsgData.append(data)
                    }
                }
            }
            if objFilterMsgData.count == 0 {
                self.lblNoResult.alpha = 1
            } else {
                self.lblNoResult.alpha = 0
            }
        } else {
            if textField.text == "" {
                self.btnSearch.alpha = 0.0
                self.objFilterStoryData = self.objStoryData
                print(self.objFilterStoryData.count)
            } else {
                self.btnSearch.alpha = 1.0
                self.objFilterStoryData.removeAll()
                for data in self.objStoryData {
                    print(self.objFilterStoryData.count)
                    if data[0].vName!.lowercased().contains(textField.text!) {
                        self.objFilterStoryData.append([data[0]])
                    }
                }
            }
            if objFilterStoryData.count == 0 {
                self.lblNoResult.alpha = 1
            } else {
                self.lblNoResult.alpha = 0
            }
        }
        self.tblSearchList.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
