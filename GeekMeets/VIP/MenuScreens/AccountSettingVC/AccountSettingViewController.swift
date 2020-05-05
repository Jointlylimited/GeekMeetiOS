//
//  AccountSettingViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 23/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AccountSettingProtocol: class {
}

class AccountSettingViewController: UIViewController, AccountSettingProtocol {
    //var interactor : AccountSettingInteractorProtocol?
    var presenter : AccountSettingPresentationProtocol?
    
    @IBOutlet weak var tblAccountList: UITableView!
    var objAccountData : [CommonCellModel] = []
    
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
        let interactor = AccountSettingInteractor()
        let presenter = AccountSettingPresenter()
        
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
        self.registerTableViewCell()
    }
    func registerTableViewCell(){
        self.tblAccountList.register(UINib.init(nibName: Cells.CommonTblListCell, bundle: Bundle.main), forCellReuseIdentifier: Cells.CommonTblListCell)
        
        self.objAccountData = [CommonCellModel(title: "Mobile Number", description: "+1 123 455 852", isDescAvailable: true), CommonCellModel(title: "Email Address", description: "john@gmail.com", isDescAvailable: true), CommonCellModel(title: "Change Password", description: "", isDescAvailable: false)]
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.popVC()
    }
}

extension AccountSettingViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objAccountData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.CommonTblListCell)
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? CommonTblListCell {
            
            
            let data = self.objAccountData[indexPath.row]
            
            cell.lblTitle.text = data.title
            cell.lblDesc.text = data.description
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = self.objAccountData[indexPath.row]
        if data.isDescAvailable {
            return UITableView.automaticDimension
        } else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let changeVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.ChangeEmailMobileScreen) as! ChangeEmailMobileViewController
        
        if indexPath.row == 0 {
            changeVC.isForUpdateEmail = false
            self.pushVC(changeVC)
        } else if indexPath.row == 1 {
            changeVC.isForUpdateEmail = true
            self.pushVC(changeVC)
        } else {
            let changeVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.ChangePasswordScreen)
            self.pushVC(changeVC)
          
        }
    }
}
