//
//  ProfilePhotosCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 20/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class ProfilePhotosCell: UITableViewCell {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

//    func configureCell(){
//        self.photoCollectionView.register(PhotoEmojiCell.self, forCellWithReuseIdentifier: Cells.PhotoEmojiCell)
//    }
}


