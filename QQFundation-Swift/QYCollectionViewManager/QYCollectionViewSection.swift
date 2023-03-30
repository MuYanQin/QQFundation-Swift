//
//  QYCollectionViewSection.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/30.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYCollectionViewSection: NSObject {
    var items = Array<QYCollectionViewItem>()
    
    
    func addItem(_ item:QYCollectionViewItem) -> Void {
        self.items.append(item)
    }
    
    var item:QYCollectionReusableItem?
    
}
