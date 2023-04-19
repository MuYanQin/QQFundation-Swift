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
    static func relay(_ str:Any) -> String {
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
    
    func currentShowVC() -> UIViewController {
        let rootVc = UIApplication.shared.keyWindow?.rootViewController
        let currentVc = findCurrentShowingVC(rootVc!)
        return currentVc
    }
    
    private func findCurrentShowingVC(_ vc:UIViewController) ->UIViewController{
        var currentVc:UIViewController
         if(vc.presentedViewController != nil) {
             currentVc = findCurrentShowingVC(vc.presentedViewController!)
         }else if vc.isKind(of:UITabBarController.classForCoder()) {
           currentVc = findCurrentShowingVC((vc as! UITabBarController).selectedViewController!)
         }else if vc.isKind(of:UINavigationController.classForCoder()){
           currentVc = findCurrentShowingVC((vc as! UINavigationController).visibleViewController!)
         }else{
           currentVc = vc
         }
         return currentVc
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

extension Date{
    
    /// 时间字符串转成需要的格式时间字符串
    /// - Parameters:
    ///   - dateStr: 需要格式化的时间字符串
    ///   - formatter: 格式化格式
    /// - Returns: 时间
    static func relayStrToFormatter(_ dateStr:String,_ formatter:String) ->String{
        let dateFormatter = QYFormatter.sharedInstance.getDateFormatter(formatter)
        let dateFormatter1 = QYFormatter.sharedInstance.getDateFormatter("yyyy-MM-dd HH:mm:ss")
        let date = dateFormatter1.date(from: dateStr)
        return dateFormatter.string(from: date ?? Date())
    }
    
    /// 时间转成字符串
    /// - Parameters:
    ///   - date: 时间
    ///   - formatter: 格式化格式
    /// - Returns: 时间
    static func relayDateToStr(_ date:Date,_ formatter:String) ->String{
        let dateFormatter = QYFormatter.sharedInstance.getDateFormatter(formatter)
        return dateFormatter.string(from: date)
    }
    
    /// 获取现在格式化时间
    /// - Parameter formatter: 格式化格式
    /// - Returns: 时间
    static func noeDate(_ formatter:String) ->String{
        let dateFormatter = QYFormatter.sharedInstance.getDateFormatter(formatter)
        let date = Date()
        return dateFormatter.string(from: date)

    }
    
    /// 转换毫秒时间戳
    /// - Parameters:
    ///   - timestamp: 时间戳
    ///   - formatter: 格式化格式
    /// - Returns: 时间
    static func relayStamp(_ timestamp:String,_ formatter:String) -> String{
         let interval = (Double(NSObject.relay(timestamp))! / 1000.0)
         let date = Date(timeIntervalSince1970: interval)
         let dateFormatter = QYFormatter.sharedInstance.getDateFormatter(formatter)
         return dateFormatter.string(from: date)
    }
}

class QYFormatter: NSObject,NSCacheDelegate {
    static let sharedInstance = QYFormatter()
    lazy var dateCahe: NSCache = {
        let _dateCahe = NSCache<NSString, DateFormatter>()
        _dateCahe.countLimit = 5
        return _dateCahe
    }()
    private override init() {
        
    }
    func getDateFormatter(_ formatter:String) -> DateFormatter {
        guard let dateFormatter = dateCahe.object(forKey: (formatter as NSString)) else {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = formatter
            dateCahe.setObject(dateformatter, forKey: (formatter as NSString))
            return dateformatter
        }
        return dateFormatter
    }
}


