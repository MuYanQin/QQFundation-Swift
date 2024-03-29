//
//  MineViewController.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/4/23.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit
class MineViewController: UIViewController ,QQTableViewDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let view = UIView(frame: CGRectMake(100, 100, 100, 100))
        view.backgroundColor = UIColor.purple
        view.layer.shadowColor  =  UIColor.red.cgColor
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 2, height: 0)
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        self.view.addSubview(view)
        
        let v = UIImageView(image: UIImage.generateQRCode(from: "www.github.com"))
        v.frame = CGRectMake(100, 220, 200, 200)
        v.backgroundColor = UIColor.red
        self.view.addSubview(v)
  
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       let alert =  QYAlertViewController.alertController(withTitle: "提示", descText: "", cancel: "取消", button: "确定") { index in

        }
        self.present(alert, animated: true)
    }
}
