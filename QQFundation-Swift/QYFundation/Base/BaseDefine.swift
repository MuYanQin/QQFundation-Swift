//
//  BaseDefine.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/24.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import Foundation
import UIKit

let QYStatusBarHeight = UIDevice.statusBarHeight()

let QYNavHeight = UIDevice.navigationFullHeight()


let QYBottomDistance = UIDevice.safeDistanceBottom()

let QYTabBarHeight = UIDevice.tabBarHeight()

let QYTabBarFulHeight = UIDevice.tabBarFullHeight()

let kScreenWidth = UIScreen.main.bounds.size.width;

let kScreenHeight = UIScreen.main.bounds.size.height;

let onePoint = (1 / UIScreen.main.scale);

func RGB(r:CGFloat,g:CGFloat,b:CGFloat) -> UIColor {
    return UIColor.init(red:r/255, green: g/255, blue: b/255, alpha: 1);
}

func RGBA(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor {
    return UIColor.init(red:r/255, green: g/255, blue: b/255, alpha: a);
}

///从十六进制字符串获取颜色，
    ///color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
func hex(_ hexString: String,_ alpha:CGFloat = 1) -> UIColor {
    //删除字符串中的空格
    var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
    
    // String should be 6 or 8 characters
    if cString.count < 6 { return UIColor.clear}
    
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    let index = cString.index(cString.endIndex, offsetBy: -6)
    let subString = cString[index...]
    if cString.hasPrefix("0X") { cString = String(subString) }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if cString.hasPrefix("#") { cString = String(subString) }
    
    if cString.count != 6 { return UIColor.clear }
    // Separate into r, g, b substrings
    var range: NSRange = NSMakeRange(0, 2)
    //r
    let rString = (cString as NSString).substring(with: range)
    
    //g
    range.location = 2
    let gString = (cString as NSString).substring(with: range)
    
    //b
    range.location = 4
    let bString = (cString as NSString).substring(with: range)
    
    // Scan values
    var r: UInt32 = 0x0
    var g: UInt32 = 0x0
    var b: UInt32 = 0x0
    
    Scanner(string: rString).scanHexInt32(&r)
    Scanner(string: gString).scanHexInt32(&g)
    Scanner(string: bString).scanHexInt32(&b)
    
    return RGBA(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b), a: alpha);
}
