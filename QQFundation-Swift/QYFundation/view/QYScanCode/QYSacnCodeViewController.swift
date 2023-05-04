//
//  QYSacnCodeViewController.swift
//  QQFundation-Swift
//
//  Created by songping on 2023/4/27.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
enum ScanArea {
    case full,part
}

protocol QYSacnCodeDelegate:NSObjectProtocol {
    func scanCodeResult(_ text:String)
}
 

class QYSacnCodeViewController: QYBaseViewController, AVCaptureMetadataOutputObjectsDelegate,QYBaseNavHiddenDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func needHiddenNav() -> UIViewController {
        return self
    }
    
    weak var delegate:QYSacnCodeDelegate?
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var qrCodeFrameViews: [UIView] = []
    private let backBtn = QYButton(type: .custom)
    lazy var imagePicker: RXImagePickerController = {
        let _imagePicker = RXImagePickerController()


        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.red]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.red]
            navBarAppearance.backgroundColor = UIColor.blue
  
            UINavigationBar.appearance().tintColor = .cyan
            UINavigationBar.appearance().barTintColor = .red
            UINavigationBar.appearance().backgroundColor = .red
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().standardAppearance = navBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
            //ios 13以后 无法更改样式 只能自定义 https://www.likecs.com/ask-1014525.html
            // 接下来设置其他属性并打开图片选择器界面
        }
        else{
            _imagePicker.navigationBar.barTintColor = self.navigationController?.navigationBar.barTintColor
            _imagePicker.navigationBar.tintColor = self.navigationController?.navigationBar.tintColor
            _imagePicker.navigationBar.titleTextAttributes = self.navigationController?.navigationBar.titleTextAttributes
            _imagePicker.navigationBar.backIndicatorImage = self.navigationController?.navigationBar.backIndicatorImage
            _imagePicker.navigationBar.backIndicatorTransitionMaskImage = self.navigationController?.navigationBar.backIndicatorImage
            let item  = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UIImagePickerController.self])
            item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)], for: .normal)
            item.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical:1), for: .default)
        }
        _imagePicker.delegate = self
        _imagePicker.allowsEditing = false
        _imagePicker.modalPresentationStyle =  .fullScreen
        _imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        return _imagePicker
    }()

    var scanArea :ScanArea = .full
    /// 扫描区域大小
    var scanSize:CGSize = CGSizeMake(200, 200)
    lazy var scanLineView: UIImageView = {
        let _imgView  = UIImageView(image: UIImage(named: "scan_line"))
       _imgView.frame = CGRect(x: 0, y: -80, width: self.scanAreaView.frame.width, height: 80)
        return _imgView
    }()
    
    lazy var scanAreaView: UIView = {
        let _view = UIView(frame: CGRect(x: (kScreenWidth - scanSize.width) / 2 , y: (kScreenHeight - scanSize.height) / 2, width: scanSize.width, height: scanSize.height))
        _view.clipsToBounds = true
        return _view
    }()
    private let maskView = UIView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let nav = self.navigationController as? QYBaseNavViewController else { return  }
        nav.navHiddenDelegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let nav = self.navigationController as? QYBaseNavViewController else { return  }
        nav.navHiddenDelegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
