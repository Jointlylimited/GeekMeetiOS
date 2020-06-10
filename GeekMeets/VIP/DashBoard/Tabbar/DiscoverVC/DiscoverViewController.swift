//
//  DiscoverViewController.swift
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

protocol TextViewControllerDelegate {
  func textViewDidFinishWithTextView(text:CustomTextView)
}

protocol DiscoverProtocol: class {
    func getStoryListResponse(response: StoryResponse)
    func getViewStoryResponse(response : CommonResponse)
}

class DiscoverViewController: UIViewController, DiscoverProtocol {
    //var interactor : DiscoverInteractorProtocol?
    var presenter : DiscoverPresentationProtocol?
    
    @IBOutlet weak var StoryCollView: UICollectionView!
    @IBOutlet weak var AllStoryCollView: UICollectionView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tblDiscoverList: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var btnAddStory: UIButton!
    
    var objStoryData : [StoryViewModel] = []
    var arrayDetails :  [UserDetail] = []
    var objAllStoryArray : [StoryResponseFields]?
    var objStoryArray : [StoryResponseFields]?
    var objOwnStoryArray : [StoryResponseFields]?
    
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
        let interactor = DiscoverInteractor()
        let presenter = DiscoverPresenter()
        
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
        self.registerCollectionViewCell()
        setStoryData()
//        arrayDetails = fetchUserData()
//        self.presenter?.callStoryListAPI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter?.callStoryListAPI()
    }
    
    func registerCollectionViewCell(){
        
        self.StoryCollView.register(UINib.init(nibName: Cells.StoryCollectionCell, bundle: Bundle.main), forCellWithReuseIdentifier: Cells.StoryCollectionCell)
        self.StoryCollView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        self.AllStoryCollView.register(UINib.init(nibName: Cells.DiscoverCollectionCell, bundle: Bundle.main), forCellWithReuseIdentifier: Cells.DiscoverCollectionCell)
        self.AllStoryCollView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let layout = CustomImageLayout()
        layout.scrollDirection = .vertical
        self.AllStoryCollView.collectionViewLayout = layout
    }
    
    func setStoryData(){
        self.btnAddStory.dropShadow(view: self.btnAddStory)
        self.objStoryData = [StoryViewModel(userImage: #imageLiteral(resourceName: "Image 65"), userName: "Your story"), StoryViewModel(userImage: #imageLiteral(resourceName: "Image 63"), userName: "Sophia"), StoryViewModel(userImage: #imageLiteral(resourceName: "Image 65"), userName: "Lilly Ray"), StoryViewModel(userImage: #imageLiteral(resourceName: "Image 64"), userName: "Andre Jackson"),StoryViewModel(userImage: #imageLiteral(resourceName: "Image 65"), userName: "Vault Shade"), StoryViewModel(userImage: #imageLiteral(resourceName: "Image 64"), userName: "Sonia Parker"), StoryViewModel(userImage: #imageLiteral(resourceName: "Image 65"), userName: "Lipcy Kate"), StoryViewModel(userImage: #imageLiteral(resourceName: "Image 65"), userName: "Jack Man"), StoryViewModel(userImage: #imageLiteral(resourceName: "Image 65"), userName: "Paule Walker"), StoryViewModel(userImage: #imageLiteral(resourceName: "Image 62"), userName: "Cally Turner"),StoryViewModel(userImage: #imageLiteral(resourceName: "image_1"), userName: "Andy San"), StoryViewModel(userImage: #imageLiteral(resourceName: "Image 65"), userName: "Anny Ray")]
    }

    @IBAction func btnSearchAction(_ sender: UIButton) {
        let searchVC = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.SearchScreen) as? SearchProfileViewController
        searchVC?.objStoryData = self.objStoryArray!
        searchVC?.isFromDiscover = true
        self.pushVC(searchVC!)
    }
    @IBAction func actionAddPhoto(_ sender: Any) {
        let preViewVC = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.CameraViewScreen) as? ViewController
        self.pushVC(preViewVC!)
    }
}

