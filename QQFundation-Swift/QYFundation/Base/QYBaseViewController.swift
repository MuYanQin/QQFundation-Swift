//
//  QYBaseViewController.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/24.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit
import SnapKit
class QYBaseViewController: UIViewController ,QQTableViewDelegate{
    
    var layout : (() -> (UICollectionViewLayout))?
    
    //懒加载父类tableview视图管理器
    lazy var tableManager: QQTableViewManager = { () -> QQTableViewManager in
        self.view.addSubview(self.baseTableView);
        var manager = QQTableViewManager(tableView: self.baseTableView);
        return manager;
    }()
    
    //懒加载父类基础tablebview
    lazy var baseTableView: QQTableView = { () -> QQTableView in
        var tableView = QQTableView(frame: CGRect(x: 0, y: UIDevice.navigationFullHeight(), width: kScreenWidth, height: kScreenHeight - UIDevice.navigationFullHeight() - UIDevice.safeDistanceBottom()),style: UITableView.Style.plain);
        tableView.qdelegate = self;
        return tableView;
    }()
    
    lazy var collectManager: QYCollectionViewManager = {
        let manager = QYCollectionViewManager(collectionView: collectionView)
        self.view.addSubview(collectionView);
        return manager
    }()
    
    lazy var collectionView: QYCollectionView = {
        let out = self.layout?() ?? UICollectionViewFlowLayout()
        let col = QYCollectionView(frame: CGRect(x: 0, y: UIDevice.navigationFullHeight(), width: kScreenWidth, height: kScreenHeight - UIDevice.navigationFullHeight()), collectionViewLayout: out)
        col.backgroundColor = UIColor.white
        return col
    }()
    
    
    //懒加载父类基础数组给tableview视图的数据源使用
    lazy var baseArray = Array<QQTableViewSection>();
    
    lazy var baseColArray = Array<QYCollectionViewSection>();
    var backButton :QYButton?
    var titleLb:UILabel?
    lazy var navBar: UIView = {
        let bar = UIView()
        bar.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: QYNavHeight)
        bar.backgroundColor = UIColor.clear
        
        backButton = QYButton(type: .custom)
        backButton?.backgroundColor = UIColor.white
        backButton?.layer.cornerRadius = 18
        backButton?.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        bar.addSubview(backButton!)

        let img = UIImageView(image: UIImage(named: "arrow_right"))
        backButton?.addSubview(img)
        
        backButton?.snp.makeConstraints({ make in
            make.left.equalTo(bar).offset(8)
            make.centerY.equalTo(bar).offset(11)
            make.size.equalTo(CGSize(width: 36, height: 36))
        })
        
        img.snp.makeConstraints({ make in
            make.centerX.centerY.equalTo(backButton!)
            make.size.equalTo(CGSize(width: 20, height: 20))
        })
        
        titleLb = UILabel.getLabel().qfont(18).qtext(self.title ?? "").qtextColor(UIColor.clear)
        bar.addSubview(titleLb!)
        
        titleLb?.snp.makeConstraints({ make in
            make.centerY.equalTo(backButton!)
            make.centerX.equalTo(bar)
        })
        
