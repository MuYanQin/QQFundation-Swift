//
//  CollectionReusableTwoView.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/30.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class CollectionReusableTwoItem: QYCollectionReusableItem{
        
}

class CollectionReusableTwoView: QYCollectionReusableView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
