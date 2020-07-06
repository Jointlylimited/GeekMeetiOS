//
//  MyMatchesViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 22/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MyMatchesProtocol: class {
    func getMatchResponse(response : MatchUser)
    func getUnMatchResponse(response : CommonResponse)
}

class MyMatchesViewController: UIViewController, MyMatchesProtocol {
    //var interactor : MyMatchesInteractorProtocol?
    var presenter : MyMatchesPresentationProtocol?
    
    @IBOutlet weak var tblMatchList: UITableView!
    
    var objMatchData : [SwipeUserFields] = []
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
        let interactor = MyMatchesInteractor()
        let presenter = MyMatchesPresenter()
        
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
        self.setStoryMsgViewData()
        
    }
    
    func registerTableViewCell(){
        self.tblMatchList.register(UINib.init(nibName: Cells.MessageListCell, bundle: Bundle.main), forCellReuseIdentifier: Cells.MessageListCell)
    }
    
    func setStoryMsgViewData(){
        self.presenter?.callMatchListAPI()
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func btnSearchAction(_ sender: UIButton) {
        let searchVC = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.SearchScreen) as? SearchProfileViewController
        searchVC?.objMsgData = self.objMatchData
        searchVC?.isFromDiscover = false
        self.pushVC(searchVC!)
    }
}

extension MyMatchesViewController {
    func getMatchResponse(response : MatchUser) {
        if response.responseCode == 200 {
            UserDataModel.setMatchesCount(count: response.responseData!.count)
            self.objMatchData = response.responseData!
            self.tblMatchList.reloadData()
        }
    }
    
    func getUnMatchResponse(response : CommonResponse){
        if response.responseCode == 200 {
           self.presenter?.callMatchListAPI()
        } 
    }
}
//MARK: UITableView Delegate & Datasource Methods
extension MyMatchesViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objMatchData.count != 0 ? self.objMatchData.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.MessageListCell)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? MessageListCell {
            
            cell.btnChat.alpha = 1.0
            
            if self.objMatchData.count != 0  {
                let data = self.objMatchData[indexPath.row]
                let url = URL(string:"\(data.vProfileImage!)")
                cell.userImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_round"))
                cell.userName.text = data.vProfileName
                cell.msgText.text = "Matches on 10 Jun, 2020, 10:23 am"
                
                cell.clickOnChatBtn = {
                    let obj = GeekMeets_StoryBoard.Chat.instantiateViewController(withIdentifier: GeekMeets_ViewController.OneToOneChatScreen) as! OneToOneChatVC
                    obj._userIDForRequestSend = data.vOtherUserXmpp
                    obj.userName = data.vProfileName
                    obj.imageString = data.vProfileImage
                    obj.modalPresentationStyle = .fullScreen
                    self.pushVC(obj)
                }
            }
            cell.msgTime.alpha = 0.0
            cell.msgCount.alpha = 0.0
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.presenter?.callUnMatchUserAPI(iProfileId: "\(self.objMatchData[indexPath.row].vOtherUserXmpp!)")
            //whatever
            success(true)
        })
        let theImage: UIImage? = UIImage(named:"icn_unmatch")?.withRenderingMode(.alwaysOriginal)
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.8941176471, blue: 0.8941176471, alpha: 1)
        deleteAction.image = theImage
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
