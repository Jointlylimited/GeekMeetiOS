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
    
    var preferenceDetailsArray : [PreferenceAnswer] = []
    
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
        return self.preferenceDetailsArray.count != 0 ? self.preferenceDetailsArray.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PreferenceListCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.PreferenceListCell, for: indexPath) as! PreferenceListCell
        let data = self.preferenceDetailsArray[indexPath.row]
        cell.btnTitle.setTitle(data.iPreferenceId == 5 ? data.fAnswer : data.vOption, for: .normal)
        let type = PreferenceIconsDict.filter({($0["type"]!) as! String == "\(data.iPreferenceId!)"})  //map{($0["type"]!)}.first! as! String
        print(type)
        if type.count != 0 {
            cell.btnTitle.setImage(type[0]["icon"]! as? UIImage, for: .normal)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let name = self.preferenceDetailsArray[indexPath.row].iPreferenceId == 5 ? self.preferenceDetailsArray[indexPath.row].fAnswer : self.preferenceDetailsArray[indexPath.row].vOption
        let yourHeight = CGFloat(40)
        let size = (name! as NSString).size(withAttributes: [
            NSAttributedString.Key.font : UIFont(name: FontTypePoppins.Poppins_Medium.rawValue, size: FontSizePoppins.sizeNormalTextField.rawValue)!
        ])

        return CGSize(width: size.width + 35, height: yourHeight)

    }
}
