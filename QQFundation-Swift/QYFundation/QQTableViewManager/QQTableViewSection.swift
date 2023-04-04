//
//  QQTableViewSection.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/3/11.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit

class QQTableViewSection: NSObject {
    
    /// 获取到管理者
    var tableViewManager :QQTableViewManager?
    
    /// readOnly -> section index in  UITableView
    var index :Int{
        get{
            return self.tableViewManager!.sections.firstIndex(of: self)!;
        }
    }
    
    /// 只读 获取section中全部的Items
    var items :Array<QQTableViewItem>{
        get{
            return self.mutiItems;
        }
    }
    
    /// sectionHeaderView的数据源
    var item:QQTableViewSecItem?
    
    
    /// 私有 存储全部的Item
    private var mutiItems = Array<QQTableViewItem>();
    
    /// sectionView的高度
    var sectionHeight :CGFloat?;
    ///  sectionView的标题
    var sectionTitle :String?;
    
    /// section 的索引值  多数用在联系人检索
    var indexTitle :String?;
    
    
    /// 添加item数据
    /// - Parameter item: item
    /// - Returns: 无
    func addItem(_ item:QQTableViewItem) -> Void {
        //给Item添加section
        item.section = self;
        self.mutiItems.append(item);
    }
    
    /// 添加一个Item数组
    /// - Parameter items: 数组
    /// - Returns: 无
    func addItemWithArray(_ items:Array<QQTableViewItem>) -> Void {
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
    func insertItem(_ item:QQTableViewItem,_ index:Int) -> Void {
        self.mutiItems.insert(item, at: index);
    }
    
    /// 刷新整个sectoin
    /// - Parameter animation: 动画
    /// - Returns: 无
    func reload(_ animation:UITableView.RowAnimation) -> Void {
        self.tableViewManager!.tableView! .reloadSections(IndexSet.init(integer: self.index), with: animation)
    }
}
