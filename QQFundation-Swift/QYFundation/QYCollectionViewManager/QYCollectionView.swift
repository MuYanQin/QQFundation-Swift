//
//  QYCollectionView.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/30.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

//代理
@objc protocol QYCollectionViewDelegate: NSObjectProtocol{
    
    /// 请求失败回调
    /// - Parameters:
    ///   - tableView: 对象
    ///   - error: 失败原因
    
   @objc optional func requestFailed(collectionView:QYCollectionView ,error:NSError)
    
    /// 数据请求成功回调
    /// - Parameters:
    ///   - collectionView: collectionView description
    ///   - downward: 是否下拉
    ///   - result: 结果
   @objc optional func requestData(collectionView:QYCollectionView ,downward:Bool,result : [String : Any])
     
}


class QYCollectionView: UICollectionView {
    
    /// 代理
    weak var qdelegate: QYCollectionViewDelegate?
    
    
    /// 视图滚动回调collectionViewManager实现
    var scrollViewDidScroll:((QYCollectionView) -> ())?
    
    /// 请求界面用于显示loading或者处理别的事物
    weak var vc:UIViewController?
    
    /// 分页使用的字段 判断自动设置页数
    let pageIndex = "page"
    
    /// 请求接口
    var requestURL :String?{
        didSet{
            self.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(requestData));
        }
        //set get是计算属性 在里面设置】读取的时候会循环
        //最好didSet didSet 是专门属性监听器。类似oc的setter getter 方法
    }
    
    /// 请求参数
    var requestParam : Dictionary<String,Any>? 
    
    /// 无数据空白界面 
    lazy var emptyView: EmptyView? = { () -> EmptyView in
        //懒加载 其实就是闭包
        var subHeight : CGFloat = 0

        let te =  EmptyView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        te.imageName = "icon_em_al"
        te.hintText = "暂无数据"
        return te
    }()
    
    /*
     在swift中实现方法交换必须满足以下条件：
     1，类class必须继承于NSObject
     2，被交换的两个方法前必须用dynamic标记
     
    @objc dynamic func qy_reloadData() ->Void{
        qy_reloadData()
        let total = totalItem()
        if total == 0 {
            self.backgroundView = self.emptyView
        }else{
            self.backgroundView = nil
        }
    }
     **/
    /// 重写reload方法 获取cell、section的个数 判断展示空白界面
    override func reloadData() {
        super.reloadData()
        let sectionNum = self.numberOfSections;
        //不管是本地画界面  还是返回数据构建的界面 使用Manager的话 sectoin都是1 添加到view自动执行的section是0
        if sectionNum == 0{
            return
        }
        let total = totalItem(sectionNum)
        
        if total == 0 {
            self.backgroundView = self.emptyView
        }else{
            self.backgroundView = nil
        }
    }
    
    func showEmptyView() -> Void {
        self.backgroundView = self.emptyView

    }
    
    func hiddenEmptyView() -> Void {
        self.backgroundView = nil

    }
    
    private func totalItem(_ sectionNum:Int) -> Int {
        var itemNum :Int = 0
        for idx in 0..<sectionNum {
            itemNum = itemNum + self.numberOfItems(inSection: idx)
        }
        if sectionNum > 1 {
            return sectionNum + itemNum
        }
        return itemNum
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        guard let ly = (layout as? UICollectionViewFlowLayout) else {
            self.alwaysBounceVertical = true
            return
        }
        
        if ly.scrollDirection == .horizontal{
            self.alwaysBounceHorizontal = true
        }else{
            self.alwaysBounceVertical = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 开始数据请求
    /// - Parameters:
    ///   - url: 请求的网址
    ///   - vc: 请求的界面
    ///   - param: 请求的参数
    func netWorkBegain(vc:UIViewController,param:Dictionary<String, Any>?,url:String) -> Void {
        self.requestURL = url
        self.requestParam = param
        self.vc = vc
        self.mj_header?.beginRefreshing()
        
        guard let brect = param?.keys.contains(pageIndex) else { return  }
        if brect {
            self.mj_footer = MJRefreshBackStateFooter.init(refreshingTarget: self, refreshingAction: #selector(footerRefresh))
        }
    }
    
    private func netWork(param:Dictionary<String, Any>?,down:Bool) -> Void {
        
    //FIXME:  (数据请求h处)
        
    }
    
    @objc private func requestData() -> Void {
//        if requestURL == nil {
//            print("QYCollectionView:请输入下载网址")
//            self.mj_header?.endRefreshing()
//            return
//        }

        if let ly = requestParam?.keys.contains(pageIndex) {
            if ly{
                changeIndex(status: 1)
            }
        }
        netWork(param: requestParam, down: true)
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
