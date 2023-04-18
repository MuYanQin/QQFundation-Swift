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

class QYHoverView: UIView, UIScrollViewDelegate,QYPageViewDelagate {

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
        pageView?.delagate = self
        scrollView.addSubview(pageView!)
        
        visibleView = delegate.visibleListView()[0]
        visibleViewChangeMutiGestureAndDidScroll()
    }
    
    private func visibleViewChangeMutiGestureAndDidScroll(){
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
    func didSelectedIndex(pageView: QYPageView, index: Int) {
        self.delegate?.QYHoverView?(houver: self, didSelectIndex: index)
    }
    func startGestureRecognizer() {
        changeGesture(false)
    }
    func endGestureRecognizer() {
        changeGesture(true)
    }
    func changeGesture(_ can :Bool) -> Void {
        if visibleView is QQTableView {
            guard let visibleView = visibleView as? QQTableView else { return  }
            visibleView.canResponseMutiGesture = can

        }else if visibleView is QYCollectionView{
            guard let visibleView = visibleView as? QYCollectionView else { return  }
            visibleView.canResponseMutiGesture = can
        }
    }
    
    func visibleViewDidScroll(_ scrollView:UIScrollView) -> Void {
        if isMidRefresh {
            // 中部有刷新
            if scrollView.contentOffset.y < 0 && !isHover && scrollView.contentOffset.y <= 0 {
                scrollView.contentOffset = CGPointZero
                if scrollView.contentOffset.y < -2 {
                    isDragNoRelease = true;
                }
            } else {
                if scrollView.contentOffset.y >= 0 {
                    isDragNoRelease = false;
                }
                if !isHover && !isDragNoRelease {
                    guard let visibleView = visibleView as? UIScrollView else { return  }
                    visibleView.contentOffset = CGPointZero;
                }
                if scrollView.contentOffset.y <= 0 {
                    isHover = false;
                } else {
                    if !isDragNoRelease {
                        isHover = true;
                    }
                }
            }

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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView{
            // 设置 headView 的位置
            // 向上滑动偏移量大于等于某个值悬停
            if !((visibleView is QQTableView) || (visibleView is QYCollectionView)) {
                if scrollView.contentOffset.y >= headHeight {
                    scrollView.contentOffset = CGPoint(x: 0, y: headHeight)
                    isHover = true
                }
            } else {
                if scrollView.contentOffset.y >= headHeight || isHover {
                    scrollView.contentOffset = CGPoint(x: 0, y: headHeight)
                    isHover = true
                }
            }

            if isMidRefresh {
            
                if visibleView is UIScrollView && (visibleView as! UIScrollView).contentOffset.y <= 0 && scrollView.contentOffset.y <= 0 {
                    scrollView.contentOffset = .zero
                } else {
                    changeTabContentOffsetToZero(true)
                }
            } else {
                changeTabContentOffsetToZero(false)
            }

        }
    }
    
    func changeTabContentOffsetToZero(_ midRefresh: Bool) -> Void {
        if isDragNoRelease && midRefresh {
            scrollView.contentOffset = .zero
        }
        // 设置下面列表的位置
        if scrollView.contentOffset.y < headHeight {
            if !isHover {
                // 列表的偏移度都设置为零
                let tem = delegate?.visibleListView() ?? []
                for subS in tem {
                    guard let subS = subS as? UIScrollView else { return  }
                    if !self.isDragNoRelease &&  midRefresh{
                        subS.contentOffset = .zero
                    }
                }
            }
        }

    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
