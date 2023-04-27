//
//  PageViewController.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/4/5.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "分页"
        let first = FirstViewController()
        let second = SecondViewController()
        let three = ThreeViewController()
        let pageView = QYPageView(CGRectMake(0, UIDevice.navigationFullHeight(), kScreenWidth, kScreenHeight - UIDevice.navigationFullHeight()), ["社会","军事","娱乐","社会热度","热门新闻","趣事分享","看点"],[first,second,three,first,second,three,first])
        pageView.selectTitleC = UIColor.red
        pageView.marginToLeft = 20
        pageView.marginToRight = 20
        pageView.fontScale = 0.0
        pageView.titleBtnWidth = 80
        pageView.selectTitleF = UIFont.systemFont(ofSize: 20)

        pageView.selectIndex(3)
        pageView.itemBadge(3, 4)
        pageView.itemBadge(0, 98)
        pageView.itemBadge(1, 99)
        pageView.itemBadge(2, 100)
        self.view.addSubview(pageView)
        
        print(pageView.titleBtnWidth)
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
