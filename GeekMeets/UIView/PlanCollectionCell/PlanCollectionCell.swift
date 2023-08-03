//
//  PlanCollectionCell.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 18/09/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class PlanCollectionCell: UICollectionViewCell {

    @IBOutlet weak var lblPlanCount: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var lblduration: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnPopular: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
