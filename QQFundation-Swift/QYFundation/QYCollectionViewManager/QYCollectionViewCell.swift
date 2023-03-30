//
//  QYCollectionViewCell.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/30.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYCollectionViewCell: UICollectionViewCell {
    
   public var item: QYCollectionViewItem?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellWillAppear() -> Void {

        
    }
    
    func cellDidDisappear() -> Void {
        
    }
    
}
