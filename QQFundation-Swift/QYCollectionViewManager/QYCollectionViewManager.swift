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
    
    init(collectionView:QYCollectionView){
        super.init()
        self.collectionView = collectionView;
        self.collectionView?.delegate = self;
        self.collectionView?.dataSource = self;
    }
    

    
    //注册 cell
    func register(cellClass :AnyClass ,itemClass: AnyClass) -> Void {
        let bundle = Bundle.main
        if (bundle.path(forResource: "\(cellClass)", ofType: "nib") != nil) {
            self.collectionView!.register(UINib.init(nibName: "\(cellClass)" , bundle: bundle), forCellWithReuseIdentifier: "\(itemClass)");
            
        }else if "\(cellClass)".contains("Cell") {
            self.collectionView!.register(cellClass, forCellWithReuseIdentifier: "\(itemClass)")
        } else{
            self.collectionView!.register(cellClass, forHeaderFooterViewReuseIdentifier: "\(itemClass)")
        }
    }
    private func registerSec(viewClass:AnyClass,itemClass:Any) -> Void {
        self.collectionView!.register(viewClass, forHeaderFooterViewReuseIdentifier: "\(itemClass)")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
    }
    

    func reloadCollection(_ item:Array<QYCollectionViewItem>) -> Void {
        self.collectionView?.reloadData()
    }
    
}
