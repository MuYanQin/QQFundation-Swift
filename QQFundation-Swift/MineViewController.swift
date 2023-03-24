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

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        let dic = Dictionary<String, Any>(minimumCapacity: 3);
        tb.netWorkBegain(vc: self, param: dic, url: "dff");
        self.view.addSubview(tb);
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
