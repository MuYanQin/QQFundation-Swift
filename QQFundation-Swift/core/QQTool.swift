//
//  QQTool.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/4/13.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit

extension NSObject {
    
    /// 转换为字符串
    /// - Parameter str: 需要转换的值
    func relay(_ str:Any) -> String {
        if let a = str as? NSNumber {
            return a.stringValue
        }else if  ((str as? NSNull) != nil){
            return ""
        }else if let a = str as? String {
            return a.trimStringHAT()
        }else if let a = str as? Substring {
            return "\(a)".trimStringHAT()
        }
        return ""
    }
}
extension String{
    
    /// 是否是数字
    func isNumber() -> Bool {
        let carTest = NSPredicate(format:"SELF MATCHES ^[0-9]*$")
        return carTest.evaluate(with: self)
    }
    
    /// 去除所有空格
    func deleteAllSpace() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    
    /// 去除字符串首位的空格
    func trimStringHAT() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}

extension UIDevice {
    
    /// 顶部安全区高度
    static func safeDistanceTop() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.top
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return 0 }
            return window.safeAreaInsets.top
        }
        return 0;
    }
    
    /// 底部安全区高度
    static func safeDistanceBottom() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        }
        return 0;
    }
    
    /// 顶部状态栏高度（包括安全区）
    static func statusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let statusBarManager = windowScene.statusBarManager else { return 0 }
            statusBarHeight = statusBarManager.statusBarFrame.height
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    /// 导航栏高度
    static func navigationBarHeight() -> CGFloat {
        return 44.0
    }
    
    /// 状态栏+导航栏的高度
    static func navigationFullHeight() -> CGFloat {
        return UIDevice.statusBarHeight() + UIDevice.navigationBarHeight()
    }
    
    /// 底部导航栏高度
    static func tabBarHeight() -> CGFloat {
        
        return 49.0
    }
    
    /// 底部导航栏高度（包括安全区）
    static func tabBarFullHeight() -> CGFloat {
        return UIDevice.tabBarHeight() + UIDevice.safeDistanceBottom()
    }
}



