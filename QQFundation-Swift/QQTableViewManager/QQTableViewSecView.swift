//
//  QQTableViewSecView.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/3/12.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit

class QQTableViewSecView: UITableViewHeaderFooterView {
    var item:QQTableViewSecItem?
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func secViewWillAppear() -> Void {
        
    }
    
    func secViewDidDisappear() -> Void {
        
    }
}
