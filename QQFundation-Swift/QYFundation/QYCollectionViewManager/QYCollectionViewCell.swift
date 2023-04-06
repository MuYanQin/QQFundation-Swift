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
    
    /// item将要显示 在这里设置数据
    /// - Returns: 空
    func cellWillAppear() -> Void {


    }
    
    
    /// 返回自适应宽度
    /// - Returns: size
    func autoCellWidth() -> CGSize {
        return self.item?.itemSize ?? CGSizeMake(0, 0)
    }
    
    /// item将要消失
    /// - Returns: 空
    func cellDidDisappear() -> Void {
        
    }
    
}
