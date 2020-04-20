//
//  CategoryListView.swift
//  SuccessDance
//
//  Created by SOTSYS044 on 16/05/19.
//  Copyright © 2019 SOTSYS203. All rights reserved.
//

import UIKit

//protocol CardListDelegate: NSObjectProtocol {
//    func complitionDelegate(with obj: Any?)
//}
//

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
    @IBOutlet weak var lblView: UILabel!
    
    /// Variables
//    weak var delegate: CardListDelegate?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let view = touches.first?.view, view is CardView {
            self.removeFromSuperview()
        }
    }
  
  class func initCoachingAlertView() -> CardView {
    let view = Bundle.main.loadNibNamed("CardView", owner: nil, options: nil)?.first as! CardView
    
    view.imgView.layer.cornerRadius = 10
    view.imgView.layer.masksToBounds = true
    view.lblView.applyGradient(colors: AppCommonColor.gredientColor)
    
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
