//
//  QYCommentView.swift
//  QQFundation-Swift
//
//  Created by songping on 2023/4/27.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYCommentView: UIView ,UITextViewDelegate {

    // 监听容器高度(包含监听键盘)
    var containerWillChangeFrameBlock: ((CGFloat) -> Void)?
    // 评论文本
    var completeInputTextBlock: ((String) -> Void)?
    // 容器高度
    var ctTop: CGFloat = 0

    
    let containMinHeight: CGFloat = 50

    let btnWitdh: CGFloat = 80
    // 容器最大高度
    let containMaxHeight: CGFloat = 120
    // 容器减去输入框的高度
    let marginHeight: CGFloat = 15
    
    // 容器视图
    var containView = UIView()
    // 输入框
    var textView = UITextView()
    // 表情按钮
    var emoticonBtn = UIButton()
    // 记录容器高度
    var ctHeight: CGFloat = 0
    // 记录上一次容器高度
    var previousCtHeight: CGFloat = 0
    // 键盘高度
    var keyboardHeight: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 容器视图
        let view = UIView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: containMinHeight))
        view.backgroundColor = RGB(r: 248, g: 248, b: 248)
        addSubview(view)
        self.containView = view
        // -- 分割线
        let layer = CALayer()
        layer.backgroundColor = RGB(r: 230, g: 230, b: 230).cgColor
        layer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 0.5)
        view.layer.addSublayer(layer)
        
        // 行间距
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        // attributes
        let textAttributes:[NSAttributedString.Key: Any] = [NSAttributedString.Key.paragraphStyle:style, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]
        // 输入框
        let textView = UITextView(frame: CGRect(x: 15, y: marginHeight/2.0, width: kScreenWidth - (btnWitdh + 15), height: containMinHeight - marginHeight))
        textView.backgroundColor = UIColor.white
        textView.enablesReturnKeyAutomatically = true
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.returnKeyType = .send
        textView.layer.cornerRadius = 4
        textView.layer.masksToBounds = true
        textView.font = UIFont.systemFont(ofSize: 16.0)
        textView.textContainerInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        textView.typingAttributes = textAttributes

        textView.delegate = self
        textView.textColor = UIColor.black
        containView.addSubview(textView)
        self.textView = textView
        
        // 表情按钮
        let btn = UIButton(frame: CGRect(x: kScreenWidth - btnWitdh + 7, y: marginHeight/2, width: btnWitdh - 15, height: containMinHeight - marginHeight))
        btn.backgroundColor = RGB(r: 248, g: 220, b: 61)
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.setTitle("发送", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(sendMsg), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        containView.addSubview(btn)
        self.emoticonBtn = btn
        
        self.ctTop = 0
        self.keyboardHeight = 0
        self.ctHeight = 0
        self.previousCtHeight = 0
        // 键盘监听
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - 键盘监听
    @objc func keyboardFrameChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.25
        let options = UIView.AnimationOptions(rawValue: (UInt((userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSInteger ?? 0)) << 16) | UIView.AnimationOptions.beginFromCurrentState.rawValue)

        // 键盘高度
        var keyboardH: CGFloat = 0
        if endFrame.origin.y == UIScreen.main.bounds.height { // 弹下
            keyboardH = 0
        } else {
            keyboardH = endFrame.size.height
        }
        self.keyboardHeight = keyboardH

        // 容器的top
        var top: CGFloat = 0
        if keyboardH > 0 {
            top = kScreenHeight - self.containView.q_height - self.keyboardHeight
        } else {
            top = kScreenHeight
        }
        self.ctTop = top

        // 动画
        UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: {
            self.containView.q_top = top
        }, completion: {[weak self] finished in
            guard let self = self else { return }
            if keyboardH == 0 {
                self.textView.text = nil
                self.removeFromSuperview()
            }
        })

        // 监听键盘高度
        if let block = self.containerWillChangeFrameBlock {
            block(self.keyboardHeight)
        }
    }

    // MARK: - 更新容器高度
    func containViewDidChange(ctHeight: CGFloat) {
        var ctHeight = ctHeight + marginHeight
        if ctHeight < containMinHeight || self.textView.attributedText.length == 0{
            ctHeight = containMinHeight
        }

        self.textView.isScrollEnabled = false
        if ctHeight > containMaxHeight {
            ctHeight = containMaxHeight
            self.textView.isScrollEnabled = true
        }

        if ctHeight == self.previousCtHeight {
            return
        }

        self.previousCtHeight = ctHeight
        self.ctHeight = ctHeight
        self.ctTop = kScreenHeight - ctHeight - self.keyboardHeight

        // 更新UI
        UIView.animate(withDuration: 0.25) {[weak self] in
            guard let self = self else { return }
            // 容器
            self.containView.q_height = ctHeight
            self.containView.q_top = self.ctTop
            // 输入框
            self.textView.q_height = ctHeight - self.marginHeight
            // 表情按钮
            self.emoticonBtn.q_top = ctHeight - self.emoticonBtn.q_height - self.marginHeight/2
        }

        // 监听容器高度
        if let block = self.containerWillChangeFrameBlock {
            block(self.keyboardHeight)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        containViewDidChange(ctHeight: textView.sizeThatFits(CGSize(width: kScreenWidth - (btnWitdh + 15), height: 0)).height)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" { // 回车
            // 监听输入文本
            if let completeBlock = self.completeInputTextBlock {
                completeBlock(textView.text)
            }
            textView.text = ""
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    @objc func sendMsg() {
        /*
        if let completeBlock = self.completeInputTextBlock {
            completeBlock(self.textView.text)
        }
        self.textView.text = ""
        self.textView.resignFirstResponder()
         */
    }

    // MARK: - UIResponder
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let currentPoint = touch?.location(in: self.superview)
        if let point = currentPoint, self.containView.frame.contains(point) == false {
            self.textView.resignFirstResponder()
        }
    }

    // MARK: - 显示
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        self.textView.becomeFirstResponder()
    }

    // MARK: -
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
