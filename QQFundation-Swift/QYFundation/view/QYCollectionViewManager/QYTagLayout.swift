//
//  QYTagLayout.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/4/4.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

/// 标签流水布局
class QYTagLayout: UICollectionViewFlowLayout {
    var preFrame :CGRect?

    /// 获取所有的布局信息
    /// - Parameter rect: rect description
    /// - Returns: 布局信息
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //获取所有的布局信息 包括cell header footer
        guard let origArray = super.layoutAttributesForElements(in: rect) else { return []}
        var updateArray = Array(origArray)
        for attributes in origArray as [UICollectionViewLayoutAttributes]{
            //空的话 就是cell 需要重新布局位置信息。但是header footer不需要
            // nil when representedElementCategory is UICollectionElementCategoryCell
            if attributes.representedElementKind == nil{
                let index = updateArray.firstIndex(of: attributes) ?? 0
                updateArray[index] = layoutAttributesForItem(at: attributes.indexPath)!
            }
        }
        return updateArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        //获取到一个布局信息
        let currentAttributes = super.layoutAttributesForItem(at: indexPath)
        let sectionInset = self.sectionInset

        
        let isFirstItemInSection = indexPath.item == 0
        //获取展示的宽度
        let layoutWidth = collectionView!.frame.width - sectionInset.left - sectionInset.right
        if isFirstItemInSection {
            //如果是第一个 从 sectionInset.left 开始做坐标
            currentAttributes!.leftAlignFrame(with: sectionInset)
            self.preFrame = currentAttributes?.frame
            return  currentAttributes
        }
        //获取前一个item的indexpath
        let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
        var previousFrame  = CGRect.zero
        if self.preFrame != nil {
            previousFrame = self.preFrame!
        }else{
            previousFrame = layoutAttributesForItem(at: previousIndexPath)?.frame ?? CGRect.zero
        }
        let currentFrame = currentAttributes!.frame
        let previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width
        let strecthedCurrentFrame = CGRect(x: sectionInset.left, y: currentFrame.origin.y, width: layoutWidth, height: currentFrame.size.height)

        // previousFrame和strecthedCurrentFrame不相交证明不在一行
        let isFirstItemInRow = !previousFrame.intersects(strecthedCurrentFrame)
        if isFirstItemInRow {
            currentAttributes!.leftAlignFrame(with: sectionInset)
            self.preFrame  = nil
            return  currentAttributes
        }

        var frame = currentAttributes!.frame
        frame.origin.x = previousFrameRightPoint + self.minimumInteritemSpacing
        currentAttributes!.frame = frame
        self.preFrame = frame
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

