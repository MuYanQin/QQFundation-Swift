//
//  QYCommentViewController.swift
//  QQFundation-Swift
//
//  Created by songping on 2023/4/27.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYCommentViewController: QYBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.purple
        btn.addTarget(self, action: #selector(btnCLick), for: .touchUpInside)
        btn.frame = CGRectMake(100, 100, 100, 100)
        self.view.addSubview(btn)
        
        
    }

    @objc func btnCLick() -> Void {
        let commentView = QYCommentView(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight))
        commentView.show()
    }
}
