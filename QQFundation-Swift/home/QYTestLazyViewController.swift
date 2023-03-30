//
//  QYTestLazyViewController.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/27.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYTestLazyViewController: QYBaseViewController {

      
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.collectManager.register(cellClass: CollectionViewCell.self, itemClass: CollectionViewItem.self)
        self.collectManager.register(cellClass: CollectionReusableView.self, itemClass: CollectionReusableItem.self)
        self.collectManager.register(cellClass: CollectionReusableTwoView.self, itemClass: CollectionReusableTwoItem.self)
        
        /*
        let section = QYCollectionViewSection();
        let secItem = CollectionReusableItem();
        secItem.secHeight = 100;
        section.item = secItem
        
        
        let item = CollectionViewItem();
        section.items.append(item);
        
        
        let item1 = CollectionViewItem();
        section.items.append(item1);
        
        
        let item2 = CollectionViewItem();
        section.items.append(item2);
        
        let item3 = CollectionViewItem();
        section.items.append(item3);
        
        for _ in 1...5{
            let item4 = CollectionViewItem();
            section.items.append(item4);
        }
        
        self.baseColArray.append(section)
        
        */
        let section1 = QYCollectionViewSection();
        let secItem1 = CollectionReusableTwoItem();
        secItem1.secHeight = 30;
        section1.item = secItem1
        
        self.baseColArray.append(section1)
        
        self.collectManager.reloadCollection(self.baseColArray)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
