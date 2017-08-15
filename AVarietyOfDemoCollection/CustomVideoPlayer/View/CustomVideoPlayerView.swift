//
//  CustomVideoPlayerView.swift
//  multipleFrameworkDemo
//
//  Created by Apple on 2017/4/21.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

class CustomVideoPlayerView: UIView {
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var currentTimeLb: FontsizeToFitLabel!
    @IBOutlet weak var totalTimelb: FontsizeToFitLabel!
    var lastSupperview: UIView!
    @IBOutlet weak var slider: CustomVideoPalyerSlider!
    @IBOutlet weak var controlView: UIView!
    var isDragSlider = false
    var lastFrame: CGRect!
    var avPlayerObserver: Any?
    lazy var backBtn: UIButton = {
        let btn: UIButton = UIButton(type: .custom)
        btn.frame = CGRect(x: screen_s.width - 30, y: 35, width: 20, height: 20)
        btn.setBackgroundImage(UIImage.init(named: "ic_上箭头"), for: .normal)
        btn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        return btn
    }()
    
    public var url: String! {
        didSet {
            guard let rurl = URL.init(string: url) else { return }
            hideControlView(alpha: 1)
            avPlayerItem = AVPlayerItem(url: rurl)
        }
    }

    fileprivate var avPlayerItem: AVPlayerItem? {
        didSet {
            avPlayer.replaceCurrentItem(with: avPlayerItem)
            if let _ = avPlayerItem {
                addObserver()
            }else {
                removeAvPlayerObserver()
            }
        }
    }
    
    fileprivate var avPlayer: AVPlayer! {
        get {
            return avPlayerLayer.player
        }
        set {
            avPlayerLayer.player = newValue
            avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        }
    }
    
    override static var layerClass:AnyClass {
        return AVPlayerLayer.self
    }
    
    fileprivate var avPlayerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    fileprivate var totalTime: Double {
        guard let item = avPlayer.currentItem else { return 0 }
        return CMTimeGetSeconds(item.duration)
    }
    
    var sliderTime: Double = 0
    
    fileprivate var currentTime: Double {
        get {
            return CMTimeGetSeconds(avPlayer.currentTime())
        }
        set {
            sliderTime = newValue
            let cmtime = CMTimeMake(Int64(newValue), 1)
            currentTimeLb.text = CMTimeGetSeconds(cmtime).setPlayTime()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        avPlayer = AVPlayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        avPlayer = AVPlayer()
        if let image = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).colorForImage(size: CGSize(width: screen_s.width * 0.032, height: screen_s.width * 0.032)) {
            slider.setThumbImage(image, for: .normal)
            slider.setThumbImage(image, for: .highlighted)
        }
        slider.dragSliderClosure = { [weak self] (isDrag) in
            if !isDrag {
                let cmtime = CMTimeMake(Int64((self?.sliderTime)!), 1)
                self?.avPlayer.seek(to: cmtime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
            }
        }
    }

    deinit {
        removeObserver()
    }
    

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

extension CustomVideoPlayerView {
    
    fileprivate func addObserver() {
        avPlayerItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        avPlayerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        addAvPlayerObserver()
    }
    
    public func removeObserver() {
        controlView.isHidden = true
        playBtn.isHidden = true
        currentTimeLb.text = "00:00"
        totalTimelb.text = "00:00"
        slider.setValue(0, animated: false)
        slider.progressView.setProgress(0, animated: false)
        avPlayerItem?.removeObserver(self, forKeyPath: "status")
        avPlayerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        avPlayerItem = nil
    }
    
    fileprivate func addAvPlayerObserver() {
        avPlayerObserver = avPlayer.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: 1), queue: DispatchQueue.main) { [weak self](cmtime) in
            self?.currentTimeLb.text = self?.currentTime.setPlayTime()
            self?.slider.setValue(Float((self?.currentTime)! / (self?.totalTime)!), animated: true)
        }
    }
    
    fileprivate func removeAvPlayerObserver() {
        guard let observer = avPlayerObserver else { return }
        avPlayer.removeTimeObserver(observer)
        avPlayerObserver = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            guard let value = change?[.newKey] as? NSNumber,let status = AVPlayerStatus.init(rawValue: value.intValue)  else { return }
            LoadingViewManager.manager.hideLoadingView()
            if status == .readyToPlay {
                totalTimelb.text = totalTime.setPlayTime()
                avPlayer.play()
                print("play success")
                controlView.isHidden = false
                playBtn.isHidden = false
            }else if status == .failed {
                print("play fail")
            }else if status == .unknown {
                print("play unknow")
            }
        }
        if keyPath == "loadedTimeRanges" {
            updateBufferProgress()
        }
    }
    
    func updateBufferProgress() {
        guard let timeRanges = avPlayerItem?.loadedTimeRanges.first else { return }
        let timeRange = timeRanges.timeRangeValue
        let start = CMTimeGetSeconds(timeRange.start)
        let duration = CMTimeGetSeconds(timeRange.duration)
        let result = start + duration
        slider.progressView.setProgress(Float(result / totalTime), animated: true)
    }
}

enum FullScreenDirection {
    case left,right
}

extension CustomVideoPlayerView {
    @IBAction func clickFullScreenBtn(_ sender: UIButton) {
        fullScreen()
    }
    
    func clickBackBtn(btn: UIButton) {
        originalScreen()
        backBtn.removeFromSuperview()
    }
    
    fileprivate func fullScreen() {
        hideControlView(alpha: nil)
        lastFrame = self.frame
        guard let supperView = self.superview,let window = UIApplication.shared.keyWindow else { return }
        lastSupperview = supperView
        let convertFrame = supperView.convert(self.frame, to: window)
        self.removeFromSuperview()
        self.frame = convertFrame
        window.addSubview(self)
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
            self.frame = CGRect(x: 0, y: 0, width: screen_s.width, height: screen_s.height)
        }) { (finish) in
            window.addSubview(self.backBtn)
        }
    }
    
    
    fileprivate func originalScreen() {
        guard let window = window,let last = lastSupperview else { return }
        self.frame = window.convert(self.frame, to: lastSupperview)
        self.removeFromSuperview()
        last.addSubview(self)
        UIView.animate(withDuration: 0.3) { 
            self.transform = CGAffineTransform.identity
            self.frame = self.lastFrame
        }
    }
    
    @IBAction func respondsToSlider(_ sender: CustomVideoPalyerSlider) {
        currentTime = Double(sender.value) * totalTime
    }
    
    @IBAction func respondsToPlayBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isSelected ? avPlayer.pause() : avPlayer.play()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideControlView(alpha: nil)
    }
    
    fileprivate func hideControlView(alpha: CGFloat?) {
        var viewAlpha: CGFloat = 0
        if let alpha1 = alpha {
            viewAlpha = alpha1
        }else {
            playBtn.alpha == 0 ? (viewAlpha = 1) : (viewAlpha = 0)
        }
        UIView.animate(withDuration: 0.3) {
            self.playBtn.alpha = viewAlpha
            self.controlView.alpha = viewAlpha
        }
    }
    
}
