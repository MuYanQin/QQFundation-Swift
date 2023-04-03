//
//  QYCollectionViewManager.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/30.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYCollectionViewManager: NSObject,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    
    /// 传入的collectionView
    var collectionView:QYCollectionView?
    
    /// 数据数组
    private var dataArray : Array<QYCollectionViewSection>?
    
    /// 初始化方法
    /// - Parameter collectionView: collectionView
    init(collectionView:QYCollectionView){
        super.init()
        self.collectionView = collectionView;
        self.collectionView?.delegate = self;
        self.collectionView?.dataSource = self;
    }
    

    
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
        return self.dataArray!.count
    }
    //返回每个section中的item个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray![section].items.count
    }
    
    //注册cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.dataArray![indexPath.section].items[indexPath.row] as QYCollectionViewItem
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: type(of: item)), for: indexPath)
        
        let cel = cell as! QYCollectionViewCell
        cel.item = item
        return cel
    }
    //cell选中事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.dataArray![indexPath.section].items[indexPath.row] as QYCollectionViewItem
        if item.selcetCellHandler != nil {
            item.selcetCellHandler!(item,indexPath.row)
        }
    }
    

    // 设置cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = self.dataArray![indexPath.section].items[indexPath.row]
        return item.itemSize ?? CGSizeMake(20, 20)
    }
    
    // 设置section的padding
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         // return insets
        let edg = self.dataArray![section].sectionInset ?? UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return edg
    }
    
    //cell将要显示
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! QYCollectionViewCell
        cell.cellWillAppear();
    }
    //cell显示结束
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! QYCollectionViewCell
        cell.cellDidDisappear();
    }
    
    //返回header、footer 需要view
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{

        let section  = self.dataArray![indexPath.section]

        if UICollectionView.elementKindSectionFooter == kind {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: type(of: section.item!)), for: indexPath)
            return view
        }else{
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: type(of: section.item!)), for: indexPath)
            return view
        }
    }
    
    // 设置section的headerView大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let section  = self.dataArray![section] as QYCollectionViewSection
        return CGSize(width: section.item?.secHeadWidth ?? 0, height: section.item?.secHeadHeight ?? 0)
    }

    // 设置section的footerView大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        // return size
        let section  = self.dataArray![section] as QYCollectionViewSection
        return CGSize(width: section.item?.secFootWidth ?? 0, height: section.item?.secFootHeight ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let section  = self.dataArray![section] as QYCollectionViewSection
        return section.lineSpacing ?? 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let section  = self.dataArray![section] as QYCollectionViewSection
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.collectionView!.scrollViewDidScroll != nil{
            self.collectionView!.scrollViewDidScroll!(self.collectionView!)
        }
    }
    
    func reloadCollection(_ items:Array<QYCollectionViewSection>) -> Void {
        self.dataArray = items;
        self.collectionView?.reloadData()
    }
    
}
