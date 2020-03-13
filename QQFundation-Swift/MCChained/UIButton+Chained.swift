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
    
    
    @objc func qinfo(item :Any) -> UIButton {
        return self
    }
    
    @objc func qtextPosition(item :Position) -> UIButton {
        return self
    }
    
    @objc func qimageSize(item :CGSize) -> UIButton {
        return self
    }
    
    @objc func qgapBetweenTI(item :CGFloat) -> UIButton {
        return self
    }
    
    func qtext(item :String) -> UIButton {
        self.setTitle(item, for: .normal)
        return self;
    }
    func qtextState(item :String,state:UIControl.State) -> UIButton {
        self.setTitle(item, for: state)
        return self;
    }
    
    func qtextClolor(item :UIColor) -> UIButton {
        self.setTitleColor(item, for: .normal)
        return self;
     }
     func qtextClolorState(item :UIColor,state:UIControl.State) -> UIButton {
        self.setTitleColor(item, for: state)
        return self;
     }
    
    func qimage(item :String) -> UIButton {
        self.setImage(UIImage.init(named: item), for: .normal)
        return self;
     }
     func qimageState(item :String,state:UIControl.State) -> UIButton {
        self.setImage(UIImage.init(named: item), for: state)
        return self;
     }
    
    func qbgImage(item :String) -> UIButton {
        self.setBackgroundImage(UIImage.init(named: item), for: .normal)
        return self;
     }
     func qbgImageState(item :String,state:UIControl.State) -> UIButton {
        self.setBackgroundImage(UIImage.init(named: item), for: state)
        return self;
     }
    
    func qbgClolor(item :UIColor) -> UIButton {
        self.backgroundColor = item;
        return self
     }

    func qfont(item :CGFloat) -> UIButton {
        self.titleLabel?.font = UIFont.systemFont(ofSize: item, weight: .regular)
        return self
     }
    
    func qfontWeight(item :CGFloat,state :UIFont.Weight) -> UIButton {
       self.titleLabel?.font = UIFont.systemFont(ofSize: item, weight: .regular)
       return self
    }
    
    func qframe(item :CGRect) -> UIButton {
        self.frame = item
        return self;
    }
    
    func qhidden(item :Bool) -> UIButton {
        self.isHidden = item
        return self;
    }
    func qtag(item :Int) -> UIButton {
       self.tag = item
       return self;
    }
    func qmasksToBounds(item :Bool) -> UIButton {
        self.layer.masksToBounds = item
       return self;
    }
    func qborderColor(item :UIColor) -> UIButton {
        self.layer.borderColor = item.cgColor
       return self;
    }
    func qborderWidth(item :CGFloat) -> UIButton {
        self.layer.borderWidth = item
       return self;
    }
    func qcornerRadius(item :CGFloat) -> UIButton {
        self.layer.cornerRadius = item
       return self;
    }
    
    func qtarget(item :AnyClass ,action:Selector) -> UIButton {
        self.addTarget(item, action: action, for: .touchUpInside)
       return self;
    }
    func qtargetEvent(item :AnyClass ,action:Selector,event:UIControl.Event) -> UIButton {
        self.addTarget(item, action: action, for: event)
       return self;
    }
    
    func qInfo(item :Any) -> UIButton {
        self.info = item
        return self
    }
    
}
