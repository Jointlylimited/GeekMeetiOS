//
//  HomeViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 20/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreLocation

protocol HomeProtocol: class {
    func getUserCardResponse(response : SearchUsers)
    func getSwipeCardResponse(response : SwipeUser)
}

struct CardDetailsModel {
    var arrUserCardList:[SearchUserFields]!
    var objUserCard:SearchUserFields!
    
}
class HomeViewController: UIViewController, HomeProtocol {
    //var interactor : HomeInteractorProtocol?
    var presenter : HomePresentationProtocol?
    
    @IBOutlet weak var cards: SwipeableCards!
    
    var cardsData = [Int]()
    var objStoryData : [UIImage] = [#imageLiteral(resourceName: "image_1"),#imageLiteral(resourceName: "Image 65"),#imageLiteral(resourceName: "Image 63")]
    var cardView = CardView()
    var objCardArray = CardDetailsModel()
    var location:CLLocation?
    
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
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        
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
//        getUserCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserCurrentLocation()
    }
    
    func setCards() {
        makeCardsData()
        cards.dataSource = self
        cards.delegate = self
    }
    
    func makeCardsData() {
        
//        cardView = CardView.initCoachingAlertView()
//        cardView.frame = CGRect(x: 20, y: 0, w: ScreenSize.width - 40, h: ScreenSize.height - 100)
//        cardView.setData(index: 0)
//        cardView.imgCollView.dataSource = self
//        cardView.imgCollView.delegate = self
        
        for i in 0..<self.objCardArray.arrUserCardList.count {
            cardsData.append(i)
        }
        if self.objCardArray.arrUserCardList.count != 0 {
            self.objCardArray.objUserCard = self.objCardArray.arrUserCardList[0]
        }
        cards.reloadData()
    }
    
    func getUserCurrentLocation() {
        LocationManager.sharedInstance.getLocation { (currLocation, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                self.showAccessPopup(title: kLocationAccessTitle, msg: kLocationAccessMsg)
                return
            }
            guard let _ = currLocation else {
                return
            }
            if error == nil {
                self.location = currLocation
                self.presenter?.callUserCardAPI()
            }
        }
    }
}

extension HomeViewController {
    func getUserCardResponse(response : SearchUsers) {
        if response.responseCode == 200 {
            self.objCardArray.arrUserCardList = response.responseData
            setCards()
        }
    }
    
    func callSwipeCardAPI(iProfileId : String, tiSwipeType : String){
        self.presenter?.callSwipeCardAPI(iProfileId: iProfileId, tiSwipeType: tiSwipeType)
    }
    
    func getSwipeCardResponse(response : SwipeUser){
        if response.responseCode == 200 {
            if response.responseData?.tiSwipeType == 2 {
                let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.MatchScreen) as! MatchViewController
                controller.isFromProfile = false
                let data = response.responseData
                controller.CardUserDetails = SearchUserFields(iUserId: data?.iUserId, vName: data?.vUserName, vProfileImage: data?.vProfileImage, tiAge: 0, vLiveIn: "", fLatitude: "", fLongitude: "", storyTime: "", photos: [])
                controller.modalTransitionStyle = .crossDissolve
                controller.modalPresentationStyle = .overCurrentContext
                self.presentVC(controller)
            } else {
//                self.presenter?.callUserCardAPI()
                if self.objCardArray.arrUserCardList.count != 0 {
                    self.objCardArray.arrUserCardList.remove(at: 0)
                    self.cardsData = []
                    self.makeCardsData()
                }
            }
        }
    }
}
extension HomeViewController : SwipeableCardsDataSource, SwipeableCardsDelegate {
    // SwipeableCardsDataSource methods
    func numberOfTotalCards(in cards: SwipeableCards) -> Int {
        return cardsData.count
    }
    func view(for cards: SwipeableCards, index: Int, reusingView: CardView?) -> CardView {

        cardView = CardView.initCoachingAlertView(obj : self.objCardArray.objUserCard, location : self.location!)
        cardView.frame = CGRect(x: 20, y: DeviceType.hasNotch ? 120 : 50, w: ScreenSize.width - 40, h: ScreenSize.height - (DeviceType.hasNotch ? 220 : 150))
        cardView.setData(index: 0)
        cardView.pageControl.numberOfPages = (self.objCardArray.objUserCard.photos == nil && self.objCardArray.objUserCard.photos?.count == 0) ? 1 : self.objCardArray.objUserCard.photos!.count
        cardView.imgCollView.dataSource = self
        cardView.imgCollView.delegate = self
        cardView.imgCollView.reloadData()
        
        cardView.clickOnClose = {
            print("Close Action clicked!")
            self.callSwipeCardAPI(iProfileId: "\(self.objCardArray.objUserCard.iUserId!)", tiSwipeType: "0")
        }
        
        cardView.clickOnFavourite = {
            print("Favourite Action clicked!")
             self.callSwipeCardAPI(iProfileId: "\(self.objCardArray.objUserCard.iUserId!)", tiSwipeType: "1")
        }
        
        cardView.clickOnView = {
            print("View Action clicked!")
            let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.MatchProfileScreen) as! MatchProfileViewController
            controller.UserID = self.objCardArray.objUserCard.iUserId
            controller.modalTransitionStyle = .crossDissolve
            controller.modalPresentationStyle = .overCurrentContext
            self.presentVC(controller)
        }
        
        return cardView
    }
    
    // SwipeableCardsDelegate methods
    func cards(_ cards: SwipeableCards, beforeSwipingItemAt index: Int) {
        print("Begin swiping card \(index)!")
    }
    func cards(_ cards: SwipeableCards, didLeftRemovedItemAt index: Int) {
        print("<--\(index)")
         self.callSwipeCardAPI(iProfileId: "\(self.objCardArray.objUserCard.iUserId!)", tiSwipeType: "0")
    }
    func cards(_ cards: SwipeableCards, didRightRemovedItemAt index: Int) {
        print("\(index)-->")
         self.callSwipeCardAPI(iProfileId: "\(self.objCardArray.objUserCard.iUserId!)", tiSwipeType: "1")
    }
    func cards(_ cards: SwipeableCards, didRemovedItemAt index: Int) {
        print("index of removed card:\(index)")
    }
}

extension HomeViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.objCardArray.objUserCard.photos == nil && self.objCardArray.objUserCard.photos?.count == 0) ? 1 : self.objCardArray.objUserCard.photos!.count // self.objStoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : DiscoverCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.DiscoverCollectionCell, for: indexPath) as! DiscoverCollectionCell
        if self.objCardArray.objUserCard.photos == nil && self.objCardArray.objUserCard.photos?.count == 0 {
            let url = URL(string: self.objCardArray.objUserCard.vProfileImage!)
            cell.userImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_rect"))
        } else {
            let data = self.objCardArray.objUserCard.photos![indexPath.row]
            let url = URL(string: data.vMedia!)
            cell.userImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_rect"))
        }
        cell.userImgView.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Parallax visible cells
        let center = CGPoint(x: (scrollView.frame.width / 2), y: scrollView.contentOffset.y + (scrollView.frame.width / 2))
        if let ip = cardView.imgCollView.indexPathForItem(at: center) {
            cardView.pageControl.currentPage = ip.row
        }
    }
}
