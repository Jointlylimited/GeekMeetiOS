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
    func getLocationUpdateResponse(response : UserAuthResponse)
    func getMatchResponse(response : MatchUser)
}

struct CardDetailsModel {
    var arrUserCardList:[SearchUserFields]!
    var objUserCard:SearchUserFields!
    
}
class HomeViewController: UIViewController, HomeProtocol {
    //var interactor : HomeInteractorProtocol?
    var presenter : HomePresentationProtocol?
    
    @IBOutlet weak var cards: SwipeableCards!
    @IBOutlet weak var imgPlaceHolder: UIImageView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var btnMatch: SSBadgeButton!
    @IBOutlet weak var btnActivateSpotlight: GradientButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnActivateTopConstraint: NSLayoutConstraint!
    
    var cardsData = [SearchUserFields]()
    var objCard : SearchUserFields!
    var objStoryData : [UIImage] = [#imageLiteral(resourceName: "image_1"),#imageLiteral(resourceName: "image_1"),#imageLiteral(resourceName: "image_1")]
    var cardView = CardView()
    var objCardArray = CardDetailsModel()
    var location:CLLocation?
    var SwipeValue : Int = 0
    var i : Int = 0
    
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
        SwipeValue = Authentication.getSwipeStatus()!
        self.lblTitle.font = UIFont(name: FontTypePoppins.Poppins_Medium.rawValue, size: DeviceType.iPhone5orSE ? 12.0 : 16.0)
        self.btnActivateTopConstraint.constant = DeviceType.iPhone5orSE ? 15 : 30
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDataModel.currentUser != nil {
            if UserDataModel.currentUser?.tiIsLocationOn == 0 {
                self.getUserCurrentLocation()
            } else {
                self.location = CLLocation(latitude: CLLocationDegrees(exactly: Double(UserDataModel.currentUser!.fLatitude == "" ? "0.0" : UserDataModel.currentUser!.fLatitude!)!)!, longitude: CLLocationDegrees(exactly: Double(UserDataModel.currentUser!.fLongitude == "" ? "0.0" : UserDataModel.currentUser!.fLongitude!)!)!)
                self.presenter?.callMatchListAPI()
            }
        }else {
            self.getUserCurrentLocation()
        }
    }
    
    func setCards() {
        makeCardsData()
        cards.dataSource = self
        cards.delegate = self
        
    }
    
