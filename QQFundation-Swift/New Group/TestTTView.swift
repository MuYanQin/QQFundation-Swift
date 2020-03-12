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
    var label :UILabel?
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 40))
        label!.backgroundColor = UIColor.purple
        self.addSubview(label!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func secViewWillAppear() {
        let item  = self.item as! TestTTItem
        label!.text = item.name;
    }
}
