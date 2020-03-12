//
//  QQTableViewCell.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/3/11.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit

class QQTableViewCell: UITableViewCell {

    public var item :QQTableViewItem?
    
     func cellDidLoad() -> Void {
        self.selectionStyle = .none;
        
    }
    func cellWillAppear() -> Void {
        if self.item!.bgColor != nil {
            self.contentView.backgroundColor = self.item!.bgColor;
        }
    }
    func cellDidDisappear() -> Void {
        
    }
    func autoCellHeight() -> CGFloat {
        return self.item!.cellHeight
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super .setSelected(selected, animated: animated)
    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super .setHighlighted(highlighted, animated: animated)
    }
}
