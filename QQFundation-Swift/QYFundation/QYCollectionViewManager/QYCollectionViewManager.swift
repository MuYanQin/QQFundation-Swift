//
//  QYCollectionViewManager.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/30.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYCollectionViewManager: NSObject,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    
    /// 被管理的属视图
    var collectionView:QYCollectionView?
    
    /// 数据源里面存储所有的section
    var sections = Array<QYCollectionViewSection>()
    
    /// 获取全部的items
    var allItems :Array<QYCollectionViewItem>{
        get{
            var itemArray  = Array<QYCollectionViewItem>();
            for items in self.sections {
                itemArray.append(contentsOf: items.items);
            }
            return itemArray;
        }
    }
    //MARK: - 初始化方法
    /// 初始化方法
    /// - Parameter collectionView: collectionView
    init(collectionView:QYCollectionView){
        super.init()
        self.collectionView = collectionView;
        self.collectionView?.delegate = self;
        self.collectionView?.dataSource = self;
    }
    //MARK: - 操作cell的视图
    
    /// 插入sectoin并刷新
    /// - Parameters:
    ///   - section: section
    ///   - index: 下标
    /// - Returns: 无
    func insertSection(_ section:QYCollectionViewSection, _ index:Int) -> Void {
        self.sections.insert(section, at: index)
        self.collectionView?.performBatchUpdates({
            self.collectionView?.insertSections(IndexSet(integer: index))
        })
    }
    
    /// 移除一个section
    /// - Parameter index: 下标
    /// - Returns: 无
    func removeSection( _ index:Int) -> Void {
        self.sections.remove(at: index)
        self.collectionView?.performBatchUpdates({
            self.collectionView?.deleteSections(IndexSet(integer: index))
        })
    }
    
    /// 刷新collectionView的视图
    /// - Parameter items: section的数组
    /// - Returns: 无
    func reloadCollection(_ sections:Array<QYCollectionViewSection>) -> Void {
        self.sections.removeAll()
        self.sections = sections;
        for sec in sections {
            sec.colViewManager  = self
        }
        self.collectionView?.reloadData()
    }

    //MARK: - collectionView代理
    /// 注册方法
    /// - Parameters:
    ///   - cellClass: cell的class
    ///   - itemClass: item的class
    /// - Returns: 空
    func register(cellClass :AnyClass ,itemClass: AnyClass) -> Void {
        let bundle = Bundle.main
        //区分了cell注册及header、footer注册
        if "\(cellClass)".hasSuffix("Cell"){
            //区分是否xib视图 还是代码
            if (bundle.path(forResource: "\(cellClass)", ofType: "nib") != nil){
                self.collectionView!.register(UINib.init(nibName: "\(cellClass)", bundle: bundle), forCellWithReuseIdentifier: "\(itemClass)")
            }else{
                self.collectionView!.register(cellClass, forCellWithReuseIdentifier: "\(itemClass)")
            }
        }else{
            //区分是否xib视图 还是代码
            if (bundle.path(forResource: "\(cellClass)", ofType: "nib") != nil){
                if ("\(cellClass)".contains("Footer") || "\(cellClass)".contains("footer")){
                    self.collectionView?.register(UINib.init(nibName: "\(cellClass)", bundle: bundle), forSupplementaryViewOfKind:UICollectionView.elementKindSectionFooter, withReuseIdentifier: "\(itemClass)")
                }else{
                    self.collectionView?.register(UINib.init(nibName: "\(cellClass)", bundle: bundle), forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(itemClass)")
                }
            }else{
                if ("\(cellClass)".contains("Footer") || "\(cellClass)".contains("footer")){
                    self.collectionView?.register(cellClass, forSupplementaryViewOfKind:UICollectionView.elementKindSectionFooter, withReuseIdentifier: "\(itemClass)")
                }else{
                    self.collectionView?.register(cellClass, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(itemClass)")
                }
            }
        }
    }
    //返回section的个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    //返回每个section中的item个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].items.count
    }
    
    //注册cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.sections[indexPath.section].items[indexPath.row] as QYCollectionViewItem
        item.colViewManager = self
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: type(of: item)), for: indexPath)
        
        let cel = cell as! QYCollectionViewCell
        cel.item = item
        cel.cellWillAppear();

        if item.itemSize?.width == 0 {
            item.itemSize = cel.autoCellWidth()
            /**
             
             在集合视图的生命周期中，sizeForItemAt 方法只有在以下情况下被调用：

             初始化时；
             调用 invalidateLayout() 方法后；
             插入、删除或移动单元格时。
             因此，如果 sizeForItemAt 方法在初始化集合视图时被调用了一次之后，就不再被调用了，那么可能是由于后面没有再调用上述任意一个条件所致。这时，我们可以根据需要手动调用 invalidateLayout() 方法来强制重新计算单元格大小。
             */
            // 手动触发布局更新
            collectionView.collectionViewLayout.invalidateLayout()
        }
        return cel
    }
    //cell选中事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.sections[indexPath.section].items[indexPath.row] as QYCollectionViewItem
        if item.selectCellHandler != nil {
            item.selectCellHandler!(item,indexPath.row)
        }
    }
    

    // 设置cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = self.sections[indexPath.section].items[indexPath.row]
        return item.itemSize ?? CGSizeMake(20, 20)
    }
    
    // 设置section的padding
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         // return insets
        let edg = self.sections[section].sectionInset ?? UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return edg
    }
    
    //cell将要显示
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    //cell显示结束
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! QYCollectionViewCell
        cell.cellDidDisappear();
    }
    
    //返回header、footer 需要view
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{

        let section  = self.sections[indexPath.section]

        if UICollectionView.elementKindSectionFooter == kind {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: type(of: section.item!)), for: indexPath)
            let tempV = view as! QYCollectionReusableView
            tempV.item = section.item
            return view
        }else{
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: type(of: section.item!)), for: indexPath)
            let tempV = view as! QYCollectionReusableView
            tempV.item = section.item
            return view
        }
    }
    
    // 设置section的headerView大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let section  = self.sections[section] as QYCollectionViewSection
        return CGSize(width: section.item?.secHeadWidth ?? 0, height: section.item?.secHeadHeight ?? 0)
    }

    // 设置section的footerView大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        // return size
        let section  = self.sections[section] as QYCollectionViewSection
        return CGSize(width: section.item?.secFootWidth ?? 0, height: section.item?.secFootHeight ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let section  = self.sections[section] as QYCollectionViewSection
        return section.lineSpacing ?? 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let section  = self.sections[section] as QYCollectionViewSection
        return section.interitemSpacing ?? 10
    }

    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        let vw = view as! QYCollectionReusableView
        vw.viewDidDisappear()
    }
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        let vw = view as! QYCollectionReusableView
        vw.viewWillAppear()
    }
    
    //MARK: - 获取collectionView的滑动距离
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.collectionView!.scrollViewDidScroll != nil{
            self.collectionView!.scrollViewDidScroll!(self.collectionView!)
        }
    }
    
}
