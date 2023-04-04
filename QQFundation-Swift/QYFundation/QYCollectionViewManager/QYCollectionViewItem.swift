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
    var selcetCellHandler:((QYCollectionViewItem,NSInteger) -> ())?
    
    /// 每个item的大小
    var itemSize:CGSize?
    
    
    /// 刷新某个cell
    /// - Returns: 无
    func reloadCell() -> Void {
        UIView.performWithoutAnimation {
            colViewManager!.collectionView?.reloadItems(at: [self.indexPath])
        };
        
    }
    
    /// 移除某个cell
    /// - Returns: 无
    func deleteCell() -> Void {
        guard let tm = colViewManager else { return  }
        guard let sec = section else { return  }

        let row = self.indexPath.row;
        sec.removeItemAtIndex(row);
        tm.collectionView?.deleteItems(at: [self.indexPath])
    }

    var indexPath :IndexPath{
         get{
             let index = self.section?.items.firstIndex(of: self)
             return IndexPath.init(row:index!, section: self.section!.index);
         }
     };
}
