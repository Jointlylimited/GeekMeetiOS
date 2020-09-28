//
//  TabbarViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 17/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol TabbarProtocol: class {
    func getStoryListResponse(response: StoryResponse)
}

class TabbarViewController: UITabBarController, TabbarProtocol {
    //var interactor : TabbarInteractorProtocol?
    var presenter : TabbarPresentationProtocol?
    
    var isFromMatch : Bool = false
    var userDict : NSDictionary = [:]
    
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
        let interactor = TabbarInteractor()
        let presenter = TabbarPresenter()
        
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
        self.presenter?.callStoryListAPI()
        SetTabbarItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func SetTabbarItem(){
        if !isFromMatch {
            self.selectedIndex = 2
        } else {
            delay(0.2) {
                let obj = GeekMeets_StoryBoard.Chat.instantiateViewController(withIdentifier: GeekMeets_ViewController.OneToOneChatScreen) as! OneToOneChatVC
                obj._userIDForRequestSend = self.userDict["xmppUserID"] as? String
                obj.userName = self.userDict["name"] as? String
                obj.imageString = self.userDict["imageString"] as? String
                obj.inputMsgText = self.userDict["inputMsgText"] != nil ? (self.userDict["inputMsgText"] as? String)! : ""
                self.pushVC(obj)
            }
        }
    }
}

//MARK: API Methods
extension TabbarViewController{
    func getStoryListResponse(response: StoryResponse){
        if response.responseCode == 200 {
            print(response.responseData!)
            if response.responseData!.bottomStory!.count - UserDataModel.getStoryCount() != 0 {
                if response.responseData?.bottomStory == nil || response.responseData?.bottomStory?.count == 0 {
                    
                    self.tabBar.items![3].badgeValue = "\(response.responseData!.bottomStory!.count - UserDataModel.getStoryCount())"
                    UserDataModel.setNewMatchesCount(count: response.responseData!.bottomStory!.count - UserDataModel.getStoryCount())
                }
            }
        }
    }
    
    func getUnreadMsgCount(){
        let arrFriends = SOXmpp.manager.arrFriendsList
        var count : Int = 0
        for friend in arrFriends {
            if let unreadCount = SOXmpp.manager.GetUnreadCound(of: friend.jID) , unreadCount > 0 {
                count = unreadCount + count
            }
        }
        if count != 0 {
            self.tabBar.items![1].badgeValue = "\(count)"
        }
    }
}
