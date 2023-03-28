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
    
    func qfont(_ item:CGFloat) -> UILabel {
        self.font = UIFont.systemFont(ofSize: item)
        return self
    }
    
    func qfontWeight(_ item:CGFloat,weight:UIFont.Weight) -> UILabel {
        self.font = UIFont.systemFont(ofSize: item,weight: weight)
        return self
    }
    
    func qtextColor(_ item:UIColor) -> UILabel {
        self.textColor = item
        return self
    }
    
    func qbgColor(_ item:UIColor) -> UILabel {
        self.backgroundColor = item
        return self
    }
    
    func qtext(_ item:String) -> UILabel {
        self.text = item
        return self
    }
    
    func qframe(_ item:CGRect) -> UILabel {
        self.frame = item
        return self
    }
    
    func qattributedText(_ item:NSAttributedString) -> UILabel {
        self.attributedText = item
        return self
    }
    
    func qnumberOfLines(_ item:Int) -> UILabel {
        self.numberOfLines = item
        return self
    }
    
    func qtag(_ item:Int) -> UILabel {
        self.tag = item
        return self
    }
    
    func qalignment(_ item:NSTextAlignment) -> UILabel {
        self.textAlignment = item
        return self
    }
    
    func Qhidden(_ item:Bool) -> UILabel {
        self.isHidden = item
        return self
    }
    
    func qtarget(_ item:Any?,_ sel:String) -> UILabel {
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: item, action: NSSelectorFromString(sel))
        self.addGestureRecognizer(tapGesture)
        return self
    }
}
