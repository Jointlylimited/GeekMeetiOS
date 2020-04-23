//
//  CustomImageLayout.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 22/04/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit
import SwiftUI

class CustomImageLayout: UICollectionViewFlowLayout {
    
    var numberOfColumns:CGFloat = 3.0
    var scrollViewDirection : UICollectionView.ScrollDirection = .vertical
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    override var itemSize: CGSize {
        set { }
        get {
            let itemWidth = (self.collectionView!.frame.width - (self.numberOfColumns - 1)) / self.numberOfColumns
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 1 // Set to zero if you want
        minimumLineSpacing = 1
        scrollDirection = scrollViewDirection
    }
}

@available(iOS 13.0, *)
struct MultipleLineTextField: View {
    var content: Binding<String>

    init(content: Binding<String>) {
        self.content = content
    }

    var body: some View {
        TextField("Custom placeholder", text: content)
            .background(Color.yellow)
    }
}