        return bar
    }()
    func navAlpha(_ alpha: CGFloat) {
        if #available(iOS 13.0, *) {
            guard let color = navigationController?.navigationBar.standardAppearance.backgroundColor else { return  }
            navBar.backgroundColor = color.withAlphaComponent(alpha)

            backButton?.backgroundColor = UIColor.white.withAlphaComponent(1 - alpha)
        } else {
            guard let color = navigationController?.navigationBar.barTintColor else { return  }
            navBar.backgroundColor = color.withAlphaComponent(alpha)
            backButton?.backgroundColor = UIColor.white.withAlphaComponent(1 - alpha)
        }


        guard let attributes = navigationController?.navigationBar.titleTextAttributes else { return  }
        guard let titlecColor = attributes[NSAttributedString.Key.foregroundColor] as? UIColor else { return  }
        titleLb?.textColor = titlecColor.withAlphaComponent(alpha)
        
    }

    @objc func backClick(){
        self.navigationController?.popViewController(animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        if #available(iOS 13.0, *) {
            return UIStatusBarStyle.darkContent
        } else {
            return UIStatusBarStyle.default;
        };
    }
    
    deinit {
        print("dealloc" + "\(self)");
    }
    /// 直接修改系统naviBar的话 在手势返回的时候有些情况不好处理 直接隐藏自定义最好
    func modifyNaviColorOpacity(_ alpha:CGFloat) -> Void {
        if #available(iOS 13 , *){
            guard let appearance = self.navigationController?.navigationBar.standardAppearance else { return  }
            guard let color = appearance.backgroundColor else { return  }
            appearance.backgroundColor = color.withAlphaComponent((alpha > 1 ? 1 :alpha))
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            guard let titlecColor = appearance.titleTextAttributes[NSAttributedString.Key.foregroundColor] as? UIColor else { return  }
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: titlecColor.withAlphaComponent(alpha)]
        }else{
            guard let color = navigationController?.navigationBar.barTintColor else { return  }
            navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color.withAlphaComponent(alpha > 1 ? 1 :alpha))
            navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color.withAlphaComponent(alpha > 1 ? 1 :alpha)), for: .default)
            
            guard let attributes = navigationController?.navigationBar.titleTextAttributes else { return  }
            guard let titlecColor = attributes[NSAttributedString.Key.foregroundColor] as? UIColor else { return  }
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:titlecColor.withAlphaComponent(alpha > 1 ? 1 :alpha)];
        }
    }
    
    func changWindowOrientation(_ orientation:UIInterfaceOrientationMask) -> Void{
        if #available(iOS 16.0 , *){
            //在视图控制器中，获取窗口场景。
            guard let windowScene = view.window?.windowScene else { return }
            //windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight))
            //（同上） 请求窗口场景旋转到任何景观方向。
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations:   orientation)) { error in
                print("---requestGeometryUpdate 处理拒绝请求 \n\n")
            }
          //处理横屏View布局...
        }else{

            switch orientation {
            case .portrait:
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")

                break
            case .landscapeLeft:
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")

                break
            case .landscapeRight:
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")

                break

            default:
                break
            }
        }
    }
    

}


extension UIViewController{
    
    /// nav右边添加图片按钮
    /// - Parameters:
    ///   - imgName: 图片名称
    ///   - self: 方法
    /// - Returns: 无
    func nav_rightImgItem(_ imgName:String,_ sel:Selector) -> Void {
        let rightCustomButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30));
        rightCustomButton.widthAnchor.constraint(equalToConstant: 20).isActive = true;
        rightCustomButton.heightAnchor.constraint(equalToConstant: 20).isActive = true;
        rightCustomButton.addTarget(self, action: sel, for: UIControl.Event.touchUpInside);
        rightCustomButton.setImage(UIImage(named: imgName), for: UIControl.State.normal);
        rightCustomButton.setImage(UIImage(named: imgName), for: UIControl.State.highlighted);
        let rightItem = UIBarButtonItem.init(customView: rightCustomButton);
        self.navigationItem.rightBarButtonItem = rightItem;
        
    }
    
    /// nav右边添加文字按钮
    /// - Parameters:
    ///   - title: 文字
    ///   - color: 文字颜色
    ///   - font: 文字大小字体
    ///   - sel: 方法
    /// - Returns: 无
    func nav_rightStrItem(_ title:String,_ sel:Selector,_ color:UIColor? = UIColor.black,_ font:UIFont? = UIFont.systemFont(ofSize: 14)) -> Void {

        let rightItem = UIBarButtonItem(title: title, style:UIBarButtonItem.Style.plain , target: self, action: sel)
        let dic = [NSAttributedString.Key.foregroundColor:color,NSAttributedString.Key.font:font];
        rightItem .setTitleTextAttributes(dic as [NSAttributedString.Key : Any], for: UIControl.State.normal);
        rightItem .setTitleTextAttributes(dic as [NSAttributedString.Key : Any], for: UIControl.State.highlighted);
        self.navigationItem.rightBarButtonItem = rightItem;
    }
 
    
}
