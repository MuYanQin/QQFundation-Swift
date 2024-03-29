//
//  QYCollectionViewItem.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/30.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYCollectionViewItem: NSObject {
    
    /// 获取管理者
    var colViewManager :QYCollectionViewManager?
    
    /// 属于哪个section
    var section : QYCollectionViewSection?

    /// 获取item的点击回调闭包
    var selectCellHandler:((QYCollectionViewItem,NSInteger) -> ())?
    
    /// 每个item的大小 当宽度不定时  宽度设置为0 cell中重写autoCellWidth 返回 width即可 多做流式标签布局使用
    var itemSize:CGSize?
    
    var indexPath :IndexPath{
         get{
             let index = self.section?.items.firstIndex(of: self)
             return IndexPath.init(row:index!, section: self.section!.index);
         }
     };
    
    //MARK: - 操作cell视图
    /// 刷新某个cell
    /// - Returns: 无
    func reloadCell() -> Void {

        UIView.performWithoutAnimation {
            colViewManager?.collectionView?.performBatchUpdates({
                colViewManager?.collectionView?.reloadItems(at: [self.indexPath])
            })
        }

    }
    
    /// 刷新多个cell
    /// - Parameter items: item数组
    /// - Returns: 无
    func reloadCell(_ items:[QYCollectionViewItem]) -> Void {
        var array = Array<IndexPath>()
        for item in items {
            array.append(item.indexPath)
        }

        UIView.performWithoutAnimation {
            colViewManager?.collectionView?.performBatchUpdates({
                colViewManager?.collectionView?.reloadItems(at: array)
            })
        }
    }
    
    /// 移除当前cell
    /// - Returns: 无
    func deleteCell() -> Void {
        guard let tm = colViewManager else { return  }
        guard let sec = section else { return  }

        let row = self.indexPath.row;
        sec.removeItemAtIndex(row);
        tm.collectionView?.performBatchUpdates({
            tm.collectionView?.deleteItems(at: [IndexPath.init(row:row, section: self.section!.index)])
        })
    }
    
    /// 移动到第几个
    /// - Parameter index: 下标
    /// - Returns: 无
    func moveTo(_ index:Int) -> Void {
        guard let sec = section else { return  }
        sec.moveTo(self.indexPath.row, index)
        sec.reloadSection()
    }

    
    ///交换到第几个
    /// - Parameter to: 要交换的下标
    /// - Returns: 无
    func swarpTo(_ to:Int) -> Void{
        guard let tm = colViewManager else { return  }
        guard let sec = section else { return  }
        sec.swapAt(self.indexPath.row, to)
        tm.collectionView?.performBatchUpdates({
            tm.collectionView?.moveItem(at: self.indexPath, to: IndexPath(row: to, section: sec.index))
        })
    }

}
