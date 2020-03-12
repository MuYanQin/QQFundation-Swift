//
//  QQTableViewSection.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/3/11.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit

class QQTableViewSection: NSObject {
    
    var tableViewManager = QQTabeViewManager();
    var index :Int?{
        get{
            return self.tableViewManager.sections.firstIndex(of: self);
        }
    }
    var items :Array<QQTableViewItem>?{
        get{
            return self.mutiItems;
        }
    }
    private var mutiItems = Array<QQTableViewItem>();
    
    var sectionHeight =  0.00;
    var sectionTitle =  NSString();
    var indexTitle :String?;
    
    func section() -> QQTableViewSection {
        return QQTableViewSection.init();
    }
    func addItem(item:QQTableViewItem) -> Void {
        item.section = self;
        self.mutiItems.append(item);
    }
    func addItemWithArray(items:Array<QQTableViewItem>) -> Void {
        for item in items {
            item.section = self;
        }
        self.mutiItems.append(contentsOf:items);
    }
    func removeItemAtIndex(index :Int) -> Void {
        self.mutiItems.remove(at: index);
    }
    func removeAllItem() -> Void {
        self.mutiItems.removeAll();
    }
    func insertItem(item:QQTableViewItem,index:Int) -> Void {
        self.mutiItems.insert(item, at: index);
    }
}
