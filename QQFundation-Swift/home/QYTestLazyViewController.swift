//
//  QYTestLazyViewController.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/27.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYTestLazyViewController: QYBaseViewController {

    lazy var name: String = {() -> String in
        self.view.addSubview(self.baseTableView);
        return "";
    }()
      
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white;
        self.tableManager.register(cellClass: testCell.self, itemClass: testItem.self);
        
        print(CFGetRetainCount(self));
        
        var arr = Array<Any>();
        var arr1 = Array<Any>();
        arr.append(arr1)
        arr1.append(arr)
    }
    deinit {
        print("dealloc");
        print(CFGetRetainCount(self));
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
