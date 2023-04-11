//
//  MineViewController.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/4/23.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit
class MineViewController: UIViewController ,QQTableViewDelegate{

    let tb = QQTableView(frame: CGRect(x: 0, y: 0, width: 300, height: 300));
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
        
        // 同时添加右侧阴影
        let rightShadowLayer = CALayer()
        rightShadowLayer.frame = view.bounds
        rightShadowLayer.backgroundColor = UIColor.purple.cgColor
        rightShadowLayer.shadowColor = UIColor.black.cgColor
        rightShadowLayer.shadowOffset = CGSize(width: -2, height: 0)
        rightShadowLayer.shadowRadius = 4
        rightShadowLayer.shadowOpacity = 0.8
        view.layer.addSublayer(rightShadowLayer)
        
        
        
        
        
        let view1 = UIView(frame: CGRectMake(100, 250, 100, 100))
        view1.backgroundColor = UIColor.gray
        let shapLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPointMake(0, 0))
        path.addLine(to: CGPointMake(0, 100))
        shapLayer.path = path.cgPath
        shapLayer.shadowColor = UIColor.red.cgColor
        shapLayer.shadowRadius = 5
        shapLayer.shadowOpacity = 0.8
        shapLayer.shadowOffset = CGSize(width: 0, height: 0)
        shapLayer.lineWidth = 0
        shapLayer.strokeColor = UIColor.purple.cgColor;

        view1.layer.addSublayer(shapLayer)
        self.view.addSubview(view1)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
