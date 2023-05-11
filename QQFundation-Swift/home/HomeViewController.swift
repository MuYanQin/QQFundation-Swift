//
//  HomeViewController.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/4/23.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit
import SwiftUI

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
        self.tableManager.register(cellClass: QQEmptyCell.self, itemClass: QQEmptyItem.self);
        
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
        
        let empty = QQEmptyItem()
        section.addItem(empty)

        let SWIFTUIItem = testItem.init()
        SWIFTUIItem.name = "集成SwiftUIDemo"
        SWIFTUIItem.selectCellHandler = {(item) ->() in
            
        }
        section.addItem(SWIFTUIItem)
        
        
        let orientationItem = testItem.init()
        orientationItem.name = "强制横屏"
        orientationItem.selectCellHandler = {(item) ->() in
            let vc = OrientationItemViewController()
            self.navigationController?.pushViewController(vc, animated: true);
        }
        section.addItem(orientationItem)
        
        
        self.baseArray.append(section);
        self.tableManager .reloadDataFromArray(sections: self.baseArray);
        
        QYNetManager.RTGet(url: "https://indexrxn.chinahrt.com/my_courses?goodsType=016003&login_name=rx_18afd44d3dc44faba99e8a6d1c3cd079&page_offset=1&page_size=10&user_id=7d15f65740054218b042487a912717ae&webPlatformId=69", param: nil) { res in
            
        } failed: { err in
            
        }
        
        let dic = ["wd":"一心一意",
                   "city":"合肥",
                   "key":"9fb1050d51053e5ae75513ea08566ccc"
        ]
        QYNetManager.RTSPost(url: "http://apis.juhe.cn/simpleWeather/query", param:dic) { res in
            
        } failed: { err in
            
        }



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
