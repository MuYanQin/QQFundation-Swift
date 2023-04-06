//
//  QQTableViewItem.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/3/11.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit
class QQTableViewItem: NSObject {
    
    /// 获取到的管理者
    var tableViewManager :QQTableViewManager?
    
    /// item 属于哪个section
    var section : QQTableViewSection?
    
    /// 背景颜色
    var bgColor :UIColor?
    
    /// cell的高度
    var cellHeight:CGFloat = 0
    
    /// 是否允许侧滑 默认false
    var allowSlide = false;
    
    /// 设置多个右边侧滑按钮
    var trailingTArray = Array<String>();
    /// 可选 设置多个右边侧滑按钮颜色 默认红色
    var trailingCArray = Array<UIColor>();
    
    /// 设置多个右左边侧滑按钮
    var leadingTArray = Array<String>();
    
    ///  可选设置多个右左边侧滑按钮颜色
    var leadingCArray = Array<UIColor>();
    
    //闭包 就是oc的Block
    
    /// cell选中方法
    var selcetCellHandler: ((_ item :QQTableViewItem)->())?
    
    /// 向右滑事件
    var leadingSwipeHandler: ((QQTableViewItem,NSInteger)->())?
    
    /// 向左滑事件头
    var trailingSwipeHandler: ((QQTableViewItem,NSInteger)->())?
    
    /// 刷新cell
    /// - Parameter animation: 动画方式
    /// - Returns: 无
    func reloadRowWithAnimation(_ animation:UITableView.RowAnimation? = UITableView.RowAnimation.none) -> Void {
        guard let tm = tableViewManager else { return  }
        if animation == UITableView.RowAnimation.none {
            UIView.performWithoutAnimation {
                tm.tableView! .reloadRows(at: [self.indexPath], with: animation!);
            };
        }else{
            tm.tableView! .reloadRows(at: [self.indexPath], with: animation!);
        }
        
    }
    
    func deleteRowWithAnimation(_ animation:UITableView.RowAnimation? = UITableView.RowAnimation.none)  -> Void {
        guard let tm = tableViewManager else { return  }
        guard let sec = section else { return  }

        let row = self.indexPath.row;
        sec.removeItemAtIndex(row);
        if animation == UITableView.RowAnimation.none {
            UIView .performWithoutAnimation {
                tm.tableView! .deleteRows(at: [IndexPath.init(row: row, section: sec.index)], with: animation!);
            };
        }else{
            tm.tableView! .deleteRows(at: [IndexPath.init(row: row, section: sec.index)], with: animation!);
        }
        
    }
    var indexPath :IndexPath{
         get{
             let index = self.section?.items.firstIndex(of: self)
             return IndexPath.init(row:index!, section: self.section!.index);
         }
     };
}
