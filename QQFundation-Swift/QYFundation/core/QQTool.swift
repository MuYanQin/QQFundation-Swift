//
//  QQTool.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/4/13.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit

extension FileManager{
    
    static func appHomePath() -> String {
        return NSHomeDirectory()
    }
    
    static func documentsPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        return paths[0]
    }
    
    
    static func cachesPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        return paths[0]
    }
    
    static func contentUrlWith(_ path :String) -> Array<Any> {
        if path.isEmpty{
            return []
        }
        let fileManager = FileManager.default
        do{
            let array = try fileManager.contentsOfDirectory(atPath: path)
            return array
        }catch let error {
            print(error)
        }
        return []
    }
    static func isContainAtPath(_ path :String) -> Bool {
        if path.isEmpty{
            return false
        }
        let fileManager = FileManager.default
        let bret =  fileManager.fileExists(atPath: path)
        return bret
    }
    
    static func removeItemAtPath(_ path:String) -> Bool {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: path)
        } catch let error as NSError {
            print("\(path)==删除失败\(error)")
            return false
        }
        return true
    }
    
    static func createFolder(withPath path: String, folderName name: String, success result: @escaping (String?, Error?) -> ()) {
        if path.isEmpty || name.isEmpty {
            print("\(#function)--路径不能为空")
            return
        }
        let fileManager = FileManager.default
                
        let testDirectory = URL(fileURLWithPath: path).appendingPathComponent(name, isDirectory: true)

        do {
            try fileManager.createDirectory(at: testDirectory, withIntermediateDirectories: true)
            result(testDirectory.path, nil)
        } catch let error {
            result(nil, error)
        }

    }
    

    
}
extension Array{
    
}

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
    
    /// 字典转json
    /// - Parameter dic: 字典
    /// - Returns: 无
    static func dictionaryToJson(_ dic: [String: Any]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            guard var jsonString = String(data: jsonData, encoding: .utf8) else {
                return nil
            }
            jsonString = jsonString.replacingOccurrences(of: " ", with: "")
            jsonString = jsonString.replacingOccurrences(of: "\n", with: "")
            return jsonString
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    /// json转字典
    /// - Parameter jsonString: 字符串
    /// - Returns: 无
    static func dictionaryWithJsonString(_ jsonString: String?) -> [String: Any]? {
        guard let jsonString = jsonString else { return nil }
        guard let jsonData = jsonString.data(using: .utf8) else { return nil }
        do {
            let dict = try JSONSerialization.jsonObject(with: jsonData, options: [.mutableContainers]) as? [String: Any]
            return dict
        } catch {
            print("json解析失败：\(error)")
            return nil
        }
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
    
    static func systemVersion() -> CGFloat {
        return CGFloat((UIDevice.current.systemVersion as NSString).floatValue)
    }

    static func AppName() -> String? {
        let bundleName = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String
        return bundleName
    }

    static func APPBundleID() -> String? {
        let bundleID = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
        return bundleID
    }

    static func APPBuild() -> String? {
        let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        return appBuild
    }

    static func APPVersion() -> String? {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return appVersion
    }

    
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

enum QYCalendarType {
    case year,month,day,hour,min,second
}
extension Date{
    
    
    /// 获取一个月多少天
    /// - Parameters:
    ///   - year: 那一年
    ///   - month: 哪一月
    /// - Returns: 天数
    static func numberOfDaysInYear(_ year: Int , month: Int) -> Int {
        if [1, 3, 5, 7, 8, 10, 12].contains(month) {
            return 31
        } else if [4, 6, 9, 11].contains(month) {
            return 30
        } else if (year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3) {
            return 28
        } else if year % 400 == 0 {
            return 29
        } else if year % 100 == 0 {
            return 28
        } else {
            return 29
        }
    }
    
    static func numberOfDaysInCurrentMonth() -> Int {
        let currentDate = Date()
        let calendar = Calendar.current
        return calendar.range(of: .day, in: .month, for: currentDate)!.count
    }

    /// 获取距离某个时间 多久之前 多久之后的时间
    /// - Parameters:
    ///   - space: 多久 正是未来 负是过去
    ///   - from: 距离哪个时间
    ///   - formatter: 返回的时间格式
    ///   - calendarType: 按天、月、年计算
    /// - Returns: 时间
    static func timeInterval(_ space: Int,_ from : Date,_ formatter: String,_ calendarType: QYCalendarType) -> String {
        var comps = DateComponents()
        switch calendarType {
        case .day:
            comps.day = space
        case .month:
            comps.month = space
        case .year:
            comps.year = space
        case .hour:
            comps.hour = space

        case .min:
            comps.minute = space

        case .second:
            comps.second = space

        }
        let calendar = Calendar(identifier: .gregorian)
        let mDate = calendar.date(byAdding: comps, to: from)!
        let dateFormatter = QYFormatter.sharedInstance.getDateFormatter(formatter)
        return dateFormatter.string(from: mDate)
    }

    
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
import CoreImage
extension UIImage{
    static func imageWithColor(_ color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    static func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: .utf8)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        qrFilter.setValue(data, forKey: "inputMessage")
        guard let ciOutputImage = qrFilter.outputImage else { return nil }
        
        return self.createUIImageFromCIImage(image: ciOutputImage, size: 200)
    }
    
   private static func createUIImageFromCIImage(image: CIImage, size: CGFloat) -> UIImage {
           let extent = image.extent.integral
           let scale = min(size / extent.width, size / extent.height)
               
           /// Create bitmap
           let width: size_t = size_t(extent.width * scale)
           let height: size_t = size_t(extent.height * scale)
           let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
           let bitmap: CGContext = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 1)!
          
           ///
           let context = CIContext.init()
           let bitmapImage = context.createCGImage(image, from: extent)
           bitmap.interpolationQuality = .none
           bitmap.scaleBy(x: scale, y: scale)
           bitmap.draw(bitmapImage!, in: extent)
               
           let scaledImage = bitmap.makeImage()
           return UIImage.init(cgImage: scaledImage!)
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


