//
//  BaseDefine.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/24.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import Foundation
import UIKit

let QYStatueBarHeight = UIApplication.shared.statusBarFrame.size.height;

let QYNavHeight = (QYStatueBarHeight > 20) ? 88.0 : 64.0;

let QYTablebarHeight = 49;

let QYBottomDistance = (QYStatueBarHeight > 20) ? 34.0 : 0.0;

let kScreenWidth = UIScreen.main.bounds.size.width;

let kScreenHeight = UIScreen.main.bounds.size.height;

let onePoint = (1 / UIScreen.main.scale);

func RGB(a:CGFloat,g:CGFloat,b:CGFloat) -> UIColor {
    return UIColor.init(red: a, green: g, blue: b, alpha: 1);
}
