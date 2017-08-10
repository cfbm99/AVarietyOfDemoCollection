//
//  CFQRCodeScanView.swift
//  hongqiliansuo
//
//  Created by Apple on 2017/8/8.
//  Copyright © 2017年 hongqi. All rights reserved.
//

import UIKit
import AVFoundation

protocol CFQRCodeScanViewDelegate: NSObjectProtocol {
    func didFinishScan(with result: String)
}

public class CFQRCodeScanView: UIView {
    
    weak var delegate: CFQRCodeScanViewDelegate?
    
    fileprivate var visibleRect: CGRect!
    
    fileprivate lazy var bjImageV: UIImageView = {
        let imgV = UIImageView(image: UIImage.init(named: "scanscanBg"))
        imgV.contentMode = .scaleAspectFill
        imgV.frame = self.visibleRect
        return imgV
    }()
    
    fileprivate lazy var titleLb: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var scanView: UIImageView = {
        let imgV = UIImageView(image: UIImage.init(named: "scanLine"))
        imgV.contentMode = .scaleAspectFill
        imgV.frame = CGRect(x: self.visibleRect.minX, y: self.visibleRect.minY, width: self.visibleRect.width, height: self.visibleRect.width * 0.046)
        return imgV
    }()
    
    fileprivate lazy var hollowLayer: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.fillColor = UIColor.black.cgColor
        shape.opacity = 0.5
        shape.fillRule = kCAFillRuleEvenOdd
        let finalPath = CGMutablePath()
        finalPath.addRects([self.bounds, self.visibleRect])
        shape.path = finalPath
        return shape
    }()
    
    fileprivate lazy var session: AVCaptureSession = {
        let session = AVCaptureSession()
        return session
    }()
    
    public convenience init(frame: CGRect, title: String) {
        self.init(frame: frame)
        titleLb.text = title
        addSubViews()
        initializeQrCodeScanning()
        scanView.layer.add(animationForScanView(), forKey: nil)
    }

    fileprivate func addSubViews() {
        let size = self.frame.size
        visibleRect = CGRect(x: size.width * 0.15, y: size.width * 0.3 + 64, width: size.width * 0.7, height: size.width * 0.7)
        self.addSubview(bjImageV)
        self.addSubview(scanView)
        self.addSubview(titleLb)
        self.addConstraint(NSLayoutConstraint(item: titleLb, attribute: .top, relatedBy: .equal, toItem: self.bjImageV, attribute: .bottom, multiplier: 1, constant: 10))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|->=20-[label]->=20-|", options: .alignAllLeft, metrics: nil, views: ["label" : titleLb]))
        self.addConstraint(NSLayoutConstraint(item: titleLb, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.bjImageV, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
    }
    
}

extension CFQRCodeScanView: AVCaptureMetadataOutputObjectsDelegate {
    
    fileprivate func initializeQrCodeScanning() {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        let output = AVCaptureMetadataOutput()
        session.addInput(input)
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]
        session.sessionPreset = AVCaptureSessionPresetHigh
        let previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.frame = self.bounds
        previewLayer.rectForMetadataOutputRect(ofInterest: visibleRect)
        self.layer.insertSublayer(previewLayer, at: 0)
        self.layer.insertSublayer(hollowLayer, above: previewLayer)
        session.startRunning()
    }
    
    public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects.count > 0 {
            session.stopRunning()
            guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject else { return }
            delegate?.didFinishScan(with: metadataObject.stringValue)
        }
    }
}

extension CFQRCodeScanView {
    
    fileprivate func animationForScanView() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "position")
        animation.toValue = CGPoint(x: visibleRect.midX, y: visibleRect.maxY)
        animation.duration = 1
        animation.repeatCount = HUGE
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return animation
    }
}
