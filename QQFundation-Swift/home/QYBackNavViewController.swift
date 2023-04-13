//
//  QYBackNavViewController.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/24.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYBackNavViewController: QYBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white;
        nav_rightStrItem("跳转", #selector(click))
        self.tableManager.register(cellClass: testCell.self, itemClass: testItem.self);
        let section = QQTableViewSection()
        
        
        let item = testItem.init()
        item.allowSlide = true;
        item.trailingTArray = ["收藏","喜欢"]
        item.leadingTArray = ["删除","卸载"]
        item.name = "测试"
        item.selectCellHandler = {(item) ->() in
            self.navigationController?.pushViewController(QYBackNavViewController(), animated: true);
        }
        item.trailingSwipeHandler = {(item,index)->() in
            print(item , index);
        }
        item.leadingSwipeHandler = {(item,index)->() in
            print(item , index);
        }
        section.addItem(item)
        
        
        
        
        for _ in 1...30{
            let item1 = testItem.init()
            item1.name = "测试3333"
            section.addItem(item1)
        }
        
        for _ in 1...[1,1,1,].count{
            let item1 = testItem.init()
            item1.name = "测试3333"
            section.addItem(item1)
        }

        self.baseArray.append(section);
        self.tableManager .reloadDataFromArray(sections: self.baseArray);


    }
    @objc func click(){
        let vc = QYTestLazyViewController();
        self.navigationController?.pushViewController(vc, animated: true);
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
