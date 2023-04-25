//
//  HomeViewController.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/4/23.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit

class HomeViewController: QYBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white

        
        print("safeDistanceTop=",UIDevice.safeDistanceTop());
        print("safeDistanceBottom=",UIDevice.safeDistanceBottom());
        print("statusBarHeight=",UIDevice.statusBarHeight());
        print("tabBarFullHeight=",UIDevice.tabBarFullHeight());
        print("navigationFullHeight=",UIDevice.navigationFullHeight());
        print("navigationFullHeight=",self.navigationController?.navigationBar.frame.height as Any);

        nav_rightStrItem("ad", #selector(ac))
        self.tableManager.register(cellClass: testCell.self, itemClass: testItem.self);
        self.tableManager.register(cellClass:StackViewCell.self, itemClass: StackViewItem.self);
        self.tableManager.register(cellClass: TestTTView.self, itemClass: TestTTItem.self);
        
        self.baseTableView.scrollViewDidScroll = {[weak self] scrollView in
            guard let self = self else { return  }
            self.modifyNaviColorOpacity((scrollView.contentOffset.y / 300))

        }
        let section = QQTableViewSection();
        
        let secviewItem = TestTTItem.init()
        secviewItem.name = "测试View"
        secviewItem.secHeight = 100
        section.item = secviewItem
        
        
        let stack = StackViewItem();
        stack.cellHeight = 100;
        section.addItem(stack)

        
        
        
        let page = testItem.init()
        page.name = "分页视图"
        page.selectCellHandler = {(item) ->() in
            self.navigationController?.pushViewController(PageViewController(), animated: true);
        }
        section.addItem(page)
        
        
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
        
        
        
        
        for _ in 1...3{
            let item1 = testItem.init()
            item1.name = "测试3333"
            item1.selectCellHandler = { (item) in
                self.navigationController?.pushViewController(QYTestHeightViewController(), animated: true);

            }
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func ac() -> () {
        
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
