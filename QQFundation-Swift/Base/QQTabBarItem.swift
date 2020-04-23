//
//  QQTabBarItem.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/4/22.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit
let imageHeight = 24
let imageWidth = CGFloat(imageHeight) * 1.14;

class QQTabBarItem: UIButton {
    
    /// 默认图片
    var defaultImg:UIImage!
    
    /// 选中图片
    var selectedImg:UIImage!
    
    /// 文字
    var text = ""
    
    /// 界面VC
    var vc : UIViewController?
    
    /// 文字与图片的距离
    var margin = 3
    
    /// 图片的大小
    var imgSize = CGSize.init(width: 0, height: 0)
    
    /// 是否是大的Item 中间凸起的
    var isBigItem = false
    
    /// 大Item的size 中间凸起的 isBigItem=true生效
    var bigItemSize = CGSize.init(width: 55, height: 55)
    
    /// 大Item的向上的偏移量 为负数 中间凸起的 isBigItem=true生效
    var offset = 0
    
    
    /// 设置角标  0 就是一个红点  小于0 消失   大于999  显示999+
    var badge  = -1
    
    /// 角标背景色
    var badgeBackColor :UIColor?{
        willSet{
            badgeLabel.backgroundColor = newValue
        }
    }
    
    /// 角标颜色
    var badgeTextColor :UIColor?{
        willSet{
            badgeLabel.textColor = newValue
        }
    }
    
    lazy private var badgeLabel:UILabel = {() -> UILabel in
        var label = UILabel.init()
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    convenience init(defaultS:String,selectedS:String,text:String,vc:UIViewController) {
        self.init(frame:CGRect())
        defaultImg = UIImage.init(named: defaultS)
        selectedImg = UIImage.init(named: selectedS)
        self.text = text
        self.vc = vc
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageX = (self.bounds.size.width - imageWidth) / 2
        if imgSize.width > 0 {
            self.imageView?.frame = CGRect.init(x: Double(imageX), y: Double(5), width: Double(imgSize.width), height: Double(imgSize.height))
        }else{
            self.imageView?.frame = CGRect.init(x: CGFloat(imageX), y: CGFloat(5), width: imageWidth, height: CGFloat(imageHeight))
        }
        self.titleLabel?.frame = CGRect.init(x: CGFloat(0), y: self.imageView!.q_bottom! + CGFloat(margin), width: self.bounds.size.width, height: (self.titleLabel?.frame.size.height)!)
        caculate(count: badge)
    }
    private func caculate(count:Int) -> Void{
        if count < 0 {
            badgeLabel.isHidden = true
            return
        }
        badgeLabel.isHidden = false
        var badgeS = ""
        if count > 999 {
            badgeS = "999+"
        }else{
            badgeS = String(badge)
        }
        badgeLabel.text = badgeS
        badgeLabel.sizeToFit()
        
        let badgeLbx = self.imageView!.frame.origin.x +  self.imageView!.frame.size.width - badgeLabel.frame.size.width/2;
        let badgeLby = self.imageView!.frame.origin.y ;

        if count <= 9 {
            if count == 0{
                badgeLabel.text = ""
                badgeLabel.frame = CGRect.init(x: badgeLbx, y: badgeLby, width:CGFloat(10) , height: CGFloat(10))
            }else{
                badgeLabel.frame = CGRect.init(x: badgeLbx, y: badgeLby, width:CGFloat(14) , height: badgeLabel.frame.size.height)
            }
        }else{
            badgeLabel.frame = CGRect.init(x: badgeLbx, y: badgeLby, width:badgeLabel.frame.size.width + CGFloat(5) , height: badgeLabel.frame.size.height)
        }
        badgeLabel.layer.cornerRadius = badgeLabel.frame.size.height / 2
        badgeLabel.layer.masksToBounds = true
        self.addSubview(badgeLabel)
    }
}
