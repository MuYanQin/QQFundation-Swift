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
        let label = UILabel.getLabel().qtext("测试label").qbgColor(UIColor.yellow).qframe(CGRect.init(x: 0, y: 0, width: 100, height: 50)).qtarget(self, "tttt")
        self.addSubview(label)
    }
    @objc func tttt()->Void{
        print("!@3")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func secViewWillAppear() {

    }
}
