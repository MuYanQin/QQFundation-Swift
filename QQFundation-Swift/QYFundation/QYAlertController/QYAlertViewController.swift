//
//  QYAlertViewController.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/4/14.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYAlertViewController: UIViewController ,UIViewControllerTransitioningDelegate{
    let aletView = UIView()
    var isTouchHidden = false
    var titleText:String? = "提示"
    var cancelText:String? = "取消"
    var sureText:String? = "确定"
    var descText:String? = ""
    var buttonAction:((Int) -> Void)?
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let cancelButton = UIButton(type: .custom)
    let sureButton = UIButton(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()
        if isTouchHidden{
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick))
            self.view.addGestureRecognizer(tap)
        }
        self.view.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
    }
    func initUI() -> Void {
        self.view.addSubview(aletView)
        aletView.addSubview(titleLabel)
        aletView.addSubview(descriptionLabel)
        aletView.addSubview(cancelButton)
        aletView.addSubview(sureButton)
    }
    @objc func tapClick(){
        
    }

}
