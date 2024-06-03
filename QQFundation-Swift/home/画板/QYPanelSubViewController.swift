//
//  QYPanelSubViewController.swift
//  QQFundation-Swift
//
//  Created by peanut on 2024/6/3.
//  Copyright © 2024 leaduadmin. All rights reserved.
//

import UIKit

class QYPanelSubViewController: QYBaseViewController {
    var image:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let imagev = UIImageView()
        imagev.image = self.image!
        self.view.addSubview(imagev)
        imagev.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
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
