//
//  HomeViewController.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/4/23.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit

class HomeViewController: QYBaseViewController ,QYSacnCodeDelegate{
    func scanCodeResult(_ text: String) {
        
        print(text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white

        self.title = "首页"

        nav_rightStrItem("ad", #selector(ac))
        self.tableManager.register(cellClass: testCell.self, itemClass: testItem.self);
        self.tableManager.register(cellClass:StackViewCell.self, itemClass: StackViewItem.self);
        self.tableManager.register(cellClass: TestTTView.self, itemClass: TestTTItem.self);
        self.baseTableView.q_height -= QYTabBarFulHeight
        let section = QQTableViewSection();
        
        let secviewItem = TestTTItem.init()
        secviewItem.name = "测试TabviewSectionView"
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
        item.name = "导航栏渐变的效果"
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
        
        
        
        let item1 = testItem.init()
        item1.name = "collectionView的视图管理"
        item1.selectCellHandler = {(item) ->() in
            self.navigationController?.pushViewController(QYTestLazyViewController(), animated: true);
        }
        section.addItem(item1)
        
        
        let commentItem = testItem.init()
        commentItem.name = "评论使用textView"
        commentItem.selectCellHandler = {(item) ->() in
            self.navigationController?.pushViewController(QYCommentViewController(), animated: true);
        }
        section.addItem(commentItem)
        
        let scanItem = testItem.init()
        scanItem.name = "扫描二维码"
        scanItem.selectCellHandler = {(item) ->() in
            let vc = QYSacnCodeViewController()
            vc.scanArea = .full
            vc.delegate = self
            vc.scanSize = CGSizeMake(300, 120)
            self.navigationController?.pushViewController(vc, animated: true);
        }
        section.addItem(scanItem)
        
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
