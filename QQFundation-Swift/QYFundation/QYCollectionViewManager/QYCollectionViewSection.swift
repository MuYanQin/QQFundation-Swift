//
//  QYCollectionViewSection.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/30.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYCollectionViewSection: NSObject {
    
    /// 获取管理者
    var colViewManager :QYCollectionViewManager?
    
    /// readOnly -> section index in  CollectionView
    var index :Int{
        get{
            return self.colViewManager!.sections.firstIndex(of: self)!;
        }
    }
    
    /// 只读 获取section中全部的Items
    var items :Array<QYCollectionViewItem>{
        get{
            return self.mutiItems;
        }
    }
    /// 私有 存储全部的Item
    private var mutiItems = Array<QYCollectionViewItem>();
    
    
    /// 设置 sectionHeader、sectionFooter 的数据item  设置数据即可显示view  同时需要设置item中宽高
    var item:QYCollectionReusableItem?
    
    
    /// section内容的padding
    var sectionInset:UIEdgeInsets?
    
    /// 主轴间距 默认10
    var lineSpacing :CGFloat?
    
    /// 侧轴间距 默认10
    var interitemSpacing :CGFloat?
    
    
    /// section添加Item方法
    func addItem(_ item:QYCollectionViewItem) -> Void {
        item.section = self;
        self.mutiItems.append(item)
    }

    /// 添加一个Item数组
    /// - Parameter items: 数组
    /// - Returns: 无
    func addItemWithArray(_ items:Array<QYCollectionViewItem>) -> Void {
        for item in items {
            item.section = self;
        }
        self.mutiItems.append(contentsOf:items);
    }
    
    /// 移除一个item
    /// - Parameter index: 下标
    /// - Returns: 无
    func removeItemAtIndex(_ index :Int) -> Void {
        self.mutiItems.remove(at: index);
    }
    
    /// 移除全部的item
    /// - Returns: 无
    func removeAllItem() -> Void {
        self.mutiItems.removeAll();
    }
    
    /// 插入一个item
    /// - Parameters:
    ///   - item: item
    ///   - index: 插入的位置
    /// - Returns: 无
    func insertItem(_ item:QYCollectionViewItem,_ index:Int) -> Void {
        self.mutiItems.insert(item, at: index);
    }
    
    /// 刷新整个sectoin
    /// - Parameter animation: 动画
    /// - Returns: 无
    func reload(_ animation:UITableView.RowAnimation) -> Void {
        self.colViewManager?.collectionView?.reloadSections(IndexSet.init(integer: self.index))
    }
    
}
