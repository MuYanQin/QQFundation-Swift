//
//  QYPanelView.swift
//  QQFundation-Swift
//
//  Created by peanut on 2024/6/3.
//  Copyright © 2024 leaduadmin. All rights reserved.
//

import UIKit
import AVFoundation
enum StrokesType {
    case fill,strokes
}
class QYPanelView: UIImageView {
    var lineWidth:CGFloat?{
        willSet{
            self.mView.lineWidth = newValue!
        }
    }
    var lineColor:UIColor?{
        willSet{
            self.mView.lineColor = newValue!
        }
    }
    private let mView = QYMaskView()
    init(frame: CGRect ,image:UIImage) {
        super.init(frame: frame)
        self.image = image
        self.isUserInteractionEnabled = true
        self.contentMode = .scaleAspectFit
        self.mView.image = image
        self.mView.backgroundColor = .clear
        self.addSubview(self.mView)

    }
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.mView.frame = self.bounds

    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    internal required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func revoke() -> Void {//撤回
        mView.revoke()
    }
    func erase() -> Void {//擦除
        mView.erase()
    }
    func paint() -> Void {//绘画
        mView.paint()
    }
    func getImage(_ type:StrokesType) -> UIImage {
        UIGraphicsBeginImageContext(self.image!.size);
        let context = UIGraphicsGetCurrentContext()
        self.image?.draw(at: CGPointZero)
        for (_ ,strok) in mView.strokesArray.enumerated(){
            context?.setLineWidth(strok.lineWidth * 2)
            context?.setFillColor(UIColor.clear.cgColor)
            context?.setLineJoin(.round)
            context?.setBlendMode(CGBlendMode.clear)
            context?.beginPath()
            context?.addPath(strok.imgPath!)
            context?.drawPath(using: type == .strokes ? .stroke : .fillStroke)
 
        }
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
class QYMaskView: UIView {
    var strokesArray:Array<QYStrokes> = []
    var lineWidth:CGFloat = 1.0
    var lineColor:UIColor?
    var isEarse:Bool = false
    var image:UIImage?
    private var viewPath:CGMutablePath?
    private var imgPath:CGMutablePath?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        viewPath = CGMutablePath()
        imgPath = CGMutablePath()
        
        let strokes = QYStrokes()
        strokes.viewPath = viewPath
        strokes.imgPath = imgPath
        strokes.lineWidth = lineWidth
        strokes.lineColor = isEarse ?  .clear : lineColor
        strokes.blenModel = isEarse ?  .destinationIn:  .normal
        strokesArray.append(strokes)
        
        if let touch = touches.first {
            var point = touch.location(in: self)
            viewPath?.move(to: point)
            if let size = self.image?.size {
                touchPointInImage(size, &point)
                imgPath?.move(to: point)
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            var point = touch.location(in: self)
            viewPath?.addLine(to: point)
            if let size = self.image?.size {
                touchPointInImage(size, &point)
                imgPath?.addLine(to: point)
            }
            self.setNeedsDisplay()
        }
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        for (_,strokes) in strokesArray.enumerated(){
            context?.setStrokeColor(strokes.lineColor?.cgColor ?? UIColor.yellow.cgColor)
            context?.setLineWidth(strokes.lineWidth )
            context?.setLineJoin(.round)
            context?.setLineCap(.butt)
            context?.setBlendMode(strokes.blenModel!)
            context?.beginPath()
            context?.addPath(strokes.viewPath!)
            context?.strokePath()
        }
    }
    func touchPointInImage(_ imgSize:CGSize,_ touchPoint:inout CGPoint) -> Void {
        let imageRect: CGRect = AVMakeRect(aspectRatio: imgSize, insideRect: self.bounds)
        touchPoint.x -= imageRect.origin.x
        touchPoint.y -= imageRect.origin.y
        let wScale: CGFloat = imgSize.width / imageRect.size.width
        let hScale: CGFloat = imgSize.height / imageRect.size.height

        touchPoint.x *= wScale
        touchPoint.y *= hScale
    }
    
    func revoke() -> Void {
        isEarse = false
        if strokesArray.count > 0{
            strokesArray.removeLast()
        }
        setNeedsDisplay()
    }
    func erase() -> Void {
        isEarse = true
    }
    func paint() -> Void {
        isEarse = false
    }
}
