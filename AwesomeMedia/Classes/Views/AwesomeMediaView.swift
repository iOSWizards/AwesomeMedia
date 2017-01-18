//
//  AwesomeMediaView.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 16/01/2017.
//
//

import UIKit
import AVFoundation

@IBDesignable
open class AwesomeMediaView: UIView {

    // MARK: - Components
    
    @IBOutlet open weak var controlsView: UIView?
    @IBOutlet open weak var mediaView: UIView?
    @IBOutlet weak var timeSlider: UISlider?
    @IBOutlet weak var minTimeLabel: UILabel?
    @IBOutlet weak var maxTimeLabel: UILabel?
    @IBOutlet weak var playButton: UIButton?
    @IBOutlet weak var speedButton: UIButton?
    @IBOutlet weak var fullscreenButton: UIButton?
    @IBOutlet weak var markersButton: UIButton?
    @IBOutlet weak var forwardButton: UIButton?
    @IBOutlet weak var rewindButton: UIButton?
    
    // MARK: - Configurations
    
    fileprivate var isSeeking = false
    fileprivate var isControlHidden = false
    fileprivate var autoHideTimer: Timer?
    
    @IBInspectable open var seekTime: Int = 15
    @IBInspectable open var autoHideControlsTime: Int = 3
    @IBInspectable open var fullscreenOnLandscape: Bool = false
    @IBInspectable open var canToggleControls: Bool = true

