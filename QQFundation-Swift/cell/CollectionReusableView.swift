//
//  CollectionReusableView.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/30.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class CollectionReusableItem: QYCollectionReusableItem {
    deinit {
        print(self,"dealloc")
    }
}

class CollectionReusableView: QYCollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.purple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
