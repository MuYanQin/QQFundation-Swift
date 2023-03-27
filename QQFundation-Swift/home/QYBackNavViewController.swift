//
//  QYBackNavViewController.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/24.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYBackNavViewController: QYBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white;
//        self.tableManager.register(cellClass: testCell.self, itemClass: testItem.self);
        QYNetManager.RTGet(url: "", param: [:], from: self) { res in
            
        } failed: { err in
            
        }



    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = QYTestLazyViewController();
        vc.name  = "123";
        print(CFGetRetainCount(vc));
        self.navigationController?.pushViewController(vc, animated: true);
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
