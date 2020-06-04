//
//  CategoryListView.swift
//  SuccessDance
//
//  Created by SOTSYS044 on 16/05/19.
//  Copyright © 2019 SOTSYS203. All rights reserved.
//

import UIKit

public class CardView: UIView {
    
    typealias CloseClickEvent = () -> Void
    var clickOnClose : CloseClickEvent!
    
    typealias FavouriteClickEvent = () -> Void
    var clickOnFavourite : FavouriteClickEvent!
    
    typealias ViewClickEvent = () -> Void
    var clickOnView : ViewClickEvent!
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var btnView: UIButton!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblView: GradientLabel!
    @IBOutlet weak var imgCollView: UICollectionView!
    @IBOutlet weak var pageControl: CustomImagePageControl!
    
    var objStoryData : [UIImage] = [#imageLiteral(resourceName: "image_1"),#imageLiteral(resourceName: "Image 65"),#imageLiteral(resourceName: "Image 63")]
    override public func awakeFromNib() {
        super.awakeFromNib()
//        setData()
    }
    
    func setData(index : Int){
        
        self.imgCollView.register(UINib.init(nibName: Cells.DiscoverCollectionCell, bundle: Bundle.main), forCellWithReuseIdentifier: Cells.DiscoverCollectionCell)
        self.imgCollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let layout = CustomImageLayout()
        layout.scrollDirection = .vertical
        self.imgCollView.collectionViewLayout = layout
        
        let angle = CGFloat.pi/2
        pageControl.transform = CGAffineTransform(rotationAngle: angle)
        self.pageControl.numberOfPages = self.objStoryData.count
        self.pageControl.currentPage = index
        self.imgCollView.reloadData()
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let view = touches.first?.view, view is CardView {
            self.removeFromSuperview()
        }
    }
    
    class func initCoachingAlertView() -> CardView {
        let view = Bundle.main.loadNibNamed("CardView", owner: nil, options: nil)?.first as! CardView
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
//        view.dropShadowinView(view: view)
        view.imgView.layer.cornerRadius = 5
        view.imgView.layer.masksToBounds = true
        
        view.layoutIfNeeded()
        return view
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