    func makeCardsData() {
        for i in self.objCardArray.arrUserCardList {
            cardsData.append(i)
        }
        if self.objCardArray.arrUserCardList.count != 0 {
            self.objCardArray.objUserCard = self.objCardArray.arrUserCardList[0]
        }
        cards.reloadData()
        
//        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(presentProfileVC))
//        doubleTapGesture.numberOfTapsRequired = 2
//        cards.addGestureRecognizer(doubleTapGesture)
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
                if UserDataModel.currentUser != nil {
                    if UserDataModel.currentUser?.tiIsLocationOn == 0 {
                        self.callUpdateLocationAPI(fLatitude: String(Float((currLocation?.coordinate.latitude)!)), fLongitude: String(Float((currLocation?.coordinate.longitude)!)), tiIsLocationOn : "1")
                    }
                } else {
                    self.callUpdateLocationAPI(fLatitude: String(Float((currLocation?.coordinate.latitude)!)), fLongitude: String(Float((currLocation?.coordinate.longitude)!)), tiIsLocationOn : "1")
                }
                self.presenter?.callUserCardAPI()
            }
        }
    }
    
    func presentSubVC(){
        if i == 0 {
            self.i = 1
            self.btnActivateSpotlight.setTitle("Activate Boost", for: .normal)
            let subVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.ManageSubscriptionScreen) as! ManageSubscriptionViewController
            subVC.modalTransitionStyle = .crossDissolve
            subVC.modalPresentationStyle = .overCurrentContext
            self.presentVC(subVC)
        } else if i == 1 {
            self.i = 2
            self.btnActivateSpotlight.setTitle("Activate Top Story", for: .normal)
            presentBoostVC()
        } else {
            self.i = 0
            self.btnActivateSpotlight.setTitle("Activate Subscription", for: .normal)
            presentTopStoryVC()
        }
    }
    
    func presentBoostVC(){
        let boostVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.BoostScreen) as! BoostViewController
        boostVC.modalTransitionStyle = .crossDissolve
        boostVC.modalPresentationStyle = .overCurrentContext
        self.presentVC(boostVC)
    }
    
    func presentTopStoryVC(){
        let topGeeksVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.TopGeeksScreen) as! TopGeeksViewController
        topGeeksVC.modalTransitionStyle = .crossDissolve
        topGeeksVC.modalPresentationStyle = .overCurrentContext
        self.presentVC(topGeeksVC)
    }
    
    func pushMatchVC(){
        let matchVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.MatchLikeScreen)
        self.pushVC(matchVC)
    }
    
    func presentSubscriptionView(){
        cards.alpha = 0.0
        self.subView.alpha = 1.0
        self.imgPlaceHolder.alpha = 1.0
        self.imgPlaceHolder.image = #imageLiteral(resourceName: "u_sub")
    }
    
    func hideSubscriptionView(){
        cards.alpha = 1.0
        self.subView.alpha = 0.0
        self.imgPlaceHolder.alpha = 0.0
    }
    
    @objc func presentProfileVC(){
        let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.MatchProfileScreen) as! MatchProfileViewController
        controller.UserID = self.objCardArray.objUserCard.iUserId
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .overCurrentContext
        self.presentVC(controller)
    }
    
    @IBAction func btnMatchAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            if UserDataModel.currentUser?.tiIsSubscribed == 1 {
                pushMatchVC()
            } else {
                self.presentSubscriptionView()
            }
        } else {
            hideSubscriptionView()
        }
    }
    @IBAction func btnActivateSpotlightAction(_ sender: GradientButton) {
        presentSubVC()
    }
}

//MARK: API Methods
extension HomeViewController {
    func getUserCardResponse(response : SearchUsers) {
        if response.responseCode == 200 {
            self.objCardArray.arrUserCardList = response.responseData
            if self.objCardArray.arrUserCardList.count != 0 {
                self.subView.alpha = 0.0
                self.imgPlaceHolder.alpha = 0.0
            } else {
                self.subView.alpha = 1.0
                self.imgPlaceHolder.alpha = 1.0
            }
            cards.alpha = 1.0
            setCards()
        } else {
            self.cardsData = []
            cards.reloadData()
            cards.alpha = 0.0
            AppSingleton.sharedInstance().showAlert(kNoProfile, okTitle: "OK")
            self.imgPlaceHolder.alpha = 1.0
            self.subView.alpha = 1.0
        }
//        self.presentSubscriptionView()
        
    }
    
    func callSwipeCardAPI(iProfileId : String, tiSwipeType : String){
        self.presenter?.callSwipeCardAPI(iProfileId: iProfileId, tiSwipeType: tiSwipeType)
    }
    
