//
//  MessagesViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 21/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class MessageViewModel {
    let userImage: UIImage?
    var userName: String
    let msgTxt: String?
    let msgCount: String?
    let msgTime : String?
    
    init(userImage: UIImage? = nil, userName: String, msgTxt: String, msgCount: String, msgTime: String) {
        self.userImage = userImage
        self.userName = userName
        self.msgTxt = msgTxt
        self.msgCount = msgCount
        self.msgTime = msgTime
    }
}

class StoryViewModel {
    let userImage: UIImage?
    var userName: String
    
    init(userImage: UIImage? = nil, userName: String) {
        self.userImage = userImage
        self.userName = userName
    }
}

protocol MessagesProtocol: class {
}

class MessagesViewController: UIViewController, MessagesProtocol {
    //var interactor : MessagesInteractorProtocol?
    var presenter : MessagesPresentationProtocol?
    
    // MARK: Object lifecycle
    
    @IBOutlet weak var tblMessageView: UITableView!
    @IBOutlet weak var StoryCollectionView: UICollectionView!
    
    var objStoryData : [StoryViewModel] = []
    var objMsgData : [MessageViewModel] = []
    
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
        let interactor = MessagesInteractor()
        let presenter = MessagesPresenter()
        
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
        setStoryMsgViewData()
    }
    
    func registerTableViewCell(){
        self.tblMessageView.register(UINib.init(nibName: Cells.MessageListCell, bundle: Bundle.main), forCellReuseIdentifier: Cells.MessageListCell)
        self.StoryCollectionView.register(UINib.init(nibName: Cells.StoryCollectionCell, bundle: Bundle.main), forCellWithReuseIdentifier: Cells.StoryCollectionCell)
        self.StoryCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func setStoryMsgViewData(){
        self.objMsgData = [MessageViewModel(userImage: #imageLiteral(resourceName: "Image 65"), userName: "Linda Parker", msgTxt: "Hi ! there whats up?", msgCount: "2", msgTime: "11:23 pm"),MessageViewModel(userImage: #imageLiteral(resourceName: "img_intro_1"), userName: "Sophia", msgTxt: "Hi ! there whats up?", msgCount: "2", msgTime: "11:23 pm"), MessageViewModel(userImage: #imageLiteral(resourceName: "Image 64"), userName: "Sonia Mehta", msgTxt: "Hi ! there whats up?", msgCount: "2", msgTime: "11:23 pm"), MessageViewModel(userImage: #imageLiteral(resourceName: "Image 62"), userName: "Andrew Jackson", msgTxt: "Hi ! there whats up?", msgCount: "2", msgTime: "11:23 pm"), MessageViewModel(userImage: #imageLiteral(resourceName: "Image 65"), userName: "Vina Parker", msgTxt: "Hi ! there whats up?", msgCount: "2", msgTime: "11:23 pm"),MessageViewModel(userImage: #imageLiteral(resourceName: "img_intro_1"), userName: "Lily Ray", msgTxt: "Hi ! there whats up?", msgCount: "2", msgTime: "11:23 pm")]
        
        self.objStoryData = [StoryViewModel(userImage: #imageLiteral(resourceName: "Image 62"), userName: "Linda Parker"), StoryViewModel(userImage: #imageLiteral(resourceName: "Image 65"), userName: "Sophia"), StoryViewModel(userImage: #imageLiteral(resourceName: "Image 64"), userName: "Linda Parker"), StoryViewModel(userImage: #imageLiteral(resourceName: "Image 61"), userName: "Linda Parker"),StoryViewModel(userImage: #imageLiteral(resourceName: "Image 62"), userName: "Linda Parker"), StoryViewModel(userImage: #imageLiteral(resourceName: "Image 65"), userName: "Sophia")]
    }
    @IBAction func btnSearchAction(_ sender: UIButton) {
        let searchVC = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.SearchScreen) as? SearchProfileViewController
        searchVC?.objMsgData = self.objMsgData
        searchVC?.isFromDiscover = false
        self.pushVC(searchVC!)
    }
}
extension MessagesViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objMsgData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.MessageListCell)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? MessageListCell {
            
            let data = objMsgData[indexPath.row]
            cell.userImgView.image = data.userImage
            cell.userName.text = data.userName
            cell.msgText.text = data.msgTxt
            cell.msgTime.text = data.msgTime
            cell.msgCount.text = data.msgCount
            
            cell.btnChat.alpha = 0.0
        }
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
        headerTitle.frame = CGRect(x: 20, y: headerView.frame.origin.y + 10, w: ScreenSize.width - 60, h: 30)
        headerTitle.text = "Chats"
        headerTitle.textColor = .black
        headerTitle.font = UIFont(name: "Poppins-SemiBold", size: 14)
        headerView.addSubview(headerTitle)
        
        return headerView
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.objMsgData.remove(at: indexPath.row)
            self.tblMessageView.reloadData()
            //whatever
            success(true)
        })
        let theImage: UIImage? = UIImage(named:"icn_unmatch")?.withRenderingMode(.alwaysOriginal)
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.8941176471, blue: 0.8941176471, alpha: 1)
        deleteAction.image = theImage
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension MessagesViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objStoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : StoryCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.StoryCollectionCell, for: indexPath) as! StoryCollectionCell
        let data = self.objStoryData[indexPath.row]
        cell.userImage.setImage(data.userImage, for: .normal)
        cell.userName.text = data.userName
        
        cell.viewBorder.alpha = 0.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 130)
    }
}
