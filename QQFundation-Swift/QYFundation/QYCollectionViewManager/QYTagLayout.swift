//
//  QYTagLayout.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/4/4.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYTagLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let origArray = super.layoutAttributesForElements(in: rect) else { return []}
        var updateArray = Array(origArray)
        for attributes in origArray as [UICollectionViewLayoutAttributes]{
            if attributes.representedElementKind == nil{
                let index = updateArray.firstIndex(of: attributes) ?? 0
                updateArray[index] = layoutAttributesForItem(at: attributes.indexPath)!
            }
        }
        return updateArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let currentAttributes = super.layoutAttributesForItem(at: indexPath)
        let sectionInset = self.sectionInset

        
        let isFirstItemInSection = indexPath.item == 0
        let layoutWidth = collectionView!.frame.width - sectionInset.left - sectionInset.right
        if isFirstItemInSection {
            currentAttributes!.leftAlignFrame(with: sectionInset)
            return  currentAttributes
        }
        let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
        let previousFrame = layoutAttributesForItem(at: previousIndexPath)?.frame ?? CGRect.zero
        let currentFrame = currentAttributes!.frame
        let previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width
        let strecthedCurrentFrame = CGRect(x: sectionInset.left, y: currentFrame.origin.y, width: layoutWidth, height: currentFrame.size.height)

        // previousFrame和strecthedCurrentFrame不相交证明不在一行
        let isFirstItemInRow = !previousFrame.intersects(strecthedCurrentFrame)
        if isFirstItemInRow {
            currentAttributes!.leftAlignFrame(with: sectionInset)
            return  currentAttributes
        }

        var frame = currentAttributes!.frame
        frame.origin.x = previousFrameRightPoint + self.minimumInteritemSpacing
        currentAttributes!.frame = frame
        return  currentAttributes
    }
}
private extension UICollectionViewLayoutAttributes {
        func leftAlignFrame(with sectionInset: UIEdgeInsets) {
            var frame = self.frame
            frame.origin.x = sectionInset.left
            self.frame = frame
        }
}

