//
//  UITabBar+MCBigItem.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/4/22.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import Foundation
private var Key: String = ""
extension UITabBar{
    ///传递那个大的button 为了超出部分能响应事件
    var bigButton :UIButton {
        set(newValue){
            objc_setAssociatedObject(self, &Key, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get{
            let bret = ((objc_getAssociatedObject(self, &Key) as? UIButton)!)
            return bret

        }
        
    }
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var view = super.hitTest(point, with: event)
        if view == nil && !self.isHidden {
            let newPoint = bigButton.convert(point, to: self)
            if bigButton.frame.contains(newPoint) {
                view = bigButton
            }
        }
        return view
    }

}
