//
//  QYBaseViewController.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/24.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit
class QYBaseViewController: UIViewController ,QQTableViewDelegate{
    
    //懒加载父类tableview视图管理器
    lazy var tableManager: QQTableViewManager = { () -> QQTableViewManager in
        self.view.addSubview(self.baseTableView);
        var manager = QQTableViewManager(tableView: self.baseTableView);
        return manager;
    }()
    
    //懒加载父类基础tablebview
    lazy var baseTableView: QQTableView = { () -> QQTableView in
        var tableView = QQTableView(frame: CGRect(x: 0, y: QYNavHeight, width: kScreenWidth, height: kScreenHeight),style: UITableView.Style.plain);
        tableView.qdelegate = self;
        return tableView;
    }()
    
    //懒加载父类基础数组给tableview视图的数据源使用
    lazy var baseArray = Array<QQTableViewSection>();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        if #available(iOS 13.0, *) {
            return UIStatusBarStyle.darkContent
        } else {
            return UIStatusBarStyle.default;
        };
    }
    
    deinit {
        print("dealloc" + "\(self)");
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
