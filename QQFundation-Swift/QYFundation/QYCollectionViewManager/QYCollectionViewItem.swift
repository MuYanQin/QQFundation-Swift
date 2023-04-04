//
//  QYCollectionViewItem.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/30.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYCollectionViewItem: NSObject {
    
    var colViewManager :QYCollectionViewManager?

    var section : QYCollectionViewSection?

    /// 获取item的点击回调闭包
    var selcetCellHandler:((QYCollectionViewItem,NSInteger) -> ())?
    
    /// 每个item的大小
    var itemSize:CGSize?
    
    func reloadRowWithAnimation() -> Void {
        UIView.performWithoutAnimation {
            colViewManager!.collectionView?.reloadItems(at: <#T##[IndexPath]#>)
        };
        
    }
    
    var indexPath :IndexPath?{
         get{
           let index = self.section.items?.firstIndex(where: { item -> Bool in
                return item == self;
            });
            return IndexPath.init(row:index!, section: self.section.index!);
         }
     };
}
