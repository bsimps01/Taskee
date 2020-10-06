//
//  ImageLayout.swift
//  Taskee
//
//  Created by Benjamin Simpson on 9/30/20.
//

import Foundation
import UIKit

class ColorLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        guard let cv = collectionView else { return }
        self.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        self.sectionInsetReference = .fromSafeArea
        let setWidth = cv.bounds.inset(by: cv.layoutMargins).size.width
        let minColumnWidth = CGFloat(75)
        let maxNumColumns = Int(setWidth/minColumnWidth)
        let cellWidth = (setWidth / CGFloat(maxNumColumns)).rounded(.down)
        self.itemSize = CGSize(width: cellWidth, height: 75)
    }
    
}
