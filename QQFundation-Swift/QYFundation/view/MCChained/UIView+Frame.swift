//
//  UIView+frame.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/3/13.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    var q_height :CGFloat{
        set{
            self.frame.size.height = newValue
        }
        get{
            return self.frame.size.height
        }
    }
    
    var q_width :CGFloat{
        set{
            self.frame.size.width = newValue
        }
        get{
            return self.frame.size.width
        }
    }
    
    var q_top :CGFloat{
        set{
            self.frame.origin.y = newValue
        }
        get{
            return self.frame.origin.y
        }
    }
    
    var q_bottom :CGFloat{
        set{
            var tfram = self.frame
            tfram.origin.y = newValue - self.frame.size.height
            self.frame = tfram
        }
        get{
            return self.frame.origin.y + self.frame.size.height
        }
    }
    
    var q_right :CGFloat{
        set{
            let delta = newValue - (self.frame.origin.x + self.frame.size.width)
            var tfram = self.frame
            tfram.origin.x += delta
            self.frame = tfram
        }
        get{
            return self.frame.origin.x + self.frame.size.width
        }
    }
    
    var q_left :CGFloat{
        set{
            var tfram = self.frame
            tfram.origin.x = newValue
            self.frame = tfram
        }
        get{
            return self.frame.origin.x
        }
    }
    
    /// 添加底部圆角
    /// - Parameter radius: 圆角大小
    /// - Returns: 无
    func configRadiusBottom(_ radius:CGFloat) -> Void {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.layer.masksToBounds = true
    }
    
    /// 添加顶部圆角
    /// - Parameter radius: 圆角大小
    /// - Returns: 无
    func configRadiusTop(_ radius:CGFloat) -> Void {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.masksToBounds = true
    }
    
    /// 全部添加圆角
    /// - Parameter radius: 圆角大小
    /// - Returns: 无
    func configRadiusAll(_ radius:CGFloat) -> Void {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner,.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.masksToBounds = true
    }
    
    /// 添加阴影
    /// - Parameter color: 阴影颜色
    func configShadow(_ color:UIColor? = UIColor.black ){
        self.layer.shadowColor = color?.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
}
