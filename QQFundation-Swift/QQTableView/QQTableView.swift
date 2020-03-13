//
//  QQTableView.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/3/12.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit

@objc protocol QQTableViewDelegate: NSObjectProtocol{
    
    /// 请求失败回调
    /// - Parameters:
    ///   - tableView: 对象
    ///   - error: 失败原因
   @objc optional func requestFailed(tableView:QQTableView ,error:NSError)

}

class QQTableView: UITableView ,SelfAware {
    static func awake() {
        swizzlingForClass(QQTableView.self, originalSelector: #selector(reloadData), swizzledSelector: #selector(mc_reloadData));

    }
    
    weak var qdelegate: QQTableViewDelegate?
    lazy var emptyView: EmptyView? = { () -> EmptyView in
        
        var subHeight : CGFloat = 0 
        if self.tableHeaderView != nil {
            subHeight = (self.tableHeaderView?.frame.size.height)!
        }
        let te =  EmptyView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - subHeight))
        te.imageName = "icon_em_al"
        te.hintText = "暂无数据"
        return te
    }()
    var hasHeaderRefresh:Bool = true;
    var requestURL :String?
    var requestParam = Dictionary<String,Any>();
    /*
     在swift中实现方法交换必须满足以下条件：
     1，类class必须继承于NSObject
     2，被交换的两个方法前必须用dynamic标记
     **/
    @objc dynamic func mc_reloadData() ->Void{
        mc_reloadData()
        let total = totalItem()
        if total == 0 {
            self.tableFooterView = self.emptyView
        }else{
            self.tableFooterView = nil
        }
    }
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initTableView() -> Void {
        
    }
    
    func totalItem() -> Int {
        let sectionNum = self.numberOfSections;
        var itemNum :Int = 0
        for idx in 0..<sectionNum {
            itemNum = itemNum + self.numberOfRows(inSection: idx)
        }
        if sectionNum > 1 {
            return sectionNum + itemNum
        }
        return itemNum
    }

}

class EmptyView: UIView {
    /// 图片名称
    var imageName:String?{
        willSet{
            self.imageView.image = UIImage.init(named: newValue!)
        }
    }
    /// 图片大小
    var imageSize:CGSize?{
        willSet{
            self.addConstraint(NSLayoutConstraint.init(item: self.imageView!, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: newValue!.width))
            self.addConstraint(NSLayoutConstraint.init(item: self.imageView!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: newValue!.height))
        }
    }
    /// 提示文字
    var hintText:String?{
        willSet{
            self.hintLb.text = newValue
        }
    }
    /**提示文字字体*/
    var hintTextFont:UIFont?{
        willSet{
            self.hintLb.font = newValue
        }
    }

    /**提示文字颜色*/
    var hintTextColor:UIColor?{
        willSet{
            self.hintLb.textColor = newValue
        }
    }

    /**提示文字富文本*/
    var hintAttributedText:NSAttributedString?{
        willSet{
            self.hintLb.attributedText = newValue
        }
    }
    
    private var hintLb:UILabel!
    
    private var imageView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        initEmptyView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initEmptyView() -> Void {
        self.imageView = UIImageView.init()
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.sizeToFit()
        self.addSubview(self.imageView)
        
        self.hintLb = UILabel.init()
        self.hintLb!.textColor = UIColor.init(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        self.hintLb.textAlignment = .center
        self.hintLb.numberOfLines = 0
        self.hintLb.translatesAutoresizingMaskIntoConstraints = false
        self.hintLb.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.addSubview(self.hintLb)
        
        self.addConstraint(NSLayoutConstraint.init(item: self.imageView!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint.init(item: self.imageView!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.8, constant: 0))
        
        
        self.addConstraint(NSLayoutConstraint.init(item: self.hintLb!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: self.hintLb!, attribute: .top, relatedBy: .equal, toItem: self.imageView, attribute: .bottom, multiplier: 1.0, constant: 10))
        self.addConstraint(NSLayoutConstraint.init(item: self.hintLb!, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: -20))
        
    }
}
