//
//  QYPageView.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/4/5.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

@objc protocol QYPageViewDelagate:NSObjectProtocol {
    
    /// 视图选中的view下标
    /// - Parameters:
    ///   - pageView: pageView description
    ///   - index: 下标
    /// - Returns: 无
    @objc optional func didSelectedIndex(pageView:QYPageView,index:Int) -> Void
    
    /// 手指开始接触视图
    @objc optional func startGestureRecognizer()
    
    /// 手指离开视图
    @objc optional func endGestureRecognizer()
}

class QYPageView: UIView , UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
        
    /// 代理
    weak var delagate :QYPageViewDelagate?
    
    /// 右侧距离 默认0
    var marginToRight = 0.0 {
        didSet{
            self.titleScroll.frame.size.width = self.frame.width - marginToRight - self.marginToLeft
        }
    }
    
    /// 左侧距离 默认0
    var marginToLeft = 0.0 {
        didSet{
            self.titleScroll.frame.origin.x = marginToLeft
            self.titleScroll.frame.size.width = self.frame.width - marginToLeft - self.marginToRight
        }
    }
    
    /// 默认标题字体 默认14
    var defaultTitleF = UIFont.systemFont(ofSize: 14) {
        didSet{
            for item in itemArray {
                if item != lastItem{
                    item.titleLabel?.font = defaultTitleF
                }
            }
        }
    }
    
    /// 选中标题字体 默认14
    var selectTitleF = UIFont.systemFont(ofSize: 14) {
        didSet{
            self.lastItem!.titleLabel?.font = selectTitleF
        }
    }
    
    /// 默认标字体颜色 默认灰色
    var defaultTitleC = UIColor.lightGray {
        didSet{
            for item in itemArray {
                if item != lastItem{
                    item.setTitleColor(defaultTitleC, for: .normal)
                }
            }
        }
    }
    
    /// 选中字体颜色 默认黑色
    var selectTitleC = UIColor.black {
        didSet{
            self.lastItem!.setTitleColor(selectTitleC, for: .normal)
            self.lineColor = selectTitleC
            self.lineView.backgroundColor = selectTitleC
        }
    }
    
    /// 标题按钮的宽度 默认平分
    var titleBtnWidth :CGFloat = 60 {
        didSet{
            if (CGFloat(contentTitles.count) * titleBtnWidth) > frame.width {
                self.titleScroll.contentSize = CGSizeMake(CGFloat(contentTitles.count) * titleBtnWidth ,titleViewHeight)
                
            }else{
                self.titleScroll.contentSize = CGSizeMake(frame.width, titleViewHeight)
            }
            for obj in titleScroll.constraints {
                if obj.firstAttribute == .left{
                    obj.isActive = false
                }
            }
            for (index,item) in itemArray.enumerated() {
                for obj in item.constraints {
                    if obj.firstAttribute == .width{
                        obj.isActive = false
                    }
                }
                item.addConstraint(NSLayoutConstraint(item: item, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: titleBtnWidth))
                
                titleScroll.addConstraint(NSLayoutConstraint(item: item, attribute: .left, relatedBy: .equal, toItem: titleScroll, attribute: .left, multiplier: 1, constant: (CGFloat(index) * titleBtnWidth)))
            }
            titleScroll.layoutIfNeeded()

            lineView.frame.size.width =  titleBtnWidth * lineWitdhScale
            scrollToItemCenter(item: lastItem)
        }
    }
    
    /// 横线的颜色 默认与选中标题颜色（selectTitleC）一致
    var lineColor = UIColor.black {
        didSet{
            self.lineView.backgroundColor = lineColor
        }
    }
    
    /// 横线的高度
    var lineHeight = 1.0 {
        didSet{
            self.lineView.frame.origin.y = self.titleViewHeight - lineHeight
            self.lineView.frame.size.height = lineHeight
        }
    }
    
    /// 横线的宽度 是 titleBtnWidth 的多少倍 0～1 取值
    var lineWitdhScale = 0.5 {
        didSet{
            self.lineView.frame.origin.x = self.lineView.frame.origin.x + ( self.lineView.frame.size.width  - self.titleBtnWidth * lineWitdhScale)/2;

            self.lineView.frame.size.width =  self.titleBtnWidth * lineWitdhScale
        }
    }
    
    /// 是否可以滑动 默认true 可滑动
    var canSlide = true {
        didSet{
            self.contentCollection.isScrollEnabled = canSlide
        }
    }
    
    /// 可选 设置头部滑动部分的高度 由于修改 UICollectionView 的frame会重置 contenOffset值 就会引起scrollViewDidScroll代理执行 会造成 设置初始下表不正确故 需要在调用 selectIndex 方法前设置此属性
    var titleViewHeight  = 50.0 {
        didSet{
            titleScroll.frame.size.height = titleViewHeight
            contentCollection.frame.origin.y = titleViewHeight
            contentCollection.frame.size.height = self.frame.height - titleViewHeight
            lineView.frame.origin.y = titleViewHeight - lineHeight
        }
    }
    
    /// 设置选中时候字体当大的倍数 0～1 默认0.2
    var fontScale = 0.2 {
        didSet{
            self.lastItem!.transform = CGAffineTransformMakeScale(1 + fontScale, 1 + fontScale)

        }
    }
    
    /// view视图的数组
    private var contentViews:[Any] = []
    
    /// 标题数组
    private var contentTitles:[String] = []
    
    /// 标题按钮数组
    private var itemArray :[QYItem] = []
    
    /// 是否是点击事件 点击事件 不走横线的动画
    private var isClick = false
    
    /// 保存上一次点击的item
    private var lastItem :QYItem?
    
    /// 保存上一次下标
    private var lastIndex :Int = 0
    
    private var nextColor:UIColor?
    private var defaultR = 0.0 ,defaultG = 0.0 ,defaultB = 0.0,defaultA = 0.0,selectedR = 0.0,selectedG = 0.0,selectedB = 0.0,selectedA = 0.0
    
    /// 头部标题的滑动视图
    private lazy var titleScroll:UIScrollView = {
        let _titleScroll = UIScrollView(frame: CGRectMake(0, 0, self.frame.width, self.titleViewHeight))
        _titleScroll.delegate = self
        _titleScroll.showsVerticalScrollIndicator = false
        _titleScroll.showsHorizontalScrollIndicator = false
        
        if (CGFloat(self.contentTitles.count) * self.titleBtnWidth) > self.frame.width{
            _titleScroll.contentSize = CGSizeMake(CGFloat(self.contentTitles.count) * self.titleBtnWidth,self.titleViewHeight)
        }else{
            _titleScroll.contentSize = CGSizeMake(self.frame.width, self.titleViewHeight)
        }
        
        for (index, text) in contentTitles.enumerated() {
            let item  = QYItem()
            item.translatesAutoresizingMaskIntoConstraints = false
            item.tag = 100 + index
            item.setTitleColor(defaultTitleC, for: .normal)
            item.setTitle(text, for: .normal)
            item.titleLabel?.font = defaultTitleF
            item.titleLabel?.textAlignment = .center
            item.addTarget(self, action: #selector(selectItem(btn:)), for: .touchUpInside)
            if index == 0{
                lastItem = item
                item.transform = CGAffineTransformMakeScale(1 + fontScale, 1 + fontScale)
                item.setTitleColor(selectTitleC, for: .normal)
                item.titleLabel?.font = selectTitleF
            }
            itemArray.append(item)
            _titleScroll.addSubview(item)
            
            _titleScroll.addConstraint(NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal, toItem: _titleScroll, attribute: .top, multiplier: 1, constant: 0))
            _titleScroll.addConstraint(NSLayoutConstraint(item: item, attribute: .height, relatedBy: .equal, toItem: _titleScroll, attribute: .height, multiplier: 1, constant: 0))
            _titleScroll.addConstraint(NSLayoutConstraint(item: item, attribute: .left, relatedBy: .equal, toItem: _titleScroll, attribute: .left, multiplier: 1, constant: (CGFloat(index) * titleBtnWidth)))
            item.addConstraint(NSLayoutConstraint(item: item, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: titleBtnWidth))
            
        }
        return _titleScroll
    }()
    
    private lazy var contentCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let _contentCollection  = UICollectionView(frame: CGRectMake(0, self.titleScroll.frame.height, self.frame.width, self.frame.height - self.titleScroll.frame.height), collectionViewLayout: layout)
        _contentCollection.showsHorizontalScrollIndicator = false
        _contentCollection.isPagingEnabled = true
        _contentCollection.bounces = false
        _contentCollection.delegate = self
        _contentCollection.dataSource = self
        _contentCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return _contentCollection
    }()

    private lazy var lineView: UIView = {
        let _lineView = UIView(frame: CGRectMake(titleBtnWidth / 4, titleViewHeight - 1, titleBtnWidth / 2 , 1))
        _lineView.backgroundColor = lineColor
        return _lineView
    }()
    /// 设置角标的数据 个数与item必须相同
    /// - Parameter badgeArray: 角标数组
    /// - Returns: 无
    func itemBagdeWithArray(_ badgeArray:[Int]) -> Void {
        if (badgeArray.count > itemArray.count || badgeArray.count == 0) {
            print("设置下标错误");
            return;
        }
        for (index,badge) in badgeArray.enumerated(){
            let item = itemArray[index]
            item.badge = badge
        }
    }
    
    /// 设置角标
    /// - Parameters:
    ///   - index: 第一个标题设置
    ///   - badge: 角标
    /// - Returns: 无
    func itemBadge(_ index:Int,_ badge:Int) -> Void {
        if index < 0 || index >= contentTitles.count {
            print("下标位置不合法，不在范围内");
            return
        }
        let item = itemArray[index]
        item.badge = badge
    }
    
    /// 默认选中第几个
    /// - Parameter index: 下标
    /// - Returns: 无
    func selectIndex(_ index:Int) -> Void {
        if index < 0 || index >= contentTitles.count {
            print("下标位置不合法，不在范围内");
            return
        }
        isClick = true
        changeItemStatus(index)
        contentCollection.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: false)
        scrollToItemCenter(item: self.itemArray[index])
        menuScrollToCenter(index)
    }
    
    
    /// 使用VC实例化对象
    /// - Parameters:
    ///   - fram: frame
    ///   - titles: 标题数组
    ///   - controllers: vc数组
    init(_ fram:CGRect,_ titles:[String],_ controllers:[UIViewController]) {
        super.init(frame: fram)
        self.backgroundColor = UIColor.white
        self.contentViews = controllers
        self.contentTitles = titles
        buildParamAndUI(count: CGFloat(titles.count))
    }
    
    /// 使用View实例化对象
    /// - Parameters:
    ///   - fram: frame
    ///   - titles: 标题数组
    ///   - views: view数组
    init(_ fram:CGRect,_ titles:[String],_ views:[UIView]){
        super.init(frame: fram)
        self.backgroundColor = UIColor.white
        self.contentViews = views
        self.contentTitles = titles
        buildParamAndUI(count: CGFloat(titles.count))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   private func buildParamAndUI(count:CGFloat) -> Void {
        self.titleBtnWidth = ((self.frame.width / count) >= 60) ? (self.frame.width / count) : 60
        self.addSubview(self.titleScroll)
        self.addSubview(self.contentCollection)
        self.titleScroll.addSubview(self.lineView)
    }
    
    @objc private func selectItem(btn:QYItem) -> Void {
        selectIndex(btn.tag  - 100)
    }
    
    
    /// 点击 或者设置下标的时候改变item的状态、文字及横线的位置
    /// - Parameter index: 下标
    /// - Returns: wu
    private func changeItemStatus(_ index:Int) -> Void {
        let item = itemArray[index]
        if item == lastItem{
            return
        }
        menuScrollToCenter(index)
        if lastItem != nil{
            lastItem?.titleLabel?.font = defaultTitleF
            lastItem?.setTitleColor(defaultTitleC, for: .normal)
            lastItem?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        lastItem = item
        lastIndex = index
        item.transform = CGAffineTransform(scaleX: 1 + fontScale, y: 1 + fontScale)
        item.titleLabel?.font = selectTitleF
        item.setTitleColor(selectTitleC, for: .normal)
        
        if delagate != nil{
            delagate?.didSelectedIndex?(pageView: self, index: index)
        }
    }
    
    /// 横线滑动到iten下方
    /// - Parameter item: item
    /// - Returns: 无
    private func scrollToItemCenter(item:QYItem?) -> Void {
        guard let item = item else { return }
        self.isClick = false
        UIView.animate(withDuration: 0.3) {
            self.lineView.center.x = self.titleBtnWidth * (0.5 + CGFloat((item.tag - 100)));
        }
    }
    
    /// 顶部菜单 滑动到头视图的中间
    /// - Parameter index: 下标
    /// - Returns: 无
    private func menuScrollToCenter(_ index:Int) -> Void {
        let item = itemArray[index]
        let titleScrollWidth = self.frame.width  - marginToLeft  - marginToRight
        var left = item.center.x - (titleScrollWidth / 2.0)
        left = left <= 0 ? 0 :left
        var maxLeft = (titleBtnWidth * CGFloat(contentTitles.count)) - titleScrollWidth
        if maxLeft <= 0{
            maxLeft = 0
        }
        left = left >= maxLeft ? maxLeft : left
        titleScroll.setContentOffset(CGPointMake(left, 0), animated: true)
    }
    
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contentViews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.isHighlighted = false
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let item = contentViews[indexPath.row]
        if (item is UIView) {
            let v = item as! UIView
            v.frame = cell.contentView.bounds
            cell.contentView.addSubview(v)
            
        }else{
            let v = item as! UIViewController
            v.view.frame = cell.contentView.bounds
            cell.contentView.addSubview(v.view)
        }
    }
    
    // 设置cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(self.frame.width, self.frame.height - self.titleScroll.frame.height);
    }
    
    //MARK: - UIScrollViewDelegate
    //这里主要配合hoverView 解决切换界面的时候手指上下互动界面还是可以滑动的
    // 滑动视图，当手指离开屏幕那一霎那，调用该方法。一次有效滑动，只执行一次。
    // decelerate,指代，当我们手指离开那一瞬后，视图是否还将继续向前滚动（一段距离），经过测试，decelerate=YES
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if delagate != nil{
            delagate?.startGestureRecognizer?()
        }
    }
    // 当开始滚动视图时，执行该方法。一次有效滑动（开始滑动，滑动一小段距离，只要手指不松开，只算一次滑动），只执行一次。
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if delagate != nil{
            delagate?.endGestureRecognizer?()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == contentCollection{
            let index = Int((scrollView.contentOffset.x / self.frame.width))
            if (scrollView.contentOffset.x - (self.frame.width * CGFloat(index))) == 0 {
                changeItemStatus(index)
                return
            }
            
            //如果是点击发生的位移 不执行下面横线的动画
            if isClick{
                return
            }
            //获取位移的百分比
            let percent =  abs((scrollView.contentOffset.x - (self.frame.width * CGFloat(index))) / self.frame.width)
            lineView.center.x = titleBtnWidth * (0.5 + CGFloat(index) + percent);
            
            animationItemColor(isleft: (index < lastIndex), percent: percent, index: index)

        }
    }
    
    /// 滑动时设置标题文字颜色的动画
    /// - Parameters:
    ///   - isLeft: 左滑
    ///   - precent: 百分比
    /// - Returns: 无
    func animationItemColor(isleft:Bool,percent:CGFloat,index: Int) -> Void {
        var nextItem: QYItem?
        var lastItem: QYItem?
        if isleft {
            nextItem = self.itemArray[index]
            lastItem = self.itemArray[index+1]
        } else if !isleft && index + 1 < self.itemArray.count{
            nextItem = self.itemArray[index + 1]
            lastItem = self.itemArray[index]
        }
        if nextItem == nil {
            return;
        }
        if self.nextColor == nil {
            getColorRGB(defaultTitleC, false)
            getColorRGB(selectTitleC, true)
        }
        self.nextColor = UIColor(red: defaultR + (selectedR - defaultR)*percent, green: defaultG + (selectedG - defaultG)*percent, blue: defaultB + (selectedB - defaultB)*percent, alpha: defaultA + (selectedA - defaultA)*percent)

        let lastColor = UIColor(red: selectedR - (selectedR - defaultR)*percent, green: selectedG - (selectedG - defaultG)*percent, blue: selectedB - (selectedB - defaultB)*percent, alpha: selectedA - (selectedA - defaultA)*percent)

        if isleft {
            if let lastItem = lastItem {
                lastItem.setTitleColor(nextColor, for: .normal)
                lastItem.transform = CGAffineTransform(scaleX: 1 + (fontScale * percent), y: 1 + (fontScale * percent))
            }
            nextItem!.setTitleColor(lastColor, for: .normal)
            nextItem!.transform = CGAffineTransform(scaleX: 1 + (1-percent) * fontScale, y: 1 + (1 - percent) * fontScale)
        } else {
            if let lastItem = lastItem {
                lastItem.setTitleColor(lastColor, for: .normal)
                lastItem.transform = CGAffineTransform(scaleX: (1 + fontScale) - (fontScale * percent), y: (1 + fontScale) - (fontScale * percent))
            }
            nextItem!.setTitleColor(nextColor, for: .normal)
            /* 在原来的基础上缩放（只缩放一次） */
            nextItem!.transform = CGAffineTransform(scaleX: 1 + percent * fontScale, y: 1 + percent * fontScale)
        }
    }
    func getColorRGB(_ color:UIColor,_ isSelected:Bool){
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        if isSelected {
            self.selectedA = alpha
            self.selectedR = red
            self.selectedG = green
            self.selectedB = blue
        } else {
            self.defaultA = alpha
            self.defaultR = red
            self.defaultG = green
            self.defaultB = blue
        }

    }
}
class QYItem: UIButton {
    var badge: Int = 0 {
        didSet {
            self.badgeLb.text = String(badge)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        var point: CGPoint = self.badgeLb.center;
        point.x = self.frame.size.width/2 + (self.titleLabel!.frame.size.width/2);
        point.y = self.frame.size.height/2 - self.titleLabel!.frame.size.height/2 - 5;
        self.badgeLb.center = point;
    }

    lazy var badgeLb: QYBadgeLabel = {
        let _badgeLb = QYBadgeLabel()
        _badgeLb.textColor = UIColor.white
        _badgeLb.backgroundColor = UIColor.red
        _badgeLb.font = UIFont.systemFont(ofSize: 10)
        _badgeLb.textAlignment = NSTextAlignment.center
        self.addSubview(_badgeLb)
        return _badgeLb
    }()
}
class QYBadgeLabel: UILabel {
    override var text: String? {
        didSet {
            if let count = Int(text ?? "") {
                if count < 0 {
                    self.isHidden = true
                    return
                }
                self.isHidden = false
                if count > 99 {
                    super.text = "99+"
                } else if count == 0 {
                    super.text = ""
                } else {
                    super.text = "\(count)"
                }
                self.sizeToFit()
                if count <= 9 {
                    self.frame.size = count == 0 ? CGSize(width: 10, height: 10) : CGSize(width: 14, height: 14)
                } else {
                    self.frame.size = CGSize(width: self.frame.size.width + 5, height: 14)
                }
                self.layer.cornerRadius = self.frame.size.height / 2
                self.layer.masksToBounds = true
            } else {
                self.isHidden = true
            }
        }
    }

}
