//
//  AppDelegate.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/3/9.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var tab :QQTabBarController = { () -> QQTabBarController in
        let home = HomeViewController()
        let serach = SearchViewController()
        let mine = MineViewController()
        
        var hItem = QQTabBarItem.init(defaultS: "navigation_home_defaut", selectedS: "navigation_home_active", text: "首页", vc: home)
        hItem.badge = 30

        
        var sItem = QQTabBarItem.init()
        sItem.vc = serach
        sItem.text = "搜索"
        sItem.defaultImg = UIImage.init(named: "tab_launch@2x")
        sItem.selectedImg = UIImage.init(named: "tab_launch@2x")
        
        var mItem = QQTabBarItem.init()
        mItem.vc = mine
        mItem.text = "我的"
        mItem.defaultImg = UIImage.init(named: "navigation_mine_defaut")
        mItem.selectedImg = UIImage.init(named: "navigation_mine_active")
        
        let t = QQTabBarController.init(items: [hItem,sItem,mItem], navClass: QYBaseNavViewController.self)
        t.defaultColor = UIColor.black
        t.selectedColor = UIColor.red
        return t
    }()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = tab
        return true
    }




}

