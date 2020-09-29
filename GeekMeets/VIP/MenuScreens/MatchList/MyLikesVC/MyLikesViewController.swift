//
//  MyLikesViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 11/08/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MyLikesProtocol: class {
    func getMatchResponse(response : MatchUser)
}

class MyLikesViewController: UIViewController, MyLikesProtocol {
    //var interactor : MyLikesInteractorProtocol?
    var presenter : MyLikesPresentationProtocol?
    
    @IBOutlet weak var tblMatchList: UITableView!
    @IBOutlet weak var lblNoUser: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var LikesCollectionView: UICollectionView!
    @IBOutlet weak var btnPurchase: GradientButton!
    
    var objMatchData : [SwipeUserFields] = []
    var parentNavigationController : UINavigationController?
    
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
        let interactor = MyLikesInteractor()
        let presenter = MyLikesPresenter()
        
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
//        self.setStoryMsgViewData()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setStoryMsgViewData()
    }
    
    func registerTableViewCell(){
        self.tblMatchList.register(UINib.init(nibName: Cells.MessageListCell, bundle: Bundle.main), forCellReuseIdentifier: Cells.MessageListCell)
        
        self.LikesCollectionView.register(UINib.init(nibName: Cells.DiscoverCollectionCell, bundle: Bundle.main), forCellWithReuseIdentifier: Cells.DiscoverCollectionCell)
        self.LikesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let layout = CustomImageLayout()
        layout.scrollDirection = .vertical
        self.LikesCollectionView.collectionViewLayout = layout
    }
    
    func setStoryMsgViewData(){
        self.presenter?.callMatchListAPI()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func btnSearchAction(_ sender: UIButton) {
        let searchVC = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.SearchScreen) as? SearchProfileViewController
        searchVC?.isFromDiscover = false
        self.pushVC(searchVC!)
    }
    @IBAction func btnPurchaseAction(_ sender: GradientButton) {
        presentSubVC()
    }
    
    func presentSubVC(){
        let subVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.TopGeeksScreen) as! TopGeeksViewController
        subVC.modalTransitionStyle = .crossDissolve
        subVC.modalPresentationStyle = .overFullScreen
        self.presentVC(subVC)
    }
}

extension MyLikesViewController {
    func getMatchResponse(response : MatchUser) {
        self.objMatchData = response.responseData!
        self.objMatchData = self.objMatchData.reversed()
        if self.objMatchData.count != 0 {
            self.tblMatchList.alpha = 1.0
            self.LikesCollectionView.alpha = 1.0
            self.lblNoUser.alpha = 0.0
        } else {
            self.tblMatchList.alpha = 0.0
            self.LikesCollectionView.alpha = 0.0
            self.lblNoUser.alpha = 1.0
        }
        if UserDataModel.currentUser?.tiIsSubscribed == 0 {
            self.btnPurchase.alpha = 1.0
        } else {
            self.btnPurchase.alpha = 0.0
        }
        
        self.tblMatchList.reloadData()
        self.LikesCollectionView.reloadData()
    }
}

//MARK: UITableView Delegate & Datasource Methods
extension MyLikesViewController : UITableViewDataSource, UITableViewDelegate {
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
            
            cell.btnChat.alpha = 0.0
            if self.objMatchData.count != 0  {
                let data = self.objMatchData[indexPath.row]
                let url = URL(string:"\(data.vProfileImage!)")
                cell.userImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_round"))
                cell.userName.text = data.vProfileName
                cell.msgText.text = data.iMatchDateTime
                
                cell.clickOnChatBtn = {
                    let obj = GeekMeets_StoryBoard.Chat.instantiateViewController(withIdentifier: GeekMeets_ViewController.OneToOneChatScreen) as! OneToOneChatVC
                    obj.objFriend?.jID = UserDataModel.currentUser?.vXmppUser ?? ""
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
}

//MARK: UICollectionview Delegate & Datasource Methods
extension MyLikesViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objMatchData.count != 0 ? self.objMatchData.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : DiscoverCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.DiscoverCollectionCell, for: indexPath) as! DiscoverCollectionCell
        let data = self.objMatchData[indexPath.row]
        cell.lblName.text = data.vProfileName
        let url = URL(string:"\(data.vProfileImage!)")
        cell.userImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_rect"))
        if UserDataModel.currentUser?.tiIsSubscribed == 0 {
            cell.userImgView.blurBackground()
        }
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ScreenSize.width/2 - 12
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if UserDataModel.currentUser?.tiIsSubscribed == 0 {
            self.presentSubVC()
        }
    }
}
