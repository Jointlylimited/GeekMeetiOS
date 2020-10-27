//
//  CategoryListView.swift
//  SuccessDance
//
//  Created by SOTSYS044 on 16/05/19.
//  Copyright © 2019 SOTSYS203. All rights reserved.
//

import UIKit
import CoreLocation

public class CardView: UIView {
    
    typealias CloseClickEvent = () -> Void
    var clickOnClose : CloseClickEvent!
    
    typealias FavouriteClickEvent = () -> Void
    var clickOnFavourite : FavouriteClickEvent!
    
    typealias ViewClickEvent = () -> Void
    var clickOnView : ViewClickEvent!
    
    @IBOutlet weak var preferenceCollView: UICollectionView!
       
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var actionView: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var lblView: GradientLabel!
    @IBOutlet weak var imgCollView: UICollectionView!
    @IBOutlet weak var subImgCollView: UICollectionView!
    @IBOutlet weak var pageControl: CustomImagePageControl!
    @IBOutlet weak var lblNameAge: UILabel!
    @IBOutlet weak var lblLiveIn: UILabel!
    @IBOutlet weak var collViewHeightCons: NSLayoutConstraint!
    
    var objStoryData : [UIImage] = [#imageLiteral(resourceName: "image_1"),#imageLiteral(resourceName: "image_1"),#imageLiteral(resourceName: "image_1")]
    var objCard = CardDetailsModel()
    var preferenceDetailsArray : [PreferenceAnswer] = []
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(index : Int){
        self.imgCollView.register(UINib.init(nibName: Cells.DiscoverCollectionCell, bundle: Bundle.main), forCellWithReuseIdentifier: Cells.DiscoverCollectionCell)
        self.imgCollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let layout = CustomImageLayout()
        layout.scrollDirection = .vertical
        self.imgCollView.collectionViewLayout = layout
        
        let angle = CGFloat.pi/2
        pageControl.transform = CGAffineTransform(rotationAngle: angle)
        self.pageControl.currentPage = index
        
        self.subImgCollView.register(UINib.init(nibName: Cells.DiscoverCollectionCell, bundle: Bundle.main), forCellWithReuseIdentifier: Cells.DiscoverCollectionCell)
        self.subImgCollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let layout1 = CustomImageLayout()
        layout1.scrollDirection = .vertical
        self.subImgCollView.collectionViewLayout = layout1
        
        self.actionView.roundCorners([.bottomLeft, .bottomRight], radius: 10)
        self.RegisterCellView()
    }
    
    func RegisterCellView(){
        self.preferenceCollView.register(UINib.init(nibName: Cells.PreferenceListCell, bundle: Bundle.main), forCellWithReuseIdentifier: Cells.PreferenceListCell)
        self.preferenceCollView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        let layout = CustomImageLayout()
        layout.scrollDirection = .vertical
        self.preferenceCollView.collectionViewLayout = layout
        
        self.preferenceCollView.reloadData()
    }
    
    func reloadView(){
        self.subImgCollView.reloadData()
        self.preferenceCollView.reloadData()
        self.layoutIfNeeded()
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let view = touches.first?.view, view is CardView {
            self.removeFromSuperview()
        }
    }
    
    class func initCoachingAlertView(obj : SearchUserFields,  location : CLLocation) -> CardView {
        let view = Bundle.main.loadNibNamed("CardView", owner: nil, options: nil)?.first as! CardView
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
//        view.imgView.layer.cornerRadius = 5
//        view.imgView.layer.masksToBounds = true
        
        view.imgView.roundCorners([.topLeft, .topRight], radius: 5)
//        view.imgView2.image = #imageLiteral(resourceName: "img_loginbg")
        view.lblNameAge.text = "\(obj.vName != nil ? obj.vName! : ""), \(obj.tiAge != nil ? obj.tiAge! : 0)"
        view.lblLiveIn.text = obj.vLiveIn == "" ? "Ahmedabad" : obj.vLiveIn
        let text = distanceinMeter(obj : obj,  location : location)
        view.lblView.text = text
        let url = URL(string: obj.vProfileImage!)
        view.imgView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "placeholder_rect"))
        view.pageControl.numberOfPages = obj.photos?.count ?? 0        
        
        view.layoutIfNeeded()
        return view
    }
    
    class func distanceinMeter(obj : SearchUserFields, location : CLLocation) -> String {
        if obj.fLatitude != nil && obj.fLongitude != nil && obj.fLatitude != "" && obj.fLongitude != "" {
            let userLocation = CLLocation(latitude: CLLocationDegrees(exactly: Float(obj.fLatitude!)!)!, longitude: CLLocationDegrees(exactly: Float(obj.fLongitude!)!)!)
            let distanceInMeters = location.distance(from: userLocation)
            var dis : String = ""
            if(distanceInMeters <= 1609)
            {
                let s =   String(format: "%.2f", distanceInMeters)
                dis = s + " mi "
            }
            else
            {
                let s =   String(format: "%.2f", distanceInMeters)
                dis = s + " mi "
            }
            return " \(dis) "
        } else {
            return " 2 mi "
        }
    }
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.clickOnClose!()
    }
    
    @IBAction func btnFavouriteAction(_ sender: UIButton) {
        self.clickOnFavourite!()
    }
    
    @IBAction func btnViewAction(_ sender: UIButton) {
        self.clickOnView!()
    }
}
