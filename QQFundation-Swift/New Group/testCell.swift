//
//  testCell.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/3/11.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit
class testItem: QQTableViewItem {
    override init() {
        super .init()
        self.cellHeight = 100;
        self.bgColor = UIColor.red;
    }

}

class testCell: QQTableViewCell {
    override func cellDidLoad() {
        super.cellDidLoad();
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 40))
        view.backgroundColor = UIColor.purple
        self.addSubview(view)
    }
    

}
