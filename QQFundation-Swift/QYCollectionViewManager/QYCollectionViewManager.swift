//
//  QYCollectionViewManager.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/30.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYCollectionViewManager: NSObject,UICollectionViewDelegate,UICollectionViewDataSource {

    
    
    var collectionView:QYCollectionView?
    
    private var dataArray : Array<QYCollectionViewSection>?
    
    init(collectionView:QYCollectionView){
        super.init()
        self.collectionView = collectionView;
        self.collectionView?.delegate = self;
        self.collectionView?.dataSource = self;
    }
    

    //注册 cell
    func register(cellClass :AnyClass ,itemClass: AnyClass) -> Void {
        let bundle = Bundle.main
        
        if "\(cellClass)".hasSuffix("Cell"){
            if (bundle.path(forResource: "\(cellClass)", ofType: "nib") != nil){
                self.collectionView!.register(UINib.init(nibName: "\(cellClass)", bundle: bundle), forCellWithReuseIdentifier: "\(itemClass)")
            }else{
                self.collectionView!.register(cellClass, forCellWithReuseIdentifier: "\(itemClass)")
            }
        }else{
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataArray!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray![section].items.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.dataArray![indexPath.section].items[indexPath.row] as QYCollectionViewItem
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: type(of: item)), for: indexPath)
        
        let cel = cell as! QYCollectionViewCell
        cel.item = item
        return cel
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.dataArray![indexPath.section].items[indexPath.row] as QYCollectionViewItem
        if item.selcetCellHandler != nil {
            item.selcetCellHandler!(item,indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! QYCollectionViewCell
        cell.cellWillAppear();
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! QYCollectionViewCell
        cell.cellDidDisappear();
    }
    
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{

        let section  = self.dataArray![indexPath.section]

        if UICollectionView.elementKindSectionFooter == kind {
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: type(of: section.item)), for: indexPath)
            return view
        }else  {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: type(of: section.item!)), for: indexPath)
            return view
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let section  = self.dataArray![section] as QYCollectionViewSection
        return CGSize(width: collectionView.bounds.width, height: section.item?.secHeight ?? 0)
    }

    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {

    }
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {

    }
    
    
    func reloadCollection(_ items:Array<QYCollectionViewSection>) -> Void {
        
        //section header全部为空
        var brect = true
        for section in items {
            //有一个不为空就设置为nil
            if section.item != nil{
                brect = false
            }
        }
        if brect{
            (self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout).headerReferenceSize = CGSizeZero;
        }
        
        self.dataArray = items;
        self.collectionView?.reloadData()
    }
    
}
