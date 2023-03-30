//
//  testCell.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/3/11.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit
class testItem: QQTableViewItem {
    var name :String?;
    override init() {
        super .init()
        self.cellHeight = 100;
        self.bgColor = UIColor.red;
    }

}

class testCell: QQTableViewCell {
    
    var label :UILabel?    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 40))
        label!.backgroundColor = UIColor.purple
        self.addSubview(label!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func cellWillAppear() {
       let item  = self.item as! testItem
       label!.text = item.name;
    }
    

}
