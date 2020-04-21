//
//  ViewController.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/3/9.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    var tableView = QQTableView();
    
    var dic : Dictionary<String,String>! = Dictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white;
        print(dic["key"] as Any)
        self.tableView.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height);
        self.tableView.backgroundColor = UIColor.yellow;
        self.tableView.emptyView?.hintText = "通过tableView给的文字"
        self.view.addSubview(self.tableView);
        
        let tab =  QQTabeViewManager.init(tableView: self.tableView)
        tab.register(cellClass: testCell.self, itemClass: testItem.self)
        tab.register(cellClass: TestTTView.self, itemClass: TestTTItem.self)
        let section = QQTableViewSection();
        
        let secviewItem = TestTTItem.init()
        secviewItem.name = "测试View"
        section.item = secviewItem
        secviewItem.secHeight = 100
        
        let item = testItem.init()
        item.allowSlide = true;
        item.trailingTArray = ["收藏","喜欢"]
        item.leadingTArray = ["删除","卸载"]
        item.name = "测试"
        item.selcetCellHandler = {(item) ->() in
            print("123")
        }
        item.trailingSwipeHandler = {(item,index)->() in
            print(item , index);
        }
        item.leadingSwipeHandler = {(item,index)->() in
            print(item , index);
        }
        
        section .addItem(item: item)
        
        let item1 = testItem.init()
        item1.name = "测试3333"
        section .addItem(item: item1)

        
        tab .reloadDataFromArray(sections: [section]);
        
        
    }


}

