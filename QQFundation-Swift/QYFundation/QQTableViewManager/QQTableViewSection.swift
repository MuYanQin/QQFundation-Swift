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
            guard let sec = self.tableViewManager?.sections else { return  0}
            guard let ind = sec.firstIndex(of: self) else { return 0 }
            return ind;
        }
    }
    
    /// 只读 获取section中全部的Items
    var items :Array<QQTableViewItem>{
        get{
            return self.mutiItems;
        }
    }
    
    /// 私有 存储全部的Item
    private var mutiItems = Array<QQTableViewItem>();
    
    /// sectionHeaderView的数据源
    var item:QQTableViewSecItem? {
        didSet{
            item?.section = self
        }
    }
    
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
    
    /// 移除一个item 并刷新
    /// - Parameter index: 下标
    /// - Returns: 无
    func removeItemWithReload(_ index :Int,_ animation:UITableView.RowAnimation? = UITableView.RowAnimation.none) -> Void {
        self.mutiItems.remove(at: index);
        self.tableViewManager?.tableView?.performBatchUpdates({
            self.tableViewManager?.tableView?.deleteRows(at: [IndexPath(row: index, section: self.index)], with: animation!)
        })
    }
    
    
    /// 移除全部的item
    /// - Returns: 无
    func removeAllItem() -> Void {
        self.mutiItems.removeAll();
    }
    
    /// 移除全部的item 并刷新
    /// - Returns: 无
    func removeAllItemWithReload(_ animation:UITableView.RowAnimation? = UITableView.RowAnimation.none) -> Void {
        var array = Array<IndexPath>()
        for (index,_) in self.mutiItems.enumerated() {
            array.append(IndexPath(row: index, section: self.index))
        }
        self.mutiItems.removeAll();
        self.tableViewManager?.tableView?.performBatchUpdates({
            self.tableViewManager?.tableView?.deleteRows(at: array, with: animation!)
        })
    }
    
    /// 插入一个item
    /// - Parameters:
    ///   - item: item
    ///   - index: 插入的位置
    /// - Returns: 无
    func insertItemWithReload(_ item:QQTableViewItem,_ index:Int,_ animation:UITableView.RowAnimation? = UITableView.RowAnimation.none) -> Void {
        self.mutiItems.insert(item, at: index);
        self.tableViewManager?.tableView?.performBatchUpdates({
            self.tableViewManager?.tableView?.insertRows(at: [IndexPath.init(row: index, section: self.index)], with: animation!)
        })
    }
    
    
    /// 刷新多个Items
    /// - Parameter items: [QQTableViewItem]
    /// - Returns: 无
    func reloadItems(_ items:[QQTableViewItem]) -> Void {
        guard let tm = tableViewManager else { return  }
        var array:[IndexPath] = Array()
        for item in items {
            array.append(IndexPath(row: item.indexPath.row, section: self.index))
        }
        UIView.performWithoutAnimation {
            tm.tableView! .reloadRows(at: array, with: .none);
        };
    }
    
    /// 刷新整个sectoin
    /// - Parameter animation: 动画
    /// - Returns: 无
    func reloadSection(_ animation:UITableView.RowAnimation? = UITableView.RowAnimation.none) -> Void {
        self.tableViewManager?.tableView?.performBatchUpdates({
            self.tableViewManager?.tableView?.reloadSections(IndexSet.init(integer: self.index), with: animation!)
        })
    }
    
    /// 删除当前的section 并刷新
    /// - Returns:
    func deleteSection(_ animation:UITableView.RowAnimation? = UITableView.RowAnimation.none) -> Void {
        self.tableViewManager?.tableView?.performBatchUpdates({
            self.tableViewManager?.tableView?.deleteSections(IndexSet.init(integer: self.index), with: animation!)
        })
    }
}