    open override func awakeFromNib() {
        //Video layer
        self.layer.insertSublayer(AwesomeMedia.shared.avPlayerLayer, at: 0)
        self.layer.masksToBounds = true
        
        //Controls
        timeSlider?.addTarget(self, action: #selector(AwesomeMediaView.timeSliderUpdated(_:)), for: .valueChanged)
        timeSlider?.addTarget(self, action: #selector(AwesomeMediaView.timeSliderBeganUpdating(_:)), for: .touchDown)
        timeSlider?.addTarget(self, action: #selector(AwesomeMediaView.timeSliderEndedUpdating(_:)), for: .touchUpInside)
        timeSlider?.addTarget(self, action: #selector(AwesomeMediaView.timeSliderEndedUpdating(_:)), for: .touchUpOutside)
        
        playButton?.addTarget(self, action: #selector(AwesomeMediaView.togglePlay(_:)), for: .touchUpInside)
        
        fullscreenButton?.addTarget(self, action: #selector(AwesomeMediaView.toggleFullscreen(_:)), for: .touchUpInside)
        
        forwardButton?.addTarget(self, action: #selector(AwesomeMediaView.seekForward(_:)), for: .touchUpInside)
        rewindButton?.addTarget(self, action: #selector(AwesomeMediaView.seekBackward(_:)), for: .touchUpInside)
        
        //observers
        addMediaObservers()
    }
    
    deinit {
        removeMediaObservers()
    }
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        AwesomeMedia.shared.avPlayerLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
    }
}

// MARK: - Events

extension AwesomeMediaView {
    
    open func prepareMedia(withUrl url: URL?, replaceCurrent: Bool = false, startPlaying: Bool = false) {
        AwesomeMedia.shared.prepareMedia(withUrl: url, replaceCurrent: replaceCurrent, startPlaying: startPlaying)
    }
    
    // MARK: - Touches
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == mediaView {
            toggleControls(self)
        }
    }
    
    // MARK: - Play / Pause
    
    @IBAction open func togglePlay(_ sender: AnyObject){
        guard let playButton = playButton else {
            return
        }
        playButton.isSelected = !playButton.isSelected
        
        if playButton.isSelected {
            play(sender)
        }else{
            pause(sender)
        }
    }
    
    @IBAction open func play(_ sender: AnyObject){
        AwesomeMedia.shared.play()
    }
    
    @IBAction open func pause(_ sender: AnyObject){
        AwesomeMedia.shared.pause()
    }
    
    @IBAction open func stop(_ sender: AnyObject){
        AwesomeMedia.shared.stop()
    }
    
    // MARK: - Speed
    
    @IBAction open func toggleSpeed(_ sender: AnyObject){
        let speed = AwesomeMedia.shared.toggleRateSpeed()
        
        speedButton?.setTitle(String(format:"%.0fx", speed), for: .normal)
        
        if speed.decimal != 0 {
            speedButton?.setTitle(String(format:"%.2fx", speed), for: .normal)
            
            if (speed.decimal*10).decimal == 0 {
                speedButton?.setTitle(String(format:"%.1fx", speed), for: .normal)
            }
        }
        
    }
    
    // MARK: - Seeking
    
    @IBAction open func seekBackward(_ sender: AnyObject){
        AwesomeMedia.shared.seek(addingSeconds: -Double(seekTime))
    }
    
    @IBAction open func seekForward(_ sender: AnyObject){
        AwesomeMedia.shared.seek(addingSeconds: Double(seekTime))
    }
    
    // MARK: - Slider
    
    @IBAction open func timeSliderUpdated(_ sender: AnyObject){
        if let value = timeSlider?.value {
            AwesomeMedia.shared.seek(toTime: Double(value))
        }
    }
    
    @IBAction open func timeSliderBeganUpdating(_ sender: AnyObject){
        isSeeking = true
        AwesomeMedia.shared.beginSeeking()
    }
    
    @IBAction open func timeSliderEndedUpdating(_ sender: AnyObject){
        isSeeking = false
        AwesomeMedia.shared.endSeeking(timeSlider?.value ?? 0)
    }
    
    // MARK: - Fullscreen
    
    @IBAction open func toggleFullscreen(_ sender: AnyObject){
        guard let fullscreenButton = fullscreenButton else {
            return
        }
        fullscreenButton.isSelected = !fullscreenButton.isSelected
        
        if fullscreenButton.isSelected {
            fullscreen(sender)
        }else{
            smallscreen(sender)
        }
    }
    
    @IBAction open func fullscreen(_ sender: AnyObject){
        
    }
    
    @IBAction open func smallscreen(_ sender: AnyObject){
        
    }
    
    // MARK: - Controls
    
    @IBAction open func toggleControls(_ sender: AnyObject){
        if !canToggleControls {
            return
        }
        
        isControlHidden = !isControlHidden
        
        //self.navigationController?.setNavigationBarHidden(controlsButton?.isSelected ?? false, animated: true)
        
        showControls(!isControlHidden)
    }
    
    open func enableControls(_ enable: Bool){
        controlsView?.isUserInteractionEnabled = enable
        UIView.animate(withDuration: 0.2, animations: {
            self.controlsView?.alpha = enable ? 1.0 : 0.5
        })
    }
    
    open func setupAutoHideControlsTimer(){
        if !canToggleControls {
            return
        }
        
        //hides control after start playing
        autoHideTimer = Timer.scheduledTimer(timeInterval: TimeInterval(autoHideControlsTime), target: self, selector: #selector(AwesomeMediaView.hideControls), userInfo: nil, repeats: false)
    }
    
    open func hideControls(){
        showControls(false)
    }
    
    open func showControls(_ show: Bool){
        isControlHidden = !show
        
        autoHideTimer?.invalidate()
        
        if show {
            UIView.animate(withDuration: 0.2, animations: {
                self.controlsView?.frame.origin.y = self.frame.size.height-(self.controlsView?.frame.size.height ?? 0)
                self.controlsView?.alpha = 1
            })
        }else{
            UIView.animate(withDuration: 0.2, animations: {
                self.controlsView?.frame.origin.y = self.frame.size.height
                self.controlsView?.alpha = 0
            })
        }
    }
    
}

// MARK: - Observers

extension AwesomeMediaView {
    
    open func removeMediaObservers(){
        AwesomeMedia.shared.notificationCenter.removeObserver(self)
    }
    
    open func addMediaObservers(){
        // Add observers
        AwesomeMedia.shared.notificationCenter.addObserver(self, selector: #selector(AwesomeMediaView.mediaStartedBuffering(_:)), name: NSNotification.Name(rawValue: kAwesomeMediaStartedBuffering), object: nil)
        AwesomeMedia.shared.notificationCenter.addObserver(self, selector: #selector(AwesomeMediaView.mediaStopedBuffering(_:)), name: NSNotification.Name(rawValue: kAwesomeMediaStopedBuffering), object: nil)
        AwesomeMedia.shared.notificationCenter.addObserver(self, selector: #selector(AwesomeMediaView.mediaStartedPlaying(_:)), name: NSNotification.Name(rawValue: kAwesomeMediaStartedPlaying), object: nil)
        AwesomeMedia.shared.notificationCenter.addObserver(self, selector: #selector(AwesomeMediaView.mediaPausedPlaying(_:)), name: NSNotification.Name(rawValue: kAwesomeMediaPausedPlaying), object: nil)
        AwesomeMedia.shared.notificationCenter.addObserver(self, selector: #selector(AwesomeMediaView.mediaStopedPlaying(_:)), name: NSNotification.Name(rawValue: kAwesomeMediaStopedPlaying), object: nil)
        AwesomeMedia.shared.notificationCenter.addObserver(self, selector: #selector(AwesomeMediaView.mediaFailedPlaying(_:)), name: NSNotification.Name(rawValue: kAwesomeMediaFailedPlaying), object: nil)
        AwesomeMedia.shared.notificationCenter.addObserver(self, selector: #selector(AwesomeMediaView.mediaFinishedPlaying(_:)), name: NSNotification.Name(rawValue: kAwesomeMediaFinishedPlaying), object: nil)
        AwesomeMedia.shared.notificationCenter.addObserver(self, selector: #selector(AwesomeMediaView.mediaTimeHasUpdated(_:)), name: NSNotification.Name(rawValue: kAwesomeMediaTimeUpdated), object: nil)
    }
    
    open func mediaStartedBuffering(_ notification: Notification) {
        
    }
    
    open func mediaStopedBuffering(_ notification: Notification) {
        
    }
    
    open func mediaStartedPlaying(_ notification: Notification) {
        playButton?.isSelected = true
        
        setupAutoHideControlsTimer()
    }
    
    open func mediaPausedPlaying(_ notification: Notification) {
        playButton?.isSelected = false
        
        autoHideTimer?.invalidate()
        showControls(true)
    }
    
    open func mediaStopedPlaying(_ notification: Notification) {
        playButton?.isSelected = false
        
        autoHideTimer?.invalidate()
        showControls(true)
    }
    
    open func mediaFailedPlaying(_ notification: Notification) {
        
    }
    
    open func mediaFinishedPlaying(_ notification: Notification) {
        
    }
    
    open func mediaTimeHasUpdated(_ notification: Notification) {
        guard let currentItem = AwesomeMedia.shared.avPlayer.currentItem else {
            return
        }
        
        enableControls(true)
        
        var currentTime = CMTimeGetSeconds(currentItem.currentTime())
        if isSeeking {
            if let value = timeSlider?.value {
                let sliderValue = Float(CMTimeGetSeconds(currentItem.duration)) * value
                currentTime = CMTimeGetSeconds(CMTimeMake(Int64(sliderValue), 1))
            }
            
            autoHideTimer?.invalidate()
        }else{
            timeSlider?.value = Float(currentTime / CMTimeGetSeconds(currentItem.duration))
        }
        
        let duration = CMTimeGetSeconds(currentItem.duration)
        let remainingTime = duration - currentTime
        
        self.minTimeLabel?.text = currentTime.formatedTime
        self.maxTimeLabel?.text = remainingTime.formatedTime
    }
}
