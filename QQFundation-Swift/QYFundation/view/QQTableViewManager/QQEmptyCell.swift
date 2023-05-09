//
//  QQEmptyCell.swift
//  QQFundation-Swift
//
//  Created by songping on 2023/5/9.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit
class QQEmptyItem: QQTableViewItem {
    
    init(_ color: UIColor = UIColor.white, _ height:CGFloat = 10) {
        super.init()
        self.bgColor = color
        self.cellHeight = height
    }

}
class QQEmptyCell: QQTableViewCell {}
