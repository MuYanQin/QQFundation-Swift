//
//  QYCollectionViewSection.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/30.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYCollectionViewSection: NSObject {
    
    /// section的item数组
    var items = Array<QYCollectionViewItem>()
    
    /// section添加Item方法
    func addItem(_ item:QYCollectionViewItem) -> Void {
        self.items.append(item)
    }
    
    /// 设置 sectionHeader、sectionFooter 的数据item  设置数据即可显示view  同时需要设置item中宽高
    var item:QYCollectionReusableItem?
    
    
    /// section内容的padding
    var sectionInset:UIEdgeInsets?
    
}
