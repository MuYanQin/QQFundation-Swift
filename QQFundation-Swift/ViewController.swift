//
//  ViewController.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/3/9.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    var tableView = UITableView();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.red;
        self.tableView.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height);
        self.tableView.backgroundColor = UIColor.yellow;
        self.view.addSubview(self.tableView);
        let tab =  QQTabeViewManager().initWithTableView(tableView: self.tableView);
        tab["testItem"] = "testCell"
        let section = QQTableViewSection();
        let item = testItem.init()
        item.allowSlide = true;
        item.trailingTArray = ["收藏","喜欢"]
        item.leadingTArray = ["删除","卸载"]
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
        tab .reloadDataFromArray(sections: [section]);
        
        
    }


}