    func getSwipeCardResponse(response : SwipeUser){
        if response.responseCode == 200 {
            if response.responseData?.tiSwipeType == 2 {
                let controller = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.MatchScreen) as! MatchViewController
                controller.isFromProfile = false
                let data = self.objCardArray.objUserCard
                controller.CardUserDetails = SearchUserFields(iUserId: data?.iUserId, vName: data?.vName, vProfileImage: data?.vProfileImage, tiAge: data?.tiAge, vEmail: data?.vEmail, tiGender: data?.tiGender, dDob: data?.dDob, txAbout: data?.txAbout, vCountryCode: data?.vCountryCode, vPhone: data?.vPhone, txCompanyDetail: data?.txCompanyDetail, vReferralCode: data?.vReferralCode, vLiveIn: data?.vLiveIn, fLatitude: data?.fLatitude, fLongitude: data?.fLongitude, tiIsLocationOn: data?.tiIsLocationOn, storyTime: data?.storyTime, vXmppUser: data?.vXmppUser, vXmppPassword: data?.vXmppPassword, tiIsSubscribed: data?.tiIsSubscribed, photos: data?.photos, preference: data?.preference)
                
                controller.modalTransitionStyle = .crossDissolve
                controller.modalPresentationStyle = .overCurrentContext
                self.presentVC(controller)
            } else {
                if self.objCardArray.arrUserCardList.count != 0 {
                    self.objCardArray.arrUserCardList.remove(at: 0)
                    self.cardsData = []
                    self.makeCardsData()
                } else {
                    self.presenter?.callUserCardAPI()
                }
            }
        } else {
            AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle: "Ok")
            self.presentSubscriptionView()// presentSubVC()
        }
    }
    
    func callUpdateLocationAPI(fLatitude : String, fLongitude : String, tiIsLocationOn : String){
        self.presenter?.callUpdateLocationAPI(fLatitude: fLatitude, fLongitude: fLongitude, tiIsLocationOn: tiIsLocationOn)
    }
    
    func getLocationUpdateResponse(response : UserAuthResponse){
        if response.responseCode == 200 {
            UserDataModel.currentUser?.tiIsLocationOn = response.responseData?.tiIsLocationOn
            if UserDataModel.currentUser?.tiIsLocationOn == 0 {
                UserDataModel.setPushStatus(status: "1")
            } else {
                UserDataModel.setPushStatus(status: "0")
            }
        }
    }
    
    func getMatchResponse(response : MatchUser) {
        
        if response.responseData!.count != 0 {
            if response.responseData!.count - UserDataModel.getNewMatchesCount() != 0 {
                self.btnMatch.badge = response.responseData!.count > 999 ? "99+" : "\(response.responseData!.count - UserDataModel.getNewMatchesCount())"
                UserDataModel.setNewMatchesCount(count: response.responseData!.count - UserDataModel.getNewMatchesCount())
                self.btnMatch.badgeLabel.alpha = 1.0
                self.btnMatch.badgeLabel.frame = CGRect(x: self.btnMatch.width-20, y: 0, w: 20, h: 20)
            } else {
                self.btnMatch.badgeLabel.alpha = 0.0
            }
        } else {
            self.btnMatch.badgeLabel.alpha = 0.0
        }
        self.presenter?.callUserCardAPI()
    }
}

//MARK: SwipeableCard Delegate & Datasource Methods
extension HomeViewController : SwipeableCardsDataSource, SwipeableCardsDelegate {
    func numberOfTotalCards(in cards: SwipeableCards) -> Int {
        return cardsData.count
    }
    
