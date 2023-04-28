//
//  QYSacnCodeViewController.swift
//  QQFundation-Swift
//
//  Created by songping on 2023/4/27.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit
import AVFoundation
class QYSacnCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate  {
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var qrCodeFrameViews: [UIView] = []
    
    lazy var scanLineView: UIImageView = {
        let _imgView  = UIImageView(image: UIImage(named: "scan_line"))
       _imgView.frame = CGRect(x: 0, y: -80, width: self.scanAreaView.frame.width, height: 80)
        return _imgView
    }()
    
    lazy var scanAreaView: UIView = {
        let _view = UIView(frame: CGRect(x: (kScreenWidth - 200) / 2 , y: (kScreenHeight - 200) / 2, width: 200, height: 200))
        _view.clipsToBounds = true
        return _view
    }()
    private let maskView = UIView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        //添加蒙层
        self.drawTransparentSquare()
        
        initSacn()


    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func initSacn() -> Void {
        
        // 在后台队列中执行耗时操作
        DispatchQueue.global(qos: .userInitiated).async {
            // 创建会话对象
            self.captureSession = AVCaptureSession()

            // 获取后置摄像头
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
            let videoInput: AVCaptureDeviceInput

            // 创建输入流
            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                return
            }

            // 将输入流添加到会话中
            if self.captureSession.canAddInput(videoInput) {
                self.captureSession.addInput(videoInput)
            } else {
                self.scanningNotPossible()
                return
            }
            
            // 创建元数据输出对象，并将其添加到会话中
            let metadataOutput = AVCaptureMetadataOutput()
            if self.captureSession.canAddOutput(metadataOutput) {
                self.captureSession.addOutput(metadataOutput)

                // 指定元数据类型（二维码和条码）
                metadataOutput.metadataObjectTypes = [.qr, .ean13, .ean8, .code128]

                // 设置代理，在主线程中处理元数据输出
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

            } else {
                self.scanningNotPossible()
                return
            }
            // 创建视频预览层，并将其添加到视图中
            self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.previewLayer.videoGravity = .resizeAspectFill
            // 更新 UI，并在主线程中执行
            DispatchQueue.main.async {
                self.previewLayer.frame = self.view.layer.bounds
                self.view.layer.addSublayer(self.previewLayer)
                // 添加扫描框视图
                self.view.addSubview(self.scanAreaView)

                // 创建扫描动画视图
                self.scanAreaView.addSubview(self.scanLineView)
                /**
                 在这行代码前面【 let rect = capturePreView!.metadataOutputRectConverted(fromLayerRect: self.interestRect)】
                 一定要先执行【captureSession?.startRunning()】
                 否则【metadataOutputRectConverted返回的rect是{0,0,0,0}】,这样就没办法捕捉到二维码信息了
                 */
                // 启动会话
                self.captureSession.startRunning()
                
                // 设置扫描区域（注：此处需要将rectOfInterest设置为摄像头采集到的图像中的相对位置，即x、y、width、height都在0到1之间）
                let rectOfInterest = self.previewLayer.metadataOutputRectConverted(fromLayerRect: self.scanAreaView.frame)
                metadataOutput.rectOfInterest = rectOfInterest
                
                // 创建扫描动画
                self.startAnimate()
                self.view.bringSubviewToFront(self.maskView)
            }
        }
  
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        qrCodeFrameViews.forEach { $0.removeFromSuperview() }
        qrCodeFrameViews.removeAll()

        // 如果没有元数据对象，直接返回
        if metadataObjects.isEmpty {
            return
        }

        // 获取元数据对象
        for metadataObj in metadataObjects {
            guard let readableObject = metadataObj as? AVMetadataMachineReadableCodeObject else { continue }

            // 获取二维码或条码的边界
            let barcodeObject = previewLayer.transformedMetadataObject(for: readableObject)

            if let qrCodeString = readableObject.stringValue {
                print("QR Code / Barcode String Value: \(qrCodeString)")
                // 给每个二维码或条码打上标记
                let qrCodeFrameView = UIButton(type: .custom)
                qrCodeFrameView.backgroundColor = UIColor.green
                qrCodeFrameView.layer.cornerRadius = 18
                qrCodeFrameView.frame.origin.x = barcodeObject!.bounds.origin.x + ( barcodeObject!.bounds.size.width / 4)
                qrCodeFrameView.frame.origin.y = barcodeObject!.bounds.origin.y + ( barcodeObject!.bounds.size.height / 4)
                qrCodeFrameView.frame.size = CGSizeMake(36, 36)
                previewLayer.addSublayer(qrCodeFrameView.layer)
                qrCodeFrameViews.append(qrCodeFrameView)
            }
        }
        
        captureSession.stopRunning()
        endAnimate()
    }

    func scanningNotPossible() {
        let alert = UIAlertController(title: "Scanning not possible", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        captureSession.commitConfiguration()
    }
    func startAnimate() -> Void {
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [ .repeat, .curveEaseInOut], animations: {
            self.scanLineView.isHidden = false
            self.scanLineView.transform = CGAffineTransform(translationX: 0.0, y: self.scanAreaView.frame.height)
        }, completion: nil)
    }
    func endAnimate() -> Void {
        UIView.animate(withDuration: 0.0, delay: 0.0, options: [], animations: {
            self.scanLineView.transform = CGAffineTransform.identity
            self.scanLineView.isHidden = true
        }, completion: nil)
    }
    /// 绘制蒙层
    /// - Parameters:
    ///   - view: 需要绘制的view
    ///   - size: 大小
    func drawTransparentSquare() {
        
        maskView.frame = view.bounds
        maskView.backgroundColor = UIColor.clear
        maskView.alpha = 0.5
        view.addSubview(maskView)
        
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: view.q_width, height: view.q_height))
        
        let layerBounds = view.layer.bounds
        let transparentRect = CGRect(x: layerBounds.midX - 200 / 2,
                                     y: layerBounds.midY - 200 / 2,
                                     width: 200,
                                     height: 200)

        let transparentPath = UIBezierPath(rect: transparentRect)
        path.append(transparentPath)
        path.usesEvenOddFillRule = true
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillRule = CAShapeLayerFillRule.evenOdd
        layer.fillColor = UIColor.black.cgColor
        layer.opacity = 0.5
        maskView.layer.addSublayer(layer)
    }

}
