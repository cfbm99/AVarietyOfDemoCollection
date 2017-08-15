//
//  CFQRCodeScan.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/8/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import AVFoundation

class CFQRCodeScan: NSObject {
    
    fileprivate let defaultDevice: AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
    
    fileprivate lazy var input: AVCaptureDeviceInput? = {
        let input = try? AVCaptureDeviceInput(device: self.defaultDevice)
        return input
    }()
    
    fileprivate let output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
   // fileprivate let <#name#> = <#value#>
    

}
