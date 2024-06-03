//
//  QYPanelViewController.swift
//  QQFundation-Swift
//
//  Created by peanut on 2024/6/3.
//  Copyright © 2024 leaduadmin. All rights reserved.
//

import UIKit

class QYPanelViewController: QYBaseViewController {
    let panel = QYPanelView(frame: CGRect(x: 0, y: 0, width: 300, height: 300), image: UIImage.init(named: "Default")!)
    @objc func nextClick() -> Void {
        let vc = QYPanelSubViewController()
        vc.image = panel.getImage(.fill)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.nav_rightStrItem("next", #selector(nextClick))
        panel.backgroundColor = .red
        panel.lineWidth = 15
        panel.lineColor = .purple
        self.view.addSubview(panel)
        panel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(QYNavHeight)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-QYTabBarHeight)
        }
        let btn1 = UIButton(type: .custom)
        btn1.qtext("涂抹").qtarget(self, #selector(tumo)).qbgClolor(.purple)
        self.view.addSubview(btn1)
        btn1.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 40))
        }
        let btn = UIButton(type: .custom)
        btn.qtext("擦除").qtarget(self, #selector(cachu)).qbgClolor(.purple)
        self.view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 40))
        }
        
    }
    @objc func tumo() -> Void {
        panel.revoke()
    }
    @objc func cachu() -> Void {
        panel.erase()
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
