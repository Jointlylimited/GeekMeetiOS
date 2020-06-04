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
}

class DiscoverViewController: UIViewController, DiscoverProtocol {
    //var interactor : DiscoverInteractorProtocol?
    var presenter : DiscoverPresentationProtocol?
    
    @IBOutlet weak var StoryCollView: UICollectionView!
    @IBOutlet weak var AllStoryCollView: UICollectionView!
    
    var objStoryData : [StoryViewModel] = []
    var arrayDetails :  [UserDetail] = []
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
        arrayDetails = fetchUserData()
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
        self.objStoryData = [StoryViewModel(userImage: #imageLiteral(resourceName: "Image 65"), userName: "Your story"), StoryViewModel(userImage: #imageLiteral(resourceName: "Image 63"), userName: "Sophia"), StoryViewModel(userImage: #imageLiteral(resourceName: "Image 65"), userName: "Lilly Ray"), StoryViewModel(userImage: #imageLiteral(resourceName: "Image 64"), userName: "Andre Jackson"),StoryViewModel(userImage: #imageLiteral(resourceName: "Image 65"), userName: "Vault Shade"), StoryViewModel(userImage: #imageLiteral(resourceName: "Image 64"), userName: "Sonia Parker"), StoryViewModel(userImage: #imageLiteral(resourceName: "Image 65"), userName: "Lipcy Kate"), StoryViewModel(userImage: #imageLiteral(resourceName: "Image 65"), userName: "Jack Man"), StoryViewModel(userImage: #imageLiteral(resourceName: "Image 65"), userName: "Paule Walker"), StoryViewModel(userImage: #imageLiteral(resourceName: "Image 62"), userName: "Cally Turner"),StoryViewModel(userImage: #imageLiteral(resourceName: "image_1"), userName: "Andy San"), StoryViewModel(userImage: #imageLiteral(resourceName: "Image 65"), userName: "Anny Ray")]
        self.StoryCollView.reloadData()
        self.AllStoryCollView.reloadData()
    }

    @IBAction func btnSearchAction(_ sender: UIButton) {
        let searchVC = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.SearchScreen) as? SearchProfileViewController
        searchVC?.objStoryData = self.objStoryData
        searchVC?.isFromDiscover = true
        self.pushVC(searchVC!)
    }
    @IBAction func actionAddPhoto(_ sender: Any) {
//        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.AddTextScreen) as? AddTextViewController
//        controller!.modalTransitionStyle = .crossDissolve
//        controller!.modalPresentationStyle = .overCurrentContext
//        controller!.delegate = self
//        self.presentVC(controller!)
//        let preViewVC = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.PreviewViewScreen) as? PreviewViewController
        let preViewVC = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.CameraViewScreen) as? ViewController
        self.pushVC(preViewVC!)
    }
}

extension DiscoverViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objStoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.StoryCollView {
            let cell : StoryCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.StoryCollectionCell, for: indexPath) as! StoryCollectionCell
            let data = self.objStoryData[indexPath.row]
            cell.userImage.setImage(data.userImage, for: .normal)
            cell.userName.text = data.userName
            return cell
        } else {
            let cell : DiscoverCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.DiscoverCollectionCell, for: indexPath) as! DiscoverCollectionCell
            let data = self.objStoryData[indexPath.row]
            cell.userImgView.image = data.userImage
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.StoryContentScreen) as? ContentViewController
        controller!.modalTransitionStyle = .crossDissolve
        controller!.modalPresentationStyle = .overCurrentContext
        controller?.isFromMatchVC = false
        controller?.pages = self.arrayDetails
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

