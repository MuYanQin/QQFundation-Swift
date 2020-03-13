//
//  UILabel+Chained.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/3/13.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
   
    
    static func getLabel() ->UILabel{
        return UILabel.init()
    }
    
    func qfont(item:CGFloat) -> UILabel {
        self.font = UIFont.systemFont(ofSize: item)
        return self
    }
    
    func qfontWeight(item:CGFloat,weight:UIFont.Weight) -> UILabel {
        self.font = UIFont.systemFont(ofSize: item,weight: weight)
        return self
    }
    
    func qtextColor(item:UIColor) -> UILabel {
        self.textColor = item
        return self
    }
    
    func qbgColor(item:UIColor) -> UILabel {
        self.backgroundColor = item
        return self
    }
    
    func qtext(item:String) -> UILabel {
        self.text = item
        return self
    }
    
    func qframe(item:CGRect) -> UILabel {
        self.frame = item
        return self
    }
    
    func qattributedText(item:NSAttributedString) -> UILabel {
        self.attributedText = item
        return self
    }
    
    func qnumberOfLines(item:Int) -> UILabel {
        self.numberOfLines = item
        return self
    }
    
    func qtag(item:Int) -> UILabel {
        self.tag = item
        return self
    }
    
    func qalignment(item:NSTextAlignment) -> UILabel {
        self.textAlignment = item
        return self
    }
    
    func Qhidden(item:Bool) -> UILabel {
        self.isHidden = item
        return self
    }
    
    func qtarget(item:Any?,sel:String) -> UILabel {
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: item, action: NSSelectorFromString(sel))
        self.addGestureRecognizer(tapGesture)
        return self
    }
}
