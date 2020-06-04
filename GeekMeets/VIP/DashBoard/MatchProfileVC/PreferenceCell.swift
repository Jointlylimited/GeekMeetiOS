//
//  PreferenceCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 03/06/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class PreferenceCell: UITableViewCell {

    @IBOutlet weak var preferenceCollView: UICollectionView!
    var objStoryData = [["name" : "Sports", "image" : #imageLiteral(resourceName: "gym"),],["name" : "Asian", "image" : #imageLiteral(resourceName: "zodiac_sign")], ["name" : "Hindu", "image" : #imageLiteral(resourceName: "bank")], ["name" : "Night", "image" : #imageLiteral(resourceName: "pet")] , ["name" : "Morning", "image" : #imageLiteral(resourceName: "voter")], ["name" : "I love both", "image" : #imageLiteral(resourceName: "bank")], ["name" : "Sports", "image" : #imageLiteral(resourceName: "gym"),],["name" : "Asian", "image" : #imageLiteral(resourceName: "zodiac_sign")], ["name" : "Hindu", "image" : #imageLiteral(resourceName: "bank")]]
    override func awakeFromNib() {
        super.awakeFromNib()
        RegisterCellView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func RegisterCellView(){
        self.preferenceCollView.register(UINib.init(nibName: Cells.PreferenceListCell, bundle: Bundle.main), forCellWithReuseIdentifier: Cells.PreferenceListCell)
        self.preferenceCollView.dataSource = self
        self.preferenceCollView.delegate = self
        self.preferenceCollView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        let layout = CustomImageLayout()
        layout.scrollDirection = .vertical
        self.preferenceCollView.collectionViewLayout = layout
        
        self.preferenceCollView.reloadData()
    }
}

extension PreferenceCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objStoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PreferenceListCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.PreferenceListCell, for: indexPath) as! PreferenceListCell
        let data = self.objStoryData[indexPath.row]
        cell.btnTitle.setTitle(data["name"] as! String, for: .normal)
        cell.btnTitle.setImage(data["image"] as! UIImage, for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let name = self.objStoryData[indexPath.row]["name"]
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight = CGFloat(40)
        let size = (name as! NSString).size(withAttributes: [
            NSAttributedString.Key.font : UIFont(name: FontTypePoppins.Poppins_Medium.rawValue, size: FontSizePoppins.sizeNormalTextField.rawValue)!
        ])

        return CGSize(width: size.width + 50, height: yourHeight)

    }
}
