//
//  QYAlertViewController.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/4/14.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit

class QYAlertViewController: UIViewController ,UIViewControllerTransitioningDelegate{
    lazy var aletView: UIView = {
        let _alertView = UIView(frame: CGRect(x: (self.view.q_width - 270)/2, y: (self.view.q_height - 110)/2, width: 270, height: 110))
        _alertView.backgroundColor = UIColor.white
        _alertView.layer.cornerRadius = 5
        _alertView.layer.masksToBounds = true

        return _alertView
    }()
    var isTouchHidden = false
    var titleText:String? = "提示"
    var cancelText:String? = "取消"
    var sureText:String? = "确定"
    var descText:String? = ""
    var buttonAction:((Int) -> Void)?
    
    lazy var titleLabel: UILabel = {
        let _titleLabel = UILabel()
        _titleLabel.textColor = UIColor.black
        _titleLabel.font = UIFont.systemFont(ofSize: 15)
        _titleLabel.textAlignment = .center
        _titleLabel.numberOfLines = 0

        return _titleLabel
    }()
    lazy var descriptionLabel: UILabel = {
        let _descriptionLabel = UILabel()
        _descriptionLabel.textColor = UIColor.lightGray
        _descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        _descriptionLabel.textAlignment = .center
        _descriptionLabel.numberOfLines = 0
        return _descriptionLabel
    }()
    lazy var cancelButton: UIButton = {
        let _cancelButton = UIButton(type: .custom)
        _cancelButton.setTitleColor(UIColor.black, for: .normal)
        _cancelButton.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        _cancelButton.backgroundColor = UIColor.cyan

        return _cancelButton
    }()
    lazy var sureButton: UIButton = {
        let  _button = UIButton(type: .custom)
        _button.setTitleColor(UIColor.white, for: .normal)
        _button.addTarget(self, action: #selector(sureClick), for: .touchUpInside)
        _button.backgroundColor = UIColor.yellow

        return _button
    }()
    
    class func alertController(withTitle title: String?, descText: String?, cancel: String?, button: String?, action buttonAction: ((Int) -> Void)?) -> QYAlertViewController {
        assert(title?.count ?? 0 > 0 || descText?.count ?? 0 > 0, "title和description不能同时为空")
        
        let alert = QYAlertViewController()
        alert.transitioningDelegate = alert
        alert.modalPresentationStyle = .custom
        alert.titleText = title
        alert.descText = descText
        alert.cancelText = cancel ?? "取消"
        alert.sureText = button
        alert.buttonAction = buttonAction
        
        return alert
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isTouchHidden{
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick))
            self.view.addGestureRecognizer(tap)
        }
        self.view.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        initUI()
    }
    func initUI() -> Void {
        self.view.addSubview(aletView)
        aletView.addSubview(titleLabel)
        aletView.addSubview(descriptionLabel)
        aletView.addSubview(cancelButton)
        aletView.addSubview(sureButton)
        
        self.titleLabel.text = self.titleText
        self.descriptionLabel.text = self.descText
        self.cancelButton.setTitle(self.cancelText, for: .normal)
        self.sureButton.setTitle(self.sureText, for: .normal)

        let titleHeight = self.titleLabel.sizeThatFits(CGSize(width: 230, height: 0)).height
        let descHeight = self.descriptionLabel.sizeThatFits(CGSize(width: 230, height: 0)).height
        var offset: CGFloat = 0.0 // 内容偏移量
        if titleHeight == 0.0 {
            offset = -20
        }
        if descHeight == 0.0 {
            offset += -25
        }
        self.titleLabel.frame = CGRect(x: 20, y: 35, width: 230, height: titleHeight)
        self.descriptionLabel.frame = CGRect(x: 20, y: self.titleLabel.q_bottom + 20 + offset, width: 230, height: descHeight)
        self.cancelButton.frame = CGRect(x: 20, y: self.descriptionLabel.q_bottom + 25, width: 107, height: 40)
        self.sureButton.frame = CGRect(x: self.cancelButton.q_right + 15, y: self.descriptionLabel.q_bottom + 25, width: 107, height: 40)

        let alertHeight = 35 + titleHeight + 20 + descHeight + 25 + 40 + 30 + offset
        self.aletView.frame = CGRect(x: (self.view.q_width - 270)/2, y: (self.view.q_height - alertHeight)/2, width: 270, height: alertHeight)

        
    }
    @objc func tapClick(){
        self.dismiss(animated: true)
    }
    @objc func cancelClick(){
        if cancelText == "取消"{
            self.dismiss(animated: true)
        }else{
            if buttonAction != nil {
                buttonAction!(1)
            }
        }
    }
    @objc func sureClick(){
        if buttonAction != nil {
            buttonAction!(0)
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return defaultAnimation()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return defaultAnimation()
    }

}

class defaultAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3;
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to)  else { return  }
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return  }
        
  
        let containerView = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)
        if toVC.isBeingPresented {
            containerView.addSubview(toVC.view)
            toVC.view.frame = CGRect(x: 0.0, y: 0.0, width: containerView.frame.size.width, height: containerView.frame.size.height)
            UIView.animate(withDuration: duration, animations: {
                
            }) { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        } else if fromVC.isBeingDismissed {
            UIView.animate(withDuration: duration, animations: {
                fromVC.view.alpha = 0.0
            }) { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
    
    
}
