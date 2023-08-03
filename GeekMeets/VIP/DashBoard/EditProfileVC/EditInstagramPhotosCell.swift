//
//  EditInstagramPhotosCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 09/09/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class EditInstagramPhotosCell: UITableViewCell {

    @IBOutlet weak var InstagramPhotosCell: UICollectionView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        InstagramPhotosCell.register(UINib.init(nibName: Cells.PhotoEmojiCell, bundle: Bundle.main), forCellWithReuseIdentifier: Cells.PhotoEmojiCell)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
