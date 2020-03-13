//
//  QQTableViewItem.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/3/11.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit
class QQTableViewItem: NSObject {
    var tableViewManager :QQTabeViewManager?
    var section = QQTableViewSection();
    var bgColor :UIColor?
    var cellHeight:CGFloat = 0
    var allowSlide = false;
    var trailingTArray = Array<String>();
    var trailingCArray = Array<UIColor>();
    
    var leadingTArray = Array<String>();
    var leadingCArray = Array<UIColor>();
    
    //闭包 就是oc的Block
    
    /// cell选中方法
    var selcetCellHandler: ((_ item :QQTableViewItem)->())?
    
    /// 向右滑事件
    var leadingSwipeHandler: ((QQTableViewItem,NSInteger)->())?
    
    /// 向左滑事件头
    var trailingSwipeHandler: ((QQTableViewItem,NSInteger)->())?
    
    func reloadRowWithAnimation(animation:UITableView.RowAnimation) -> Void {
        if animation == .none {
            UIView.performWithoutAnimation {
                tableViewManager!.tableView .reloadRows(at: [self.indexPath!], with: animation);
            };
        }else{
            tableViewManager!.tableView .reloadRows(at: [self.indexPath!], with: animation);
        }
        
    }
    
    func deleteRowWithAnimation(animation:UITableView.RowAnimation) -> Void {
        let row = self.indexPath?.row;
        self.section.removeItemAtIndex(index: row!);
        if animation == .none {
            UIView .performWithoutAnimation {
                tableViewManager!.tableView .deleteRows(at: [IndexPath.init(row: row!, section: self.section.index!)], with: animation);
            };
        }else{
            tableViewManager!.tableView .deleteRows(at: [IndexPath.init(row: row!, section: self.section.index!)], with: animation);
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
