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