extension DiscoverViewController{
    func getStoryListResponse(response: StoryResponse){
        if response.responseCode == 200 {
            print(response.responseData!)
            if response.responseData!.count != 0 {
                self.tblDiscoverList.alpha = 1
                self.btnSearch.alpha = 1
                self.lblNoData.alpha = 0
                self.objAllStoryArray = response.responseData
                self.objStoryArray = response.responseData
                self.objStoryArray = self.objStoryArray!.sorted(by: { $0.tiIsView! < $1.tiIsView! })
                self.objOwnStoryArray = self.objStoryArray!.filter({($0.iUserId) == UserDataModel.currentUser?.iUserId})
                
                if self.objOwnStoryArray!.count != 0 {
                    for obj in self.objOwnStoryArray! {
                        self.objStoryArray!.removeAll(where: {$0.iUserId == obj.iUserId})
                    }
                }
                
                self.StoryCollView.reloadData()
                self.AllStoryCollView.reloadData()
                self.tblDiscoverList.reloadData()
                
            } else {
                self.tblDiscoverList.alpha = 0
                self.btnSearch.alpha = 0
                self.lblNoData.alpha = 1
                AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle: "OK")
            }
        }
    }
    
    func getViewStoryResponse(response : CommonResponse){
        if response.responseCode == 200 {
            self.presenter?.callStoryListAPI()
        }
    }
}

extension DiscoverViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.StoryCollView ? (self.objStoryArray != nil ? (self.objOwnStoryArray!.count !=  0 ? self.objStoryArray!.count + 1 : self.objStoryArray!.count) : 0) : (self.objAllStoryArray != nil ? self.objAllStoryArray!.count : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.StoryCollView {
            let cell : StoryCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.StoryCollectionCell, for: indexPath) as! StoryCollectionCell

            if self.objOwnStoryArray != nil && self.objOwnStoryArray!.count != 0 {
                if indexPath.row != 0 {
                    let data = self.objStoryArray![indexPath.row - 1]
                    if data.txStory != "" {
                        let url = URL(string:"\(data.tiStoryType! == "0" ? data.txStory! : data.vThumbnail!)")
                        print(url!)
                        cell.userImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_rect"))
                        cell.userName.text = data.vName
                        if data.tiIsView == 1 {
                            cell.viewBorder.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5049901832)
                        }
                    }
                } else {
                    cell.userName.text =  "Your Story"
                    let url = URL(string: UserDataModel.currentUser!.vProfileImage!)
                    cell.userImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_rect"))
                }
            } else {
                let data = self.objStoryArray![indexPath.row ]
                if data.txStory != "" {
                    let url = URL(string:"\(data.tiStoryType! == "0" ? data.txStory! : data.vThumbnail!)")
                    print(url!)
                    cell.userImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_rect"))
                    cell.userName.text = data.vName
                    if data.tiIsView == 1 {
                        cell.viewBorder.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5049901832)
                    }
                }
            }
            return cell
        } else {
            let cell : DiscoverCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.DiscoverCollectionCell, for: indexPath) as! DiscoverCollectionCell
            if self.objAllStoryArray != nil {
                let data = self.objAllStoryArray![indexPath.row]
                if data.txStory != "" {
                    let url = URL(string:"\(data.tiStoryType! == "0" ? data.txStory! : data.vThumbnail!)")
                    print(url!)
                    cell.userImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_rect"))
                }
            } else {
                let data = self.objStoryData[indexPath.row]
                cell.userImgView.image = data.userImage
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        if collectionView == self.StoryCollView {
            if self.objOwnStoryArray != nil && self.objOwnStoryArray!.count != 0 {
                if indexPath.row != 0 {
                    if self.objStoryArray![indexPath.row - 1].tiIsView == 0 {
                        self.presenter?.callViewStoryAPI(iStoryId: "\(self.objStoryArray![indexPath.row - 1].iStoryId!)")
                    }
                }
            } else {
                if self.objStoryArray![indexPath.row].tiIsView == 0 {
                    self.presenter?.callViewStoryAPI(iStoryId: "\(self.objStoryArray![indexPath.row].iStoryId!)")
                }
            }
        }
        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.StoryContentScreen) as? ContentViewController
        controller!.modalTransitionStyle = .crossDissolve
        controller!.modalPresentationStyle = .overCurrentContext
        controller?.isFromMatchVC = false
        if collectionView == self.StoryCollView  {
            if self.objOwnStoryArray != nil && self.objOwnStoryArray!.count != 0 {
                if indexPath.row == 0 {
                    controller?.pages = self.objOwnStoryArray!
                } else {
                    controller?.pages = [self.objStoryArray![indexPath.row - 1]]
                }
            } else {
                controller?.pages = [self.objStoryArray![indexPath.row]]
            }
        } else {
            controller?.pages = [self.objAllStoryArray![indexPath.row]]
        }
        self.presentVC(controller!)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.StoryCollView {
            return CGSize(width: 80, height: 130)
        } else {
            let width = ScreenSize.width/2 - 12
            return CGSize(width: width, height: width)
        }
    }
}

