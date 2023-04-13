//
//  QQTabBarController.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/4/22.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit
let kwidth = UIScreen.main.bounds.size.width

@objc protocol QQTabBarControllerDelegate:NSObjectProtocol {
    
    /// 中间凸起按钮的点击事件
    @objc optional func clickBigItem();
    
    /// 选中的下标
    /// - Parameters:
    ///   - tab: 返回的对象
    ///   - index: 下标
    @objc optional func didSelectdIndex(tab:QQTabBarController,index:Int);
}

class QQTabBarController: UITabBarController {
    weak var customDelegate : QQTabBarControllerDelegate?
    var font : UIFont = UIFont.systemFont(ofSize: 10){
        didSet{
            for item in itemsArray {
                item.titleLabel?.font = font
            }
        }
    }
    var defaultColor : UIColor = UIColor.black{
        didSet{
            for item in itemsArray {
                item.setTitleColor(defaultColor, for: .normal)
            }
        }
    }
    var selectedColor : UIColor = UIColor.black{
        didSet{
            for item in itemsArray {
                item.setTitleColor(selectedColor, for: .selected)
            }
        }
    }
    let  buttonTag = 100
    let   tabbarHeight = 80
    var lastItem : QQTabBarItem = QQTabBarItem()
    var itemsArray:[QQTabBarItem] = []
    
    init(items:Array<QQTabBarItem>,navClass:AnyClass) {
        super.init(nibName:nil, bundle:nil)
        itemsArray = items
        initVc(items: items, navClass: navClass)
        creatTabItem(items: items)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = UIColor.white

        // Do any additional setup after loading the view.
    }
    private func initVc(items:Array<QQTabBarItem>,navClass:AnyClass) -> Void{
        var vcs = Array<UIViewController>()
        let className:String = NSStringFromClass(navClass)

        for item in items {
            if item.vc != nil {
                if (NSClassFromString(className) as? UINavigationController.Type) != nil {
                    let classT = NSClassFromString(className) as! UINavigationController.Type
                    let nav =  classT.init(rootViewController: item.vc!)
                    item.vc!.navigationItem.title = item.text
                    vcs.append(nav as UIViewController)
                }

            }
        }
        self.viewControllers = vcs
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        for item in self.tabBar.subviews {
            if item.isKind(of: NSClassFromString("UITabBarButton")!){
                item.removeFromSuperview()
            }
        }
    }
    
    private func creatTabItem(items:Array<QQTabBarItem>) -> Void {
        let tabWidth = Int(kwidth) /  items.count
        var index = 0
        for (n,s) in items.enumerated(){
            if s.isBigItem  {
                self.tabBar.bigButton = s
                if s.offset >= 0{
                    s.offset = -15
                }
                s.frame = CGRect(x: Double(n * tabWidth), y:Double(s.offset) , width: Double(s.bigItemSize.width), height: Double(s.bigItemSize.height))
                s.center.x = self.tabBar.center.x
                s.setBackgroundImage(s.defaultImg, for: .normal)
                s.setBackgroundImage(s.selectedImg, for: .selected)
            }else{
                s.frame = CGRect(x: Double(n * tabWidth), y:Double(0) , width: Double(tabWidth), height: Double(self.tabBar.frame.size.height))
                s.setTitle(s.text, for: .normal)
                s.setImage(s.defaultImg, for: .normal)
                s.setImage(s.selectedImg, for: .selected)
            }
            if s.vc != nil{
                s.tag = buttonTag + index
                index += 1
            }
            if n == 0 {
                s.isSelected = true
                lastItem = s
            }
            s.addTarget(self, action: #selector(selectedTab(sender:)), for: .touchUpInside)
            s.setTitleColor(defaultColor, for: .normal)
            s.setTitleColor(selectedColor, for: .selected)
            s.titleLabel?.font = font
            s.titleLabel?.textAlignment = .center
            self.tabBar.addSubview(s)
        }
    }
    @objc func selectedTab(sender:QQTabBarItem) -> Void{
        if sender.tag == 0{
            if  (self.customDelegate != nil ) && (self.customDelegate?.responds(to:#selector(customDelegate?.clickBigItem)))! {
                self.customDelegate?.clickBigItem?()
            }
            return
        }
        self.lastItem.isSelected = false

        self.selectedIndex = sender.tag  - buttonTag
        sender.isSelected = true
        self.lastItem = sender
        if ((self.customDelegate != nil ) &&  (self.customDelegate?.responds(to: #selector(self.customDelegate?.didSelectdIndex(tab:index:))))!) {
            self.customDelegate?.didSelectdIndex?(tab: self, index: sender.tag - buttonTag)
        }
    }
    func tabIndex(index:Int) -> Void {
        let item = self.tabBar.viewWithTag(index + buttonTag) as! QQTabBarItem
        selectedTab(sender: item)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
