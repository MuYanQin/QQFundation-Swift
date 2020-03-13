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
        let label = UILabel.getLabel().qtext(item: "测试label").qbgColor(item: UIColor.yellow).qframe(item: CGRect.init(x: 0, y: 0, width: 100, height: 50)).qtarget(item: self, sel: "tttt")
        self.addSubview(label)
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
