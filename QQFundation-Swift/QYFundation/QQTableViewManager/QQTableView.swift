//
//  QQTableView.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/3/12.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit

//代理
@objc protocol QQTableViewDelegate: NSObjectProtocol{
    
    /// 请求失败回调
    /// - Parameters:
    ///   - tableView: 对象
    ///   - error: 失败原因
    @objc optional func requestFailed(tableView:QQTableView ,error:NSError)
    
    /// 请求数据成功回调
    /// - Parameters:
    ///   - tableView: tableView description
    ///   - downward: 下拉还是上拉
    ///   - result: 数据
    @objc optional func requestData(tableView:QQTableView ,downward:Bool,result : [String : Any])
     
}

class QQTableView: UITableView  {
    
    /// tableview滚动回调 在tableViewManager中实现
    var scrollViewDidScroll:((QQTableView) -> ())?
    
    /// 代理
    weak var qdelegate: QQTableViewDelegate?
    
    /// 无数据空白界面
    lazy var emptyView: EmptyView? = { () -> EmptyView in
        //懒加载 其实就是闭包
        var subHeight : CGFloat = 0
        if self.tableHeaderView != nil {
            subHeight = (self.tableHeaderView?.frame.size.height)!
        }
        let te =  EmptyView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - subHeight))
        te.imageName = "icon_em_al"
        te.hintText = "暂无数据"
        return te
    }()
    
    /// 是否有头部刷新
    var hasHeaderRefresh:Bool?{
        willSet{
            self.hasHeaderRefresh = newValue
            if !newValue! {
                self.mj_header = nil
            }
        }
    };
    
    /// 请求url
    var requestURL :String?{
        willSet{
            self.requestURL = newValue
            self.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(requestData));
        }
        //set get是计算属性 在里面设置】读取的时候会循环
        //最好willSet didSet 是专门属性监听器。类似oc的setter getter 方法
    }
    
    /// 请求参数
    var requestParam : Dictionary<String,Any>? {
        willSet{
            self.requestParam = newValue
        }
    }
    
    /// 默认的footerView
    var footView = UIView()
    
    /// 请求数据的界面 显示loading用
    var vc:UIViewController?{
        willSet{
            self.vc = newValue
        }
    }
    
    /// 分页使用的字段 判断自动设置页数
    let pageIndex = "page"

    /*
     在swift中实现方法交换必须满足以下条件：
     1，类class必须继承于NSObject
     2，被交换的两个方法前必须用dynamic标记

    @objc dynamic func mc_reloadData() ->Void{
        mc_reloadData()
        let total = totalItem()
        if total == 0 {
            self.tableFooterView = self.emptyView
        }else{
            self.tableFooterView = self.footView
        }
    }
     **/
    
    /// 重写reload方法 获取cell、section的个数 判断展示空白界面
    override func reloadData() {
        super.reloadData()
        let total = totalItem()
        if total == 0 {
            self.tableFooterView = self.emptyView
        }else{
            self.tableFooterView = self.footView
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
        //是否自动适应被tabbar遮挡的地方 automatic 自适应。never 不适应 需要自己手动去修改坐标
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        // iOS 15 的 UITableView又新增了一个新属性：sectionHeaderTopPadding 会给每一个section header 增加一个默认高度
        if #available(iOS 15.0, *) {
             self.sectionHeaderTopPadding = 0;
        }else{
            //iOS15不能设置次属性。因为视图层次改变。添加以后会立即执行 heightForHeaderInSection 方法导致崩溃
            self.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.q_width , height: 0))
        }
        self.footView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.q_width , height: 0))
        self.sectionFooterHeight = 0
        self.sectionHeaderHeight = 0
        self.separatorStyle = .none
        self.estimatedRowHeight = 0
        self.estimatedSectionFooterHeight = 0
        self.estimatedSectionHeaderHeight = 0
    }
    private func totalItem() -> Int {
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
    
    /// 开始数据请求
    /// - Parameters:
    ///   - url: 请求的网址
    ///   - vc: 请求的界面
    ///   - param: 请求的参数
    func netWorkBegain(vc:UIViewController,param:Dictionary<String, Any>,url:String) -> Void {
        self.requestURL = url
        self.requestParam = param
        self.vc = vc
        if param.keys.contains(pageIndex) {
            self.mj_footer = MJRefreshBackStateFooter.init(refreshingTarget: self, refreshingAction: #selector(footerRefresh))
        }
        self.mj_header?.beginRefreshing()
    }
    
    private func netWork(param:Dictionary<String, Any>,down:Bool) -> Void {
        
    //FIXME:  (数据请求h处)
        
    }
    
    @objc private func requestData() -> Void {
//        if requestURL == nil {
//            print("QQTablView:请输入下载网址")
//            self.mj_header?.endRefreshing()
//            return
//        }
        if requestParam!.keys.contains(pageIndex) {
            changeIndex(status: 1)
        }
        netWork(param: requestParam!, down: true)
    }
    

    @objc private func footerRefresh() -> Void {
        changeIndex(status: 2)
        netWork(param: requestParam!, down: false)
        
    }
    private func changeIndex(status: Int) ->Void{
        var number = Int.init(self.requestParam?[pageIndex] as! String)
        
        if status == 1 {
            number = 1;
        } else if status == 2 {
            number! += 1
        } else {
            number! -= 1
        };
        self.requestParam?[pageIndex] = "\(String(describing: number))"
    }
    private func endRefresh() -> Void{
        self.mj_header?.endRefreshing()
        self.mj_footer?.endRefreshing()
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
