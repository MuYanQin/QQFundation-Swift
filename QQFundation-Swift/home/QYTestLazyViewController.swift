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
        
   
        let section = QYCollectionViewSection();
        section.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let secItem = CollectionReusableItem();
        secItem.secHeadHeight = 100;
        section.item = secItem
        
        for _ in 1...20{
            let item4 = CollectionViewItem();
            item4.itemSize = CGSize(width: (kScreenWidth - 40)/2, height: 80)
            item4.selcetCellHandler = {(item,index) in
                    print(item,index)
            }
            section.items.append(item4);
        }
        
        self.baseColArray.append(section)

        let section1 = QYCollectionViewSection();
        let secItem1 = CollectionReusableTwoItem();
        secItem1.secHeadHeight = 30
        section1.sectionInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        secItem1.secHeadWidth = 80;
        section1.item = secItem1
        
        for _ in 1...20{
            let item4 = CollectionViewItem();
            item4.itemSize = CGSize(width: kScreenWidth - 60 , height: 80)
            section1.items.append(item4);
        }
        
//        self.baseColArray.append(section1)
        
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
