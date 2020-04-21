//
//  String+tool.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/4/13.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import Foundation

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
