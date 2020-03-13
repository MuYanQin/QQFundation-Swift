//
//  TestView.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/3/12.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit
class TestTTItem: QQTableViewSecItem {
    var name :String?
}

class TestTTView: QQTableViewSecView {
    var btn :UILabel?
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        let btn = QQButton.init(type: .custom).qframe(item: CGRect.init(x: 0, y: 0, width: 100, height: 50)).qbgClolor(item: UIColor.red)
            .qtextClolor(item: UIColor.purple).qtext(item: "测试按钮").qtextPosition(item: .bottom).qimage(item: "icon_em_al").qfont(item: 14).qtarget(item: self, action: #selector(tttt))
        btn.setTitle("123", for: .normal)
        self.addSubview(btn)
    }
    @objc func tttt()->Void{
        print("!@3")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func secViewWillAppear() {
        let item  = self.item as! TestTTItem
    }
}
