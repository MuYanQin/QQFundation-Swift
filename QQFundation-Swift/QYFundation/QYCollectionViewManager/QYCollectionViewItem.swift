//
//  QYCollectionViewItem.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/30.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYCollectionViewItem: NSObject {
    
    /// 获取item的点击回调闭包
    var selcetCellHandler:((QYCollectionViewItem,NSInteger) -> ())?
    
    /// 每个item的大小
    var itemSize:CGSize?
}
