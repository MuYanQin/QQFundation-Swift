//
//  QYButton.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/3/13.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit



class QYButton: UIButton {

    var info: Any?
    
    var imageSize: CGSize?
    
    var gapBetweenTI: CGFloat = 5
    
    var position :Position = .none
    
    private var timer:DispatchSourceTimer?
    
    static func getButton() -> QYButton {
        return QYButton.init(type: .custom)
    }
    
    
    @objc override func qinfo(_ item :Any) -> UIButton {
        self.info = item
        return self
    }
    
    override func qtextPosition(_ item: Position) -> UIButton {
        self.position = item
        return self
    }
    
    override func qimageSize(_ item :CGSize) -> QYButton {
        self.imageSize = item
        return self
    }
    
    override func qgapBetweenTI(_ item :CGFloat) -> QYButton {
        self.gapBetweenTI = item
        return self
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        buildTextP(positoin: self.position)
    }
    
    func buildTextP(positoin:Position) -> Void {
        self.titleLabel!.numberOfLines = 0
        let lwidth = (self.titleLabel?.sizeThatFits(CGSize.init(width: 0, height: 0)).width)!
        
        let lheight = (self.titleLabel?.sizeThatFits(CGSize.init(width: 0, height: 0)).height)!
        
        var imageWith :CGFloat = 0
        var imageHeight :CGFloat = 0
        if self.imageSize != nil {
            imageWith = self.imageSize!.width
            imageHeight = self.imageSize!.height
            self.imageView?.frame.size = self.imageSize!
            
            self.imageView?.frame.origin = CGPointMake((self.q_width - imageWith) / 2, (self.q_height - imageHeight)/2)
        }else{
            imageWith = self.q_width/3;
            imageHeight = self.q_height/3;
        }
        var  total =  imageWith + lwidth + self.gapBetweenTI
        
        var imagex = (self.q_width - total)/2
        var imagey = (self.q_height - imageHeight)/2
        

        //MARK:文字在右
        if positoin == .right{
            self.titleLabel!.textAlignment = .left
            self.imageView?.frame = CGRect.init(x: imagex, y: imagey, width: imageWith, height: imageHeight)
            self.titleLabel?.frame = CGRect.init(x: (imagex + self.gapBetweenTI + imageWith), y: imagey, width: lwidth, height: imageHeight)
        }else if (positoin == .left){
            self.titleLabel!.textAlignment = .right
            self.titleLabel?.frame = CGRect.init(x: imagex, y: imagey, width: lwidth, height: imageHeight)
            self.imageView?.frame = CGRect.init(x: (imagex + self.gapBetweenTI + lwidth), y: imagey, width: lwidth, height: imageHeight)
            
        }else if (positoin == .top){
            self.titleLabel!.textAlignment = .center
            total = imageHeight + lheight + self.gapBetweenTI
            let labely = (self.q_height - total)/2
            let labelx = (self.q_width - lwidth)/2
            imagex = (self.q_width - imageWith)/2
            
            self.titleLabel?.frame = CGRect(x: labelx, y: labely, width: lwidth, height: lheight)
   
            self.imageView?.frame = CGRect(x: imagex, y: labely + lheight + self.gapBetweenTI, width: imageWith, height: imageHeight)
        }else if (positoin == .bottom){
            self.titleLabel!.textAlignment = .center
            total = imageHeight + lheight + self.gapBetweenTI
            imagey = (self.q_height - total)/2
            imagex = (self.q_width - imageWith)/2
            let labelx = (self.q_width - lwidth)/2
            
            self.imageView?.frame = CGRect(x: imagex, y: imagey, width: imageWith, height: imageHeight)
            self.titleLabel?.frame = CGRect(x: labelx, y: imagey + imageHeight + self.gapBetweenTI, width: lwidth, height: lheight)

        }
    }
    
    func startCountdown() {
        var timeOut = 60
        let queue = DispatchQueue.global(qos: .default)
        self.timer = DispatchSource.makeTimerSource(queue: queue)
        // 每秒执行一次
        self.timer?.schedule(deadline: DispatchTime.now(), repeating: 1.0, leeway: .milliseconds(10))
        self.timer?.setEventHandler(handler: {
            // 倒计时结束，关闭
            if timeOut <= 0 {
                self.timer?.cancel()
                DispatchQueue.main.async {
                    self.setTitle("点击重新获取验证码", for: .normal)
                    self.isUserInteractionEnabled = true
                }
            } else {
                let seconds = timeOut % 61
                let timeStr = String(format: "%02d", seconds)
                DispatchQueue.main.async {
                    self.setTitle(timeStr + "S", for: .normal)
                    self.isUserInteractionEnabled = false
                }
                timeOut -= 1
            }
        })
        self.timer?.resume()
    }
    
    func resetCountdown() {
        self.timer?.cancel()
        DispatchQueue.main.async {
            self.setTitle("点击重新获取", for: .normal)
            self.isUserInteractionEnabled = true
        }
    }


}
