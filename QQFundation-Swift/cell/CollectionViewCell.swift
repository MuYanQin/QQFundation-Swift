//
//  CollectionViewCell.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/30.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class CollectionViewItem: QYCollectionViewItem {
    var text:String?
}

class CollectionViewCell: QYCollectionViewCell {
    
    lazy var label: UILabel = {
        let lb = UILabel().qfont(14).qtextColor(RGB(r: 85, g: 85, b: 85))
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.yellow
        self.addSubview(self.label)
        self.label.frame = CGRectMake(0, 0, self.q_width, self.q_height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func cellWillAppear() {
        super.cellWillAppear()
        _ = self.label.qtext((self.item as! CollectionViewItem).text ?? "")
        
    }
    
}
