//
//  QYBaseNavViewController.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/24.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYBaseNavViewController: UINavigationController,UIGestureRecognizerDelegate,UINavigationControllerDelegate,UINavigationBarDelegate {
    
    ///<判断push动作有么有完成
    var isSwitching = false;
    ///<是否禁止滑动
    var forbidSlider = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加系统自带的返回手势
        self.delegate = self;
        if self.responds(to: Selector(("interactivePopGestureRecognizer"))){
            self.interactivePopGestureRecognizer?.delegate = self;
        }
        
        //设置透明度  相差64像素  YES会有蒙层
         //YES (0,0)->(0,0)  NO(0.64) - >(0,0)
        self.navigationBar.isTranslucent = true;
        
        //ios13 之后开始添加
        if #available(iOS 13.0, *){
            let barApp = UINavigationBarAppearance();
            barApp.backgroundColor = RGB(a: 0, g: 122, b: 255);
            barApp.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)];
        }else{
            //导航条的颜色
            self.navigationBar.barTintColor = RGB(a: 0, g: 122, b: 255);
            //导航条title的颜色
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)];
            
            //nav下面的横线消失
            self.navigationBar.shadowImage = UIImage();

        }
    }
    
//MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if (navigationController.viewControllers.count == 1) {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false;
        }else{
            if self.forbidSlider{
                navigationController.interactivePopGestureRecognizer?.isEnabled = false;
            }else{
                navigationController.interactivePopGestureRecognizer?.isEnabled = true;
            }
        }
        
        self.isSwitching = false;
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
//MARK: - UINavigationBarDelegate
    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        return true;
    }
    
//MARK: 重载 popTo 方法
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if !self.isSwitching{
            return super.popToViewController(viewController, animated: animated);
        }else{
            return nil;
        }
    }

    //MARK: 重载 pop 方法
    override func popViewController(animated: Bool) -> UIViewController? {
        if !self.isSwitching{
            return super.popViewController(animated: animated);
        }else{
            return nil;
        }
    }
    
    //MARK: 重载 push 方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.responds(to: Selector(("interactivePopGestureRecognizer"))){
            self.interactivePopGestureRecognizer?.isEnabled = true;
        }
        if self.isSwitching{
            return;
        }
        
        if self.viewControllers.count > 0{
            viewController.hidesBottomBarWhenPushed = true;
        }
        
        var backItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil);
        var textAttrs = Dictionary<String, Any>();
        textAttrs[NSAttributedString.Key.foregroundColor.rawValue] = UIColor.white;
        textAttrs[NSAttributedString.Key.font.rawValue] = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular);
        backItem.tintColor = UIColor.yellow;//返回的颜色
        viewController.navigationItem.backBarButtonItem = backItem;
        super.pushViewController(viewController, animated: animated);
    }
    
    //MARK: - 为了解决与scroll的手势冲突
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if  (gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIScreenEdgePanGestureRecognizer.self)){
            return true;
        }else{
            return false;
        }
    }
    
    //MARK: - 配合修改状态栏颜色
    override var childForStatusBarStyle: UIViewController?{
        return self.topViewController;
    }
    
}
