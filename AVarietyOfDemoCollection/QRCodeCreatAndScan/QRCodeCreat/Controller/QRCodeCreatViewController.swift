//
//  QRCodeCreatViewController.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/6/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class QRCodeCreatViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageV: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initializeInterface()
    }
    
    func initializeInterface() {
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickBtn(_ sender: UIButton) {
        if let ciImage = creatCIImage(string: textView.text) {
            let image = transitionCIImageToUIImage(ciImage: ciImage, size: CGSize(width: screen_s.width / 2, height: screen_s.width / 2))
            imageV.image = image
        }
    }

    @IBAction func clickSyntheticBtn(_ sender: UIButton) {
        if let image = imageV.image,let headerImage = UIImage.init(named: "pikachu") {
            let syntheticImage = syntheticTwoImages(qRImage: image, headerImage: headerImage)
            imageV.image = syntheticImage
        }
    }
}

extension QRCodeCreatViewController {
    
    fileprivate func creatCIImage(string: String) -> CIImage? {
        //creat 二维码滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        //恢复默认属性
        filter?.setDefaults()
        let data = string.data(using: .utf8)
        filter?.setValue(data, forKey: "inputMessage")
        //生成二维码
        let ciImage = filter?.outputImage
        return ciImage
    }
    
    fileprivate func transitionCIImageToUIImage(ciImage: CIImage, size: CGSize) -> UIImage? {
        let extent = ciImage.extent
        let scale = min(size.width / extent.width, size.height / extent.height) * UIScreen.main.scale
        
        let context = CIContext(options: nil)
        guard let bitImage = context.createCGImage(ciImage, from: extent) else { return nil }
        
        let width = extent.width * scale
        let height = extent.height * scale
        
        let cs = CGColorSpaceCreateDeviceGray()
        
        let bitRef = CGContext.init(data: nil, width:Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        bitRef?.interpolationQuality = .none
        bitRef?.scaleBy(x: scale, y: scale)
        bitRef?.draw(bitImage, in: extent)
        
        guard let scaleImage = bitRef?.makeImage() else { return nil }
        
        let image = UIImage.init(cgImage: scaleImage)
        return image
    }
    
    fileprivate func syntheticTwoImages(qRImage: UIImage, headerImage: UIImage) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(qRImage.size, false, 0)
        
        let qrSizeWidth = qRImage.size.width / qRImage.scale
        let qrSizeHeight = qRImage.size.height / qRImage.scale
        let headerFrame = CGRect(x: qrSizeWidth / 3, y: qrSizeHeight / 3, width: qrSizeWidth / 3, height: qrSizeHeight / 3)
        
        qRImage.draw(in: CGRect(x: 0, y: 0, width: qrSizeWidth, height: qrSizeHeight))
        headerImage.draw(in: headerFrame)
        
        let syntheticImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return syntheticImage
    }
    
}