    func view(for cards: SwipeableCards, index: Int, reusingView: CardView?) -> CardView {
        let obj = cardsData[index]
        cardView = CardView.initCoachingAlertView(obj : obj, location : self.location!)
        
        cardView.frame = CGRect(x: 20, y: DeviceType.hasNotch ? 120 : 50, w: ScreenSize.width - 40, h: ScreenSize.height - (DeviceType.hasNotch ? 220 : 150))
        cardView.setData(index: 0)
        self.subView.frame = self.cardView.bounds
        cardView.imgCollView.frame = cardView.bounds
        cardView.imgView.frame = cardView.bounds
        cardView.pageControl.numberOfPages = (obj.photos == nil && obj.photos?.count == 0) ? 0 : obj.photos!.count
        
        cardView.collViewHeightCons.constant = cardView.frame.height
        if obj.photos?.count != 0 {
            cardView.subcollViewHeightCons.constant = cardView.frame.height*CGFloat(((obj.photos == nil && obj.photos?.count == 0) ? 1 : obj.photos!.count))
        } else {
            cardView.subcollViewHeightCons.constant = 0
        }
        
        if (obj.txAbout != "" && obj.txCompanyDetail != "") && (obj.txAbout != nil && obj.txCompanyDetail != nil){
            cardView.AboutViewHeightCons.constant = 150
        } else if obj.txAbout == "" && obj.txCompanyDetail != "" {
            cardView.AboutViewHeightCons.constant = 100
        } else if obj.txAbout != "" && obj.txCompanyDetail == "" {
             cardView.AboutViewHeightCons.constant = 130
        } else {
            cardView.AboutViewHeightCons.constant = 65
        }
        
        cardView.preferenceCollView.dataSource = self
        cardView.preferenceCollView.delegate = self
        
        if obj.preference != nil && obj.preference?.count != 0 {
            cardView.preferenceDetailsArray = obj.preference!
            cardView.preferenceViewHeightCons.constant = 180
            cardView.preferenceCollView.reloadData()
        } else {
            cardView.preferenceViewHeightCons.constant = 0
        }
        
        cardView.subImgCollView.dataSource = self
        cardView.subImgCollView.delegate = self
        
//        cardView.imgCollView.dataSource = self
//        cardView.imgCollView.delegate = self
//        cardView.imgCollView.reloadData()
        cardView.subImgCollView.reloadData()
        cardView.reloadView()
        
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
    
    func cards(_ cards: SwipeableCards, didBottonSwipeItemAt index: Int) {
        if index == 0 {
//            self.presentProfileVC()
        }
    }
}

//MARK: UICollectionview Delegate & Datasource Methods
extension HomeViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == cardView.imgCollView || collectionView == cardView.subImgCollView ||  collectionView == cardView.preferenceCollView {
        return 1
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cardView.imgCollView {
            return (self.objCardArray.objUserCard.photos == nil && self.objCardArray.objUserCard.photos?.count == 0) ? 1 : self.objCardArray.objUserCard.photos!.count
        } else if collectionView == cardView.subImgCollView {
            return (self.objCardArray.objUserCard.photos != nil && self.objCardArray.objUserCard.photos!.count != 0) ? self.objCardArray.objUserCard.photos!.count : 0
        } else if collectionView == cardView.preferenceCollView {
            return cardView.preferenceDetailsArray.count != 0 ? cardView.preferenceDetailsArray.count : 0
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cardView.imgCollView {
            let cell : DiscoverCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.DiscoverCollectionCell, for: indexPath) as! DiscoverCollectionCell
            let url = URL(string: self.objCardArray.objUserCard.vProfileImage!)
            cell.userImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_rect"))
            cell.userImgView.clipsToBounds = true
            return cell
        }
        else if collectionView == cardView.subImgCollView {
            let cell : DiscoverCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.DiscoverCollectionCell, for: indexPath) as! DiscoverCollectionCell
                let photo = self.objCardArray.objUserCard.photos![indexPath.row]
                let url = URL(string: photo.vMedia!)
                cell.userImgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_rect"))
                cell.userImgView.clipsToBounds = true
            
            return cell
        } else /*if collectionView == cardView.preferenceCollView*/ {
            let cell : PreferenceListCell = cardView.preferenceCollView.dequeueReusableCell(withReuseIdentifier: Cells.PreferenceListCell, for: indexPath) as! PreferenceListCell
            if indexPath.row < cardView.preferenceDetailsArray.count {
                let data = cardView.preferenceDetailsArray[indexPath.row]
                cell.btnTitle.setTitle(data.iPreferenceId == 5 ? data.fAnswer : data.vOption, for: .normal)
                let type = PreferenceIconsDict.filter({($0["type"]!) as! String == "\(data.iPreferenceId!)"})
                print(type)
                if type.count != 0 {
                    cell.btnTitle.setImage(type[0]["icon"]! as? UIImage, for: .normal)
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         if collectionView == cardView.imgCollView  {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
         } else if collectionView == cardView.subImgCollView {
             let photos = self.objCardArray.objUserCard.photos!
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/CGFloat(photos.count))
         }
         else {
            let name = cardView.preferenceDetailsArray[indexPath.row].iPreferenceId == 5 ? cardView.preferenceDetailsArray[indexPath.row].fAnswer : cardView.preferenceDetailsArray[indexPath.row].vOption
            let yourHeight = CGFloat(40)
            let size = (name! as NSString).size(withAttributes: [
                NSAttributedString.Key.font : UIFont(name: FontTypePoppins.Poppins_Medium.rawValue, size: FontSizePoppins.sizeNormalTextField.rawValue)!
            ])

            return CGSize(width: size.width + 35, height: yourHeight)
        }
    }
}