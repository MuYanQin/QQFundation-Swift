//
//  QQTableViewItem.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/3/11.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit
class QQTableViewItem: NSObject {
    var tableViewManager = QQTabeViewManager();
    var section = QQTableViewSection();
    var bgColor :UIColor?
    var cellHeight:CGFloat = 0
    var allowSlide = false;
    var trailingTextArray = Array<String>();
    var trailingColorArray = Array<UIColor>();
    
    var leadingTextArray = Array<String>();
    var leadingColorArray = Array<UIColor>();
    
    var selcetCellHandler: ((_ item :QQTableViewItem)->())?
    var leadingSwipeHandler: ((QQTableViewItem,NSInteger)->())?
    var trailingSwipeHandler: ((QQTableViewItem,NSInteger)->())?
    
    func reloadRowWithAnimation(animation:UITableView.RowAnimation) -> Void {
        if animation == .none {
            UIView.performWithoutAnimation {
                tableViewManager.tableView .reloadRows(at: [self.indexPath!], with: animation);
            };
        }else{
            tableViewManager.tableView .reloadRows(at: [self.indexPath!], with: animation);
        }
        
    }
    
    func deleteRowWithAnimation(animation:UITableView.RowAnimation) -> Void {
        let row = self.indexPath?.row;
        self.section.removeItemAtIndex(index: row!);
        if animation == .none {
            UIView .performWithoutAnimation {
                tableViewManager.tableView .deleteRows(at: [IndexPath.init(row: row!, section: self.section.index!)], with: animation);
            };
        }else{
            tableViewManager.tableView .deleteRows(at: [IndexPath.init(row: row!, section: self.section.index!)], with: animation);
        }
        
    }
    var indexPath :IndexPath?{
         get{
           let index = self.section.items?.firstIndex(where: { item -> Bool in
                return item == self;
            });
            return IndexPath.init(row:index!, section: self.section.index!);
         }
     };
}
