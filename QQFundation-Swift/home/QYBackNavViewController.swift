//
//  QYBackNavViewController.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/24.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYBackNavViewController: UIViewController,QYBaseNavHiddenDelegate {
    func needHiddenNav() -> UIViewController {
        return self;
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let tc =  self.navigationController as! QYBaseNavViewController;
        tc.navHiddenDelegate  = self;
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
