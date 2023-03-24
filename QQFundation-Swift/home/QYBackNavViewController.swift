//
//  QYBackNavViewController.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/24.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYBackNavViewController: UIViewController,QYBaseNavHiddenDelegate,QYBaseNavBackDelegate {
    func needHiddenNav() -> UIViewController {
        return self;
    }
    
    func needInterceptBack() -> UIViewController {
        print("123")
        return self;
    }
    override func viewWillAppear(_ animated: Bool) {
        let tc =  self.navigationController as! QYBaseNavViewController;
        tc.needInterceptDelegate  = self;
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white;
    }
    
    deinit {
        print("123");
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
