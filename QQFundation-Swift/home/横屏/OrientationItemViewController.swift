//
//  OrientationItemViewController.swift
//  QQFundation-Swift
//
//  Created by songping on 2023/5/5.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class OrientationItemViewController: QYBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        

        changWindowOrientation(.landscapeRight)

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        changWindowOrientation(.portrait)

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
