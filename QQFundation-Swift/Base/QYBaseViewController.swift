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
        var tableView = QQTableView(frame: CGRect(x: 0, y: UIDevice.navigationFullHeight(), width: kScreenWidth, height: kScreenHeight - UIDevice.navigationFullHeight() - UIDevice.safeDistanceBottom()),style: UITableView.Style.plain);
        tableView.backgroundColor = UIColor.red
        tableView.qdelegate = self;
        //是否自动适应被tabbar遮挡的地方 automatic 自适应。never 不适应 需要自己手动去修改坐标
//        tableView.contentInsetAdjustmentBehavior = .automatic;
        return tableView;
    }()
    
    //懒加载父类基础数组给tableview视图的数据源使用
    lazy var baseArray = Array<QQTableViewSection>();
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    

}

extension UIViewController{
    
    /// nav右边添加图片按钮
    /// - Parameters:
    ///   - imgName: 图片名称
    ///   - self: 方法
    /// - Returns: 无
    func nav_rightImgItem(imgName:String,sel:Selector) -> Void {
        let rightCustomButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30));
        rightCustomButton.widthAnchor.constraint(equalToConstant: 20).isActive = true;
        rightCustomButton.heightAnchor.constraint(equalToConstant: 20).isActive = true;
        rightCustomButton.addTarget(self, action: sel, for: UIControl.Event.touchUpInside);
        rightCustomButton.setImage(UIImage(named: imgName), for: UIControl.State.normal);
        rightCustomButton.setImage(UIImage(named: imgName), for: UIControl.State.highlighted);
        let rightItem = UIBarButtonItem.init(customView: rightCustomButton);
        self.navigationItem.rightBarButtonItem = rightItem;
        
    }
    
    /// nav右边添加文字按钮
    /// - Parameters:
    ///   - title: 文字
    ///   - color: 文字颜色
    ///   - font: 文字大小字体
    ///   - sel: 方法
    /// - Returns: 无
    func nav_rightStrItem(title:String,color:UIColor?,font:UIFont,sel:Selector) -> Void {
        let rightItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: sel);
        let dic = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont().withSize(14)];
        rightItem .setTitleTextAttributes(dic, for: UIControl.State.normal);
        rightItem .setTitleTextAttributes(dic, for: UIControl.State.highlighted);
        self.navigationItem.rightBarButtonItem = rightItem;
    }
 
    
}
