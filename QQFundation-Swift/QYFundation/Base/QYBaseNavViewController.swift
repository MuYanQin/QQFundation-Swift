//
//  QYBaseNavViewController.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/24.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

@objc protocol QYBaseNavBackDelegate :NSObjectProtocol{
    
    /// 需要拦截返回事件
    /// - Returns: 返回需要拦截的界面
    func needInterceptBack() -> UIViewController;
    
    /// 获取到点击事件
    func backClickEvent();
}

@objc protocol QYBaseNavHiddenDelegate :NSObjectProtocol{
    
    
    /// 需要隐藏nav
    /// - Returns: 需要返回隐藏nav的界面
    func needHiddenNav() -> UIViewController;
}
class QYBaseNavViewController: UINavigationController,UIGestureRecognizerDelegate,UINavigationControllerDelegate,UINavigationBarDelegate {
    
    ///<判断push动作有么有完成
    var isSwitching = false;
    ///<是否禁止滑动
    var forbidSlider = false;
    
    weak var navHiddenDelegate : QYBaseNavHiddenDelegate?;
    weak var needInterceptDelegate : QYBaseNavBackDelegate?;
    
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
            barApp.configureWithOpaqueBackground()
            barApp.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)];
            barApp.backgroundColor = RGB(r: 0, g: 122, b: 255)
            barApp.setBackIndicatorImage(UIImage(named: "arrow_right")?.withRenderingMode(.alwaysOriginal), transitionMaskImage: UIImage(named: "arrow_right")?.withRenderingMode(.alwaysOriginal))
            //可以修改图片的上下位置
            barApp.backButtonAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 4)
//           可设置为透明隐藏返回
//            barApp.backButtonAppearance.normal.titleTextAttributes

            self.navigationBar.standardAppearance = barApp
            self.navigationBar.scrollEdgeAppearance = barApp

        }else{
            //导航条的颜色
            self.navigationBar.barTintColor = RGB(r: 0, g: 122, b: 255);
            //导航条title的颜色
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)]
            
            //nav下面的横线消失
            self.navigationBar.shadowImage = UIImage();
            //可以修改图片的上下位置
            UIBarButtonItem .appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: 3), for: UIBarMetrics.default)
            //           可设置为透明隐藏返回
//            UIBarButtonItem .appearance().setTitleTextAttributes(<#T##attributes: [NSAttributedString.Key : Any]?##[NSAttributedString.Key : Any]?#>, for: <#T##UIControl.State#>)
            // 修改导航栏返回按钮图片
             let backButtonImage = UIImage(named: "arrow_right")?.withRenderingMode(.alwaysOriginal)
             navigationBar.backIndicatorImage = backButtonImage
             navigationBar.backIndicatorTransitionMaskImage = backButtonImage
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
        let tc = navigationController.topViewController?.transitionCoordinator;
        tc?.notifyWhenInteractionEnds({ context in
            if !context.isCancelled{
                
            }
        });
        
        ///设置隐藏 nav 如果遵循代理且viewController 同一个就隐藏
        if (self.navHiddenDelegate?.needHiddenNav() == viewController){
            navigationController.setNavigationBarHidden(true, animated: true);
        }else{
            ///如果出来的是图片选择的 则不做处理
            if (navigationController.isKind(of: UIImagePickerController.self)) {
                return;
            }
            navigationController.setNavigationBarHidden(false, animated: true);
        }
    }
//MARK: - UINavigationBarDelegate
    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if self.viewControllers.count < navigationBar.items!.count{
            return true;
        }
        
        //swift 不需要和OC一样判断是否响应的问题。只需要利用optional的可选类型 空判断即可
        if (self.needInterceptDelegate?.needInterceptBack() == self.topViewController){
            self.needInterceptDelegate?.backClickEvent();
            return false;
        }
        
        if #available(iOS 13.0, *) {
            //系统版本高于13.0
        } else {
          _ = self.popViewController(animated: true);
        }
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
        
        let backItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil);
        backItem.tintColor = UIColor.cyan;//返回的颜色
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

//关于代理的问题 参考https://www.jianshu.com/p/3d1ebfc6761c
//uitableView UIcollectionView的代理都是继承自 UIScrollView
/**
 打印uiscrollview发现初始化的时候已经设置代理了
 self = <GestureScrollView: 0x145854800; baseClass = UIScrollView; frame = (0 34.5; 375 568); clipsToBounds = YES; gestureRecognizers = <NSArray: 0x1455d8520>; layer = <CALayer: 0x14551ee40>; contentOffset: {0, 0}; contentSize: {0, 0}>
 panGestureRecognizer.delegate = <GestureScrollView: 0x145854800; baseClass = UIScrollView; frame = (0 34.5; 375 568); clipsToBounds = YES; gestureRecognizers = <NSArray: 0x1455d8520>; layer = <CALayer: 0x14551ee40>; contentOffset: {0, 0}; contentSize: {0, 0}>

 */
extension UIScrollView {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
        super.touchesBegan(touches, with: event)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesMoved(touches, with: event)
        super.touchesMoved(touches, with: event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesEnded(touches, with: event)
        super.touchesEnded(touches, with: event)
    }
    
    @objc(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)
    public  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.panBack(gestureRecognizer) {
            return true
        }
        return false
    }
    
    public func panBack(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location_X: Int = 40
        if gestureRecognizer == self.panGestureRecognizer {
            let pan = gestureRecognizer as! UIPanGestureRecognizer
            let point = pan.translation(in:self)
            let state: UIGestureRecognizer.State = gestureRecognizer.state
            if state == .began || state == .possible {
                let location = gestureRecognizer.location(in: self)
                let temp1 = Int(location.x)
                let temp2 = Int(kwidth)
                let XX = temp1 % temp2
                if point.x > 0 && XX < location_X {
                    return true
                }
            }
        }
        return false
    }
    
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.panBack(gestureRecognizer) {
            return false
        }
        return true
    }

}