//        authenticationCamera();
        authenticationPhoto()
    }

    func authenticationCamera() -> Void {
        let authorStatu = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authorStatu {

        case .authorized://授权
            if self.scanArea == .part{
                //添加蒙层
                self.drawTransparentSquare()
            }
            self.initSacn()
            break
        case .notDetermined://未知
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { statu in
                if statu{
                    self.authenticationCamera();
                }
            }
            break
        case .denied,.restricted://拒绝
            self.showPromptText(false)
            break
        default:
            break
        }
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
                if self.scanArea == .part{
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
                }else{
                    // 启动会话
                    DispatchQueue.global(qos: .background).async {
                        self.captureSession.startRunning()
                    }
                }
                
                //返回按钮
                self.backBtn.frame = CGRectMake(20, QYStatusBarHeight + 7 , 40, 40)
                _ = self.backBtn.qimageState("back", .normal).qimageSize(CGSizeMake(30, 30))
                self.backBtn.addTarget(self, action: #selector(self.backClick3), for: .touchUpInside)
                self.view.addSubview(self.backBtn)
                
                //相册按钮
                let btn = UIButton(type: .custom)
                btn.frame = CGRectMake(kScreenWidth  - 80, kScreenHeight - 100, 60, 60)
                btn.layer.cornerRadius = 30
                btn.backgroundColor = UIColor.purple
                btn.addTarget(self, action: #selector(self.selectImag), for: .touchUpInside)
                self.view.addSubview(btn)
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
        if metadataObjects.count > 1{
            let view = UIView()
            view.frame = self.view.bounds
            view.backgroundColor = UIColor.black
            view.alpha = 0.5
            self.view.addSubview(view)
            qrCodeFrameViews.append(view)
            self.view.bringSubviewToFront(self.backBtn)
        }
        
        // 获取元数据对象
        for metadataObj in metadataObjects {
            guard let readableObject = metadataObj as? AVMetadataMachineReadableCodeObject else { continue }

            // 获取二维码或条码的边界
            let barcodeObject = previewLayer.transformedMetadataObject(for: readableObject)
            
            if let qrCodeString = readableObject.stringValue {
                
                if metadataObjects.count == 1{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.navigationController?.popViewController(animated: true)
                        self.delegate?.scanCodeResult(qrCodeString)
                    }
                }
                
                // 给每个二维码或条码打上标记
                let qrCodeFrameView = ScaledButton(type: .custom)
                qrCodeFrameView.backgroundColor = RGB(r: 86, g: 176, b: 100)
                qrCodeFrameView.layer.cornerRadius = 18
                qrCodeFrameView.layer.borderColor = UIColor.white.cgColor
                qrCodeFrameView.layer.borderWidth = 3
                _ = qrCodeFrameView.qinfo(qrCodeString)
                qrCodeFrameView.setImage(UIImage(named: "sacnCode_right"), for: .normal)
                qrCodeFrameView.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom:10, right: 10)
                qrCodeFrameView.frame.origin.x = barcodeObject!.bounds.origin.x + ( barcodeObject!.bounds.size.width / 4)
                qrCodeFrameView.frame.origin.y = barcodeObject!.bounds.origin.y + ( barcodeObject!.bounds.size.height / 4)
                qrCodeFrameView.frame.size = CGSizeMake(36, 36)
                qrCodeFrameView.addTarget(self, action: #selector(selectedDot(_ :)), for: .touchUpInside)
                self.view.addSubview(qrCodeFrameView)
                qrCodeFrameViews.append(qrCodeFrameView)
            }
        }
        if scanArea == .full{
            _ = backBtn.qtext("取消").qimageState("", .normal).isSelected = true
        }
        captureSession.stopRunning()
        endAnimate()
        dotStartAnimate()
    }

    func scanningNotPossible() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Scanning not possible", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            self.captureSession.commitConfiguration()
        }

    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            self.navigationController?.popViewController(animated: true)
             return
         }
        scanQRCode(from: image)

    }
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
    func scanQRCode(from image: UIImage) {
        
        guard let imageData = image.pngData() else {
            return
        }
        guard let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]) else {
            return
        }
        guard let ciImage = CIImage(data: imageData) else {
            return
        }
        let features = detector.features(in: ciImage)
        if let feature = features.first as? CIQRCodeFeature, let stringValue = feature.messageString {
            print("识别到的二维码内容为：",stringValue )
            self.delegate?.scanCodeResult(stringValue)

        } else {
        }
        imagePicker.dismiss(animated: true)
    }

    @objc func selectedDot(_ btn :UIButton) -> Void {
        self.navigationController?.popViewController(animated: true)
        guard let btn = btn as? QYButton else { return  }
        self.delegate?.scanCodeResult(btn.info as? String ?? "")
    }
    func dotStartAnimate() -> Void {
        UIView.animate(withDuration: 1, delay: 1.0, options: [ .repeat, .curveLinear], animations: {
            for (_,view) in self.qrCodeFrameViews.enumerated() {
                view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
        }, completion: nil)
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
    @objc func selectImag() -> Void {
        
        self.authenticationPhoto()
    }
    func authenticationPhoto() -> Void {
        let statu = PHPhotoLibrary.authorizationStatus()
        switch statu {
        case .restricted,.denied:
            self.showPromptText(true)
            break
        case .authorized:

            DispatchQueue.main.async {
                self.present(self.imagePicker, animated: true)
            }
            break
        case .notDetermined:
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: PHAccessLevel.readWrite) { statu in
                    self.authenticationPhoto()
                }
            } else {
                // Fallback on earlier versions
                PHPhotoLibrary.requestAuthorization { statu in
                    self.authenticationPhoto()
                }
            }
            break
        case .limited:
            break
        default:
            break
        }
    }
    @objc func backClick3() -> Void {
        if !backBtn.isSelected {
            self.navigationController?.popViewController(animated: true)
        }else{
            _ = backBtn.qtext("").qimageState("back", .normal).isSelected = false
            qrCodeFrameViews.forEach { $0.removeFromSuperview() }
            qrCodeFrameViews.removeAll()
            captureSession.startRunning()
            startAnimate()
        }
        
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
        let transparentRect = CGRect(x: layerBounds.midX - (scanSize.width / 2),
                                     y: layerBounds.midY - (scanSize.height / 2),
                                     width: scanSize.width,
                                     height: scanSize.height)

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

    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        return UIStatusBarStyle.lightContent;

    }
    func showPromptText(_ photo : Bool) -> Void {
        let alertController : UIAlertController!
        if photo{
            alertController = UIAlertController(title: "无法使用相册", message: "请在iPhone的\"设置-隐私-相册\"中允许访问相册", preferredStyle: .alert)
        }else{
            alertController = UIAlertController(title: "无法使用相机", message: "请在iPhone的\"设置-隐私-相机\"中允许访问相机", preferredStyle: .alert)
        }
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "设置", style: .default, handler: { action in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
}

class ScaledButton: QYButton {
    
    // 重写 hitTest 方法，手动计算响应区域
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitFrame = bounds.insetBy(dx: -20, dy: -20) // 调整响应区域
        if hitFrame.contains(point) {
            return self
        }
        return super.hitTest(point, with: event)
    }
}
class RXImagePickerController: UIImagePickerController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if #available(iOS 13.0, *) {
            let barApp = UINavigationBarAppearance()
            barApp.configureWithOpaqueBackground()
            barApp.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)];
            barApp.backgroundColor = RGB(r: 0, g: 122, b: 255)
            barApp.setBackIndicatorImage(UIImage(named: "arrow_right")?.withRenderingMode(.alwaysOriginal), transitionMaskImage: UIImage(named: "arrow_right")?.withRenderingMode(.alwaysOriginal))
            //可以修改图片的上下位置
            barApp.backButtonAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 4)
    //           可设置为透明隐藏返回
    //            barApp.backButtonAppearance.normal.titleTextAttributes

            self.navigationBar.standardAppearance = barApp
            self.navigationBar.scrollEdgeAppearance = barApp
        } else {
            // Fallback on earlier versions
        };

    }
    @objc func ttt (){
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if #available(iOS 13.0, *) {

        }
    
    }

}
