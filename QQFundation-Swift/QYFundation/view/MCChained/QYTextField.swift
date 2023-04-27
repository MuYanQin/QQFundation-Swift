//
//  QYTextField.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/4/8.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYTextField: UITextField ,UITextFieldDelegate{

    var textDidChange:((_ text:String) -> ())?

    var maxLength:Int = Int.max
    
    var openPriceCheck:Bool = false {
        didSet{
            if openPriceCheck{
                self.keyboardType = .decimalPad
            }
        }
    }
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            initialize()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            initialize()
        }
        
        func initialize() {
            delegate = self
            addTarget(self, action: #selector(ttt(_: )), for: .editingChanged)
        }
        
    @objc func ttt(_ textField:QYTextField) {
            if textDidChange != nil  {
                textDidChange!(textField.text ?? "")
            }
            
            if maxLength != Int.max {
                if textField.markedTextRange == nil{
                    if textField.text!.count > maxLength{
                        textField.text = "\(textField.text?.prefix(maxLength) ?? "")"
                    }
                }
            }
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if openPriceCheck {
                var str = textField.text ?? ""
                //拼接每一次输入的文字 。还有移动光标输入的文字
                str.insert(contentsOf: string, at: str.index(str.startIndex, offsetBy: range.location))
                // 匹配以 0 开头的数字
                let predicate0 = NSPredicate(format: "SELF MATCHES %@", "^[0][0-9]+$")
                // 匹配两位小数、整数
                let predicate1 = NSPredicate(format: "SELF MATCHES %@", "^(([1-9]{1}[0-9]*|[0]).?[0-9]{0,2})$")
                return !predicate0.evaluate(with: str) && predicate1.evaluate(with: str)
            }
            return true
        }
}
