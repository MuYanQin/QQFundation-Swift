//
//  QYHoverView.swift
//  QQFundation-Swift
//
//  Created by songping on 2023/4/17.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

@objc protocol QYHoverViewDelegate :NSObjectProtocol{
    ///悬浮界面的顶部headView需要设置高度
    func headView() ->UIView
    
    ///悬浮界面下部需要展示的view
    ///如果是self.view上添加的UIScrollView  则返回的是   [UIScrollView,UIScrollView]
    ///如果是self.view上没有添加UIScrollView  则直接返回[UIView,UIView]
    ///也可以混合返回[UIScrollView,UIView]
    ///当然添加UIScrollView的可能是controller的self.view 也可是UIView
    ///这就看下部分每个滑动的分页界面是使用controller还是UIView布局了
    func visibleListView() ->Array<UIView>
    
    ///悬浮界面 展示的分页标题数据
    func pageListTitles() ->Array<String>
    
    ///可选 如上visibleListView 所述 下面三者必须实现其中一个
    ///如果布局使用的UIView则实现此代理方法
    @objc optional func pageListView() ->Array<UIView>
    ///如果布局使用的Controller则实现此代理方法
    @objc optional func pageListController() ->Array<UIViewController>
    
    ///如果布局使用的UIView、VC 混合则实现此代理方法
    @objc optional func pageListContainer() ->Array<Any>
    
    ///每次滑动切换视图的回调
    @objc optional func QYHoverView(houver:QYHoverView,didSelectIndex:Int)

    
}

class QYHoverView: UIView, UIScrollViewDelegate {

    weak var delegate:QYHoverViewDelegate?
    
    var isMidRefresh = false
    var isHover = false
    var isDragNoRelease = false
    
    var visibleView:UIView?
    
    var headHeight = 0.0
    
    lazy var scrollView: UIScrollView = {
        let _scrollView = UIScrollView(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
        _scrollView.contentSize = CGSizeMake(self.frame.width, self.frame.height + self.headHeight)
        _scrollView.showsVerticalScrollIndicator = false
        _scrollView.showsHorizontalScrollIndicator = false
        _scrollView.delegate = self
        if #available(iOS 11, *){
            _scrollView.contentInsetAdjustmentBehavior = .never
        }
        return _scrollView
    }()
    
    var pageView: QYPageView?

    init(frame:CGRect ,delegate: QYHoverViewDelegate) {
        super.init(frame: frame)
        self.delegate = delegate
        let headView = delegate.headView()
        headHeight = headView.frame.height
        self.addSubview(scrollView)
        scrollView.addSubview(headView)
        
        
        let rect = CGRectMake(0, self.headHeight, self.frame.width, self.frame.height + self.headHeight)
        if let litView = delegate.pageListView?() {
            pageView = QYPageView(rect, delegate.pageListTitles(), litView)
        }else if let listVC = delegate.pageListController?() {
            pageView = QYPageView(rect, delegate.pageListTitles(), listVC)
        }else if let listContainer = delegate.pageListContainer?() {
            pageView = QYPageView(rect, delegate.pageListTitles(), listContainer)
        }else{
            print("pageListView,pageListController,pageListContainer 必须实现其中一个")
            return
        }
        scrollView.addSubview(pageView!)
        
        visibleView = delegate.visibleListView()[0]
        visibleViewChangeMutiGesture()
    }
    
    private func visibleViewChangeMutiGesture(){
        if visibleView is QQTableView {
            guard let visibleView = visibleView as? QQTableView else { return  }
            visibleView.canResponseMutiGesture = true
            visibleView.scrollViewDidScroll = {[weak self] scrollView in
                guard let self = self else { return  }
                self.visibleViewDidScroll(scrollView)
            }
        }else if visibleView is QYCollectionView{
            guard let visibleView = visibleView as? QYCollectionView else { return  }
            visibleView.canResponseMutiGesture = true
            visibleView.scrollViewDidScroll = {[weak self] scrollView in
                guard let self = self else { return  }
                self.visibleViewDidScroll(scrollView)
            }
        }
    }
    
    func visibleViewDidScroll(_ scrollView:UIScrollView) -> Void {
        if isMidRefresh {
            
        }else{
            //顶部刷新
            if !isHover{
                guard let visibleView = visibleView as? UIScrollView else { return  }
                visibleView.contentOffset = CGPointZero
            }
            if scrollView.contentOffset.y <= 0{
                isHover = false
            }else{
                isHover = true
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
