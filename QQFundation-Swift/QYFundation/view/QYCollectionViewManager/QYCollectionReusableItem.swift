//
//  QYCollectionReusableViewItem.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/30.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYCollectionReusableItem: NSObject {
    
    /*
     下面的属性 在垂直滚动 宽度失效 默认collectionView宽
                水瓶滚动 高度失效 默认collectionView高
     需要sectionHeader 就设置secHeadHeight、secHeadWidth
     需要sectionFooter 就设置secFootHeight、secFootWidth
     不需要的话 不用管
     */
    
    //sectionHeader高度设置
    var secHeadHeight :CGFloat?
    //sectionHeader宽度设置
    var secHeadWidth :CGFloat?
    
    
    //sectionFooter高度设置
    var secFootHeight :CGFloat?
    //sectionFooter宽度设置
    var secFootWidth :CGFloat?
    
    weak var section :QYCollectionViewSection?
    
}
