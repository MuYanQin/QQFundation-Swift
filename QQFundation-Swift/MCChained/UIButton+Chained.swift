//
//  UIButton+Chained.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/3/13.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import Foundation
import UIKit



@objc enum Position :Int {
    case none = 0
    case left = 1
    case top = 2
    case bottom = 3
    case right = 4
}

extension UIButton{
    
    
    /// 设置携带信息
    /// - Parameter item: 携带的信息
    @objc func qinfo(item :Any) -> UIButton {
        return self
    }
    
    /// 设置文字位置
    /// - Parameter item: 位置的枚举
    @objc func qtextPosition(item :Position) -> UIButton {
        return self
    }
    
    /// 设置 图片的大小
    /// - Parameter item: size
    @objc func qimageSize(item :CGSize) -> UIButton {
        return self
    }
    
    /// 设置文字图片时间的间距
    /// - Parameter item: 间距
    @objc func qgapBetweenTI(item :CGFloat) -> UIButton {
        return self
    }
    
    
    /// 设置title 默认normal
    /// - Parameter item: 内容
    func qtext(item :String) -> UIButton {
        self.setTitle(item, for: .normal)
        return self;
    }
    
    /// 设置title
    /// - Parameters:
    ///   - item: 内容
    ///   - state: UIControl.State
    func qtextState(item :String,state:UIControl.State) -> UIButton {
        self.setTitle(item, for: state)
        return self;
    }
    
    /// 设置文字颜色 默认normal
    /// - Parameter item: color
    func qtextClolor(item :UIColor) -> UIButton {
        self.setTitleColor(item, for: .normal)
        return self;
     }
    
    /// 设置文字颜色
    /// - Parameters:
    ///   - item: color
    ///   - state: UIControl.State
     func qtextClolorState(item :UIColor,state:UIControl.State) -> UIButton {
        self.setTitleColor(item, for: state)
        return self;
     }
    
    /// 设置图片
    /// - Parameter item: 图片名称
    func qimage(item :String) -> UIButton {
        self.setImage(UIImage.init(named: item), for: .normal)
        return self;
     }
    
    /// 设置图片 默认normal
    /// - Parameters:
    ///   - item: 图片名称
    ///   - state: UIControl.State
     func qimageState(item :String,state:UIControl.State) -> UIButton {
        self.setImage(UIImage.init(named: item), for: state)
        return self;
     }
    
    /// 设置背景图片 默认normal
    /// - Parameter item: 图片名称
    func qbgImage(item :String) -> UIButton {
        self.setBackgroundImage(UIImage.init(named: item), for: .normal)
        return self;
     }
    
    /// 设置背景图片
    /// - Parameters:
    ///   - item: 图片名称
    ///   - state: UIControl.State
     func qbgImageState(item :String,state:UIControl.State) -> UIButton {
        self.setBackgroundImage(UIImage.init(named: item), for: state)
        return self;
     }
    
    /// 设置背景颜色
    /// - Parameter item: color
    func qbgClolor(item :UIColor) -> UIButton {
        self.backgroundColor = item;
        return self
     }
    
    /// 设置字体 默认regular
    /// - Parameter item: 字体大小
    func qfont(item :CGFloat) -> UIButton {
        self.titleLabel?.font = UIFont.systemFont(ofSize: item, weight: .regular)
        return self
     }
    
    
    /// 设置字体
    /// - Parameters:
    ///   - item: 字体大小
    ///   - state: UIFont.Weight
    func qfontWeight(item :CGFloat,state :UIFont.Weight) -> UIButton {
       self.titleLabel?.font = UIFont.systemFont(ofSize: item, weight: .regular)
       return self
    }
    
    
    /// 设置frame
    /// - Parameter item: rect
    func qframe(item :CGRect) -> UIButton {
        self.frame = item
        return self;
    }
    
    /// 设置隐藏
    /// - Parameter item: bool
    func qhidden(item :Bool) -> UIButton {
        self.isHidden = item
        return self;
    }
    
    /// 设置tag
    /// - Parameter item: int
    func qtag(item :Int) -> UIButton {
       self.tag = item
       return self;
    }
    
    /// 设置是否切割
    /// - Parameter item: bool
    func qmasksToBounds(item :Bool) -> UIButton {
        self.layer.masksToBounds = item
       return self;
    }
    
    /// 设置边框颜色
    /// - Parameter item: color
    func qborderColor(item :UIColor) -> UIButton {
        self.layer.borderColor = item.cgColor
       return self;
    }
    
    /// 设置边框粗细
    /// - Parameter item: cgfloat
    func qborderWidth(item :CGFloat) -> UIButton {
        self.layer.borderWidth = item
       return self;
    }
    
    /// 设置圆角
    /// - Parameter item: CGFloat
    func qcornerRadius(item :CGFloat) -> UIButton {
        self.layer.cornerRadius = item
       return self;
    }
    
    
    /// 设置点击事件 默认touchUpInside
    /// - Parameters:
    ///   - item: 类
    ///   - action: 动作
    func qtarget(item :Any? ,action:Selector) -> UIButton {
        self.addTarget(item, action: action, for: .touchUpInside)
       return self;
    }
    
    /// 设置点击事件
    /// - Parameters:
    ///   - item: 类
    ///   - action: 动作
    ///   - event: UIControl.Event
    func qtargetEvent(item :Any? ,action:Selector,event:UIControl.Event) -> UIButton {
        self.addTarget(item, action: action, for: event)
       return self;
    }
    
    
}
