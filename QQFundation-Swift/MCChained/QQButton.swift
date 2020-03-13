//
//  QQButton.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/3/13.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit



class QQButton: UIButton {

    var info: Any?
    
    var imageSize: CGSize?
    
    var gapBetweenTI: CGFloat = 5
    
    var position: Position?
    
    @objc override func qinfo(item :Any) -> UIButton {
        self.info = item
        return self
    }
    
    override func qtextPosition(item: Position) -> UIButton {
        self.position = item
        return self
    }
    
    override func qimageSize(item :CGSize) -> QQButton {
        self.imageSize = item
        return self
    }
    
    override func qgapBetweenTI(item :CGFloat) -> QQButton {
        self.gapBetweenTI = item
        return self
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        buildTextP(positoin: self.position!)
    }
    
    func buildTextP(positoin:Position) -> Void {
        self.titleLabel!.backgroundColor = UIColor.white
        self.titleLabel!.numberOfLines = 0
        let lwidth = self.titleLabel?.sizeThatFits(CGSize.init(width: 0, height: 0)).width
        
        let lheight = self.titleLabel?.sizeThatFits(CGSize.init(width: 0, height: 0)).height
        
        var imageWith :CGFloat = 0
        var imageHeight :CGFloat = 0
        if self.imageSize != nil {
            imageWith = self.imageSize!.width
            imageHeight = self.imageSize!.height
        }else{
            imageWith = self.width!/3;
            imageHeight = self.height!/3;
        }
        
        let total = imageWith + lwidth! + self.gapBetweenTI
        let imagex = (self.width! - total)/2
        let imagey = (self.height! - imageHeight)/2
        //MARK:文字在右
        if positoin == .right{
            self.titleLabel!.textAlignment = .left
            self.imageView?.frame = CGRect.init(x: imagex, y: imagey, width: imageWith, height: imageHeight)
            self.titleLabel?.frame = CGRect.init(x: (imagex + self.gapBetweenTI + imageWith), y: imagey, width: lwidth!, height: imageHeight)
        }else if (positoin == .left){
            self.titleLabel!.textAlignment = .right
            self.titleLabel?.frame = CGRect.init(x: imagex, y: imagey, width: lwidth!, height: imageHeight)
            self.imageView?.frame = CGRect.init(x: (imagex + self.gapBetweenTI + lwidth!), y: imagey, width: lwidth!, height: imageHeight)
            
        }else if (positoin == .top){
            self.titleLabel!.textAlignment = .center
            let total = imageHeight + lheight! + self.gapBetweenTI
            let imagey = (self.height! - total)/2
            
            self.titleLabel?.center.x = self.center.x;
            self.titleLabel?.width = self.width
            self.titleLabel?.height = lheight
            self.titleLabel?.top = imagey
            
            self.imageView?.center.x = self.center.x;
            self.imageView?.width = imageWith
            self.imageView?.height = imageHeight
            self.imageView?.top = self.titleLabel!.bottom! + self.gapBetweenTI
        }else if (positoin == .bottom){
            self.titleLabel!.textAlignment = .center
            
            self.titleLabel!.textAlignment = .center
            let total = imageHeight + lheight! + self.gapBetweenTI
            let imagey = (self.height! - total)/2
            
            self.imageView?.center.x = self.center.x;
            self.imageView?.width = imageWith
            self.imageView?.height = imageHeight
            self.imageView?.top =  imagey
            
            self.titleLabel?.center.x = self.center.x;
            self.titleLabel?.width = self.width
            self.titleLabel?.height = lheight
            self.titleLabel?.top = self.imageView!.bottom! + self.gapBetweenTI
            

        }
    }
}
