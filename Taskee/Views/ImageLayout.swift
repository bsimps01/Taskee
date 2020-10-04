//
//  ImageLayout.swift
//  Taskee
//
//  Created by Benjamin Simpson on 9/30/20.
//

import Foundation
import UIKit

class ImageLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        guard let cv = collectionView else { return }
        self.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.sectionInsetReference = .fromSafeArea
        let setWidth = cv.bounds.inset(by: cv.layoutMargins).size.width
        let minColumnWidth = CGFloat(15)
        let maxNumColumns = Int(setWidth/minColumnWidth)
        let cellWidth = (setWidth / CGFloat(maxNumColumns)).rounded(.down)
        self.itemSize = CGSize(width: cellWidth, height: 15)
    }
    
}
