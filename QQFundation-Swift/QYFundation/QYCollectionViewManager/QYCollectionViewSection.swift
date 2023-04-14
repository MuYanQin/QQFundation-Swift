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
            guard let sec = self.colViewManager?.sections else { return  0}
            guard let ind = sec.firstIndex(of: self) else { return 0 }
            return ind;
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
    var item:QYCollectionReusableItem? {
        didSet{
            item?.section = self
        }
    }
    
    /// section内容的padding
    var sectionInset:UIEdgeInsets?
    
    /// 主轴间距 默认10
    var lineSpacing :CGFloat?
    
    /// 侧轴间距 默认10
    var interitemSpacing :CGFloat?
    
    private var  secHH :CGFloat = 0.00,secHW:CGFloat = 0.0,secFH:CGFloat = 0.0, secFW:CGFloat = 0.0;
    
    
    //MARK: - 操作Item数据源
    /// section添加Item方法
    func addItem(_ item:QYCollectionViewItem) -> Void {
        item.section = self;
        self.mutiItems.append(item)
    }
    
    /// 移除全部的item
    /// - Returns: 无
    func removeAllItem() -> Void {
        self.mutiItems.removeAll();
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
    func removeItemAtIndex(_ index:Int) -> Void {
        self.mutiItems.remove(at: index);
    }
    
    
    /// 移动到哪里去
    /// - Parameters:
    ///   - at: 从哪里的下标
    ///   - to: 到哪里的下标
    /// - Returns: 无
    func moveTo(_ at:Int,_ to:Int) -> Void {
        self.mutiItems.insert(self.mutiItems.remove(at: at), at: to)

    }
    
    
    /// 交换位置
    /// - Parameters:
    ///   - at: 需要交换的下标
    ///   - to: 到哪里的下标
    /// - Returns: 无
    func swapAt(_ at:Int,_ to:Int) -> Void {
        self.mutiItems.swapAt(at, to)
    }
    
    //MARK: - 操作cell视图
    
    /// 移除一个item 并刷新
    /// - Parameter index: 下标
    /// - Returns: 无
    func removeItemWithReload(_ index :Int) -> Void {
        self.mutiItems.remove(at: index);
        self.colViewManager?.collectionView?.performBatchUpdates({
            self.colViewManager?.collectionView?.deleteItems(at: [IndexPath(row: index, section: self.index)])
        })
    }
    
    /// 删除section下所有的item 并刷新
    /// - Returns:无
    func removeAllItemWithReload() -> Void {
        var array = Array<IndexPath>()
        for (index,_) in self.mutiItems.enumerated() {
            array.append(IndexPath(row: index, section: self.index))
        }
        self.mutiItems.removeAll()
        self.colViewManager?.collectionView?.performBatchUpdates({
            self.colViewManager?.collectionView?.deleteItems(at: array)
        })

    }
    
    
    /// 插入一个item 并刷新
    /// - Parameters:
    ///   - item: item
    ///   - index: 插入的位置
    /// - Returns: 无
    func insertItemWithReload(_ item:QYCollectionViewItem,_ index:Int) -> Void {
        self.mutiItems.insert(item, at: index);
        self.colViewManager?.collectionView?.performBatchUpdates({
            self.colViewManager?.collectionView?.insertItems(at: [IndexPath(row: index, section: self.index)])
        })
    }
    
    /// 刷新整个sectoin
    /// - Parameter animation: 动画
    /// - Returns: 无
    func reloadSection() -> Void {
        self.colViewManager?.collectionView?.performBatchUpdates({
            self.colViewManager?.collectionView?.reloadSections(IndexSet.init(integer: self.index))
        })
    }
    
    /// 删除当前的section 并刷新
    /// - Returns:
    func deleteSection() -> Void {
        self.colViewManager?.collectionView?.performBatchUpdates({
            self.colViewManager?.collectionView?.deleteSections(IndexSet(integer: self.index))
        })
    }
    
    
    /// 隐藏header
    /// - Returns: 无
    func hiddenHeaderView() -> Void {
        self.secHH = self.item?.secHeadHeight ?? 0
        self.secHW = self.item?.secHeadWidth ?? 0
        self.item?.secHeadHeight = 0
        self.item?.secHeadWidth = 0
        reloadSection()
    }
    
    /// 显示view
    /// - Returns: 无
    func showHeaderView() -> Void {
        self.item?.secHeadHeight = self.secHH
        self.item?.secHeadWidth = self.secHW
        reloadSection()
    }
    

    
    /// 隐藏Footer
    /// - Returns: 无
    func hiddenFooterView() -> Void {
        self.secFH =  self.item?.secFootHeight ?? 0
        self.secFW =  self.item?.secFootWidth ?? 0
        self.item?.secFootHeight = 0
        self.item?.secFootWidth = 0
        reloadSection()
    }
    
    /// 显示FooterView
    /// - Returns: 
    func showFooterView() -> Void {

        self.item?.secFootHeight = self.secFH
        self.item?.secFootWidth = self.secFW
        reloadSection()
    }
    
    deinit {
        print(self,"dealloc")
    }
}
