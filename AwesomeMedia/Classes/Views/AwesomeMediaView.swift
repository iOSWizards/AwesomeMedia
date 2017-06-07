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
    @IBOutlet open weak var controlsParentView: UIView?
    @IBOutlet open weak var mediaView: UIView?
    @IBOutlet open weak var timeSlider: UISlider?
    @IBOutlet open weak var minTimeLabel: UILabel?
    @IBOutlet open weak var maxTimeLabel: UILabel?
    @IBOutlet open weak var playButton: UIButton?
    @IBOutlet open weak var speedButton: UIButton?
    @IBOutlet open weak var fullscreenButton: UIButton?
    @IBOutlet open weak var markersButton: UIButton?
    @IBOutlet open weak var forwardButton: UIButton?
    @IBOutlet open weak var rewindButton: UIButton?
    
    // Controllers constraitns
    @IBOutlet weak var constraWidthMarkersButton: NSLayoutConstraint?
    
    // MARK: - Configurations
    
    fileprivate var isSeeking = false
    fileprivate var isControlHidden = false
    
    @IBInspectable open var seekTime: Int = 15
    @IBInspectable open var autoHideControlsTime: Int = 3
    @IBInspectable open var fullscreenOnLandscape: Bool = false
    @IBInspectable open var canToggleControls: Bool = false
    
    public let avPlayerLayer: AVPlayerLayer = {
        var avPlayerLayer = AVPlayerLayer()
        avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        return avPlayerLayer
    }()
    
    public var viewModel = AwesomeMediaViewModel()
    
    public weak var delegate: AwesomeMediaViewDelegate?
    
    open override func awakeFromNib() {
        //Video layer
        addPlayerLayer()
        
        //Controls
        timeSlider?.addTarget(self, action: #selector(AwesomeMediaView.timeSliderUpdated(_:)), for: .valueChanged)
        timeSlider?.addTarget(self, action: #selector(AwesomeMediaView.timeSliderBeganUpdating(_:)), for: .touchDown)
        timeSlider?.addTarget(self, action: #selector(AwesomeMediaView.timeSliderEndedUpdating(_:)), for: .touchUpInside)
        timeSlider?.addTarget(self, action: #selector(AwesomeMediaView.timeSliderEndedUpdating(_:)), for: .touchUpOutside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AwesomeMediaView.sliderTapped(gestureRecognizer:)))
        timeSlider?.addGestureRecognizer(tapGestureRecognizer)
        
        playButton?.addTarget(self, action: #selector(AwesomeMediaView.togglePlay(_:)), for: .touchUpInside)
        
        forwardButton?.addTarget(self, action: #selector(AwesomeMediaView.seekForward(_:)), for: .touchUpInside)
        rewindButton?.addTarget(self, action: #selector(AwesomeMediaView.seekBackward(_:)), for: .touchUpInside)
        
        speedButton?.addTarget(self, action: #selector(AwesomeMediaView.toggleSpeed(_:)), for: .touchUpInside)
        updateSpeedButton(withSpeed: AwesomeMedia.shared.currentRate)
        
        //observers
        addMediaObservers()
    }
    
    deinit {
        removeMediaObservers()
    }
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        avPlayerLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
    }
    
    open func addPlayerLayer(){
        self.layer.insertSublayer(avPlayerLayer, at: 0)
        self.layer.masksToBounds = true
    }
    
    open func requestPlayer(){
        avPlayerLayer.player = AwesomeMedia.shared.avPlayer
    }
    
    func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        
        guard let timeSlider = timeSlider else {
            return
        }
        
        let pointTapped: CGPoint = gestureRecognizer.location(in: self)
        
        let positionOfSlider: CGPoint = timeSlider.frame.origin
        let widthOfSlider: CGFloat = timeSlider.frame.size.width
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(timeSlider.maximumValue) / widthOfSlider)
        
        isSeeking = true
        AwesomeMedia.shared.beginSeeking()
        timeSlider.setValue(Float(newValue), animated: true)
        isSeeking = false
        AwesomeMedia.shared.endSeeking(timeSlider.value)
    }
}

// MARK: - Events

extension AwesomeMediaView {
    
    open func setup(
        mediaPath: String,
        coverImagePath: String? = nil,
        authorName: String? = nil,
        title: String? = nil,
        downloadPath: String? = nil,
        mediaFileSizeDescription: String? = nil,
        mediaMarkers: [AwesomeMediaMarker]? = nil,
        showHours: Bool = false,
        replaceCurrent: Bool = false,
        startPlaying: Bool = false) {
        
        viewModel.set(
            mediaPath: mediaPath,
            coverImagePath: coverImagePath,
            authorName: authorName,
            title: title,
            downloadPath: downloadPath,
            mediaFileSizeDescription: mediaFileSizeDescription,
            mediaMarkers: mediaMarkers,
            showHours: showHours)
        
        _ = AwesomeMedia.shared.prepareMedia(withUrl: viewModel.mediaUrl, replaceCurrent: replaceCurrent, startPlaying: startPlaying)
        
        playButton?.isSelected = AwesomeMedia.shared.playerIsPlaying
        
        showMarkersButton(mediaMarkers)
        
        mediaTimeHasUpdated()
    }
    
    // MARK: - Touches
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == mediaView {
            if AwesomeMedia.isPlaying(viewModel.mediaPath?.url) {
                toggleControls(self)
            }
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
        
        AwesomeMediaState.saveMediaPlayer(speed: speed, forMediaType: AwesomeMedia.shared.mediaType)
        
        updateSpeedButton(withSpeed: speed)
    }
    
    open func updateSpeedButton(withSpeed speed: Float) {
        let speedLabel = String(speed == 0 ? 1 : speed).replacingOccurrences(of: ".0", with: "")
        speedButton?.setTitle( speedLabel + "x", for: .normal)
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
    
    // MARK: - Controls
    
    @IBAction open func toggleControls(_ sender: AnyObject){
        if !canToggleControls || AwesomeMedia.shared.mediaType == .audio {
            return
        }
        
        showControls(isControlHidden)
    }
    
    open func enableControls(_ enable: Bool){
        
        // the enableControls event should ONLY be received by the MediaPlayer being executed.
        if AwesomeMedia.shared.lastPlayedUrlString != viewModel.mediaPath {
            return
        }
        
        DispatchQueue.main.async {
            self.controlsView?.isUserInteractionEnabled = enable
            UIView.animate(withDuration: 0.2, animations: {
                self.controlsView?.alpha = enable ? 1.0 : 0.5
            })
        }
    }
    
    open func autoHideControls() {
        if AwesomeMedia.shared.mediaType == .video {
            canToggleControls = true
            setupAutoHideControlsTimer()
        }
    }
    
    private func setupAutoHideControlsTimer() {
        
        if !canToggleControls {
            return
        }
        
        //hides control after start playing
        let timer = DispatchTime.now() + .seconds(autoHideControlsTime)
        DispatchQueue.main.asyncAfter(deadline: timer, execute: {
            // we're checking it again cause it may be scheduled to execute.
            if self.canToggleControls && AwesomeMedia.isPlaying(self.viewModel.mediaPath?.url) {
                self.showControls(false)
            }
        })
    }
    
    open func hideControls(){
        showControls(false)
    }
    
    open func showControls(_ show: Bool, automaticHide: Bool = true, forceAutoHide: Bool = false) {
        
        // show / hide controls should only happens for Videos.
        if AwesomeMedia.shared.mediaType == .audio {
            return
        }
        
        isControlHidden = !show
        
        var originHeight: CGFloat = 0
        if let v = controlsParentView {
            originHeight = v.frame.size.height
        } else {
            originHeight = self.frame.size.height
        }
        
        if show {
            UIView.animate(withDuration: 0.2, animations: {
                
                self.controlsView?.frame.origin.y = originHeight-(self.controlsView?.frame.size.height ?? 0)
                self.controlsView?.alpha = 1
                
            }, completion: { (completed) in
                if automaticHide {
                    if forceAutoHide {
                        self.canToggleControls = true
                    }
                    self.setupAutoHideControlsTimer()
                }
            })
        }else{
            UIView.animate(withDuration: 0.2, animations: {
                self.controlsView?.frame.origin.y = originHeight
                self.controlsView?.alpha = 0
            })
        }
        
        delegate?.didToggleControls(show: show)
    }
    
    func showMarkersButton(_ mediaMarkers: [AwesomeMediaMarker]?) {
        if let markersButton = markersButton {
            
            if let mediaMarkers = mediaMarkers, mediaMarkers.count > 0 {
                markersButton.isHidden = false
            } else {
                // we're hiding the markers button by changing its constraint to 0
                markersButton.isHidden = true
                constraWidthMarkersButton?.constant = 0
            }
            
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
        AwesomeMedia.addObserver(self, selector: #selector(AwesomeMediaView.mediaStartedBuffering(_:)), event: .startedBuffering)
        AwesomeMedia.addObserver(self, selector: #selector(AwesomeMediaView.mediaStopedBuffering(_:)), event: .stopedBuffering)
        AwesomeMedia.addObserver(self, selector: #selector(AwesomeMediaView.mediaStartedPlaying(_:)), event: .startedPlaying)
        AwesomeMedia.addObserver(self, selector: #selector(AwesomeMediaView.mediaPausedPlaying(_:)), event: .pausedPlaying)
        AwesomeMedia.addObserver(self, selector: #selector(AwesomeMediaView.mediaStopedPlaying(_:)), event: .stopedPlaying)
        AwesomeMedia.addObserver(self, selector: #selector(AwesomeMediaView.mediaFailedPlaying(_:)), event: .failedPlaying)
        AwesomeMedia.addObserver(self, selector: #selector(AwesomeMediaView.mediaFinishedPlaying(_:)), event: .finishedPlaying)
        AwesomeMedia.addObserver(self, selector: #selector(AwesomeMediaView.mediaTimeHasUpdated(_:)), event: .timeUpdated)
    }
    
    open func mediaStartedBuffering(_ notification: Notification) {
        enableControls(false)
    }
    
    open func mediaStopedBuffering(_ notification: Notification) {
        enableControls(true)
    }
    
    open func mediaStartedPlaying(_ notification: Notification) {
        playButton?.isSelected = true
        canToggleControls = true
        
        // updating the toggle speed button label with the last chosen speed selected by an user.
        if let speed = AwesomeMediaState.speedFor(AwesomeMedia.shared.mediaType) {
            updateSpeedButton(withSpeed: speed)
        }
        
        autoHideControls()
    }
    
    open func mediaPausedPlaying(_ notification: Notification) {
        playButton?.isSelected = false
        canToggleControls = false
        
        showControls(true)
    }
    
    open func mediaStopedPlaying(_ notification: Notification) {
        playButton?.isSelected = false
        
        showControls(true)
    }
    
    open func mediaFailedPlaying(_ notification: Notification) {
        
    }
    
    open func mediaFinishedPlaying(_ notification: Notification) {
        
    }
    
    open func mediaTimeHasUpdated(_ notification: Notification? = nil) {
        
        // this way we're preventing of another media other than the one being played of being updated.
        guard AwesomeMedia.isPlaying(viewModel.mediaUrl) || AwesomeMedia.wasPlaying(viewModel.mediaUrl) else {
            return
        }
        
        guard let currentItem = AwesomeMedia.shared.avPlayer.currentItem else {
            return
        }
        
        enableControls(true)
        
        var currentTime = CMTimeGetSeconds(currentItem.currentTime())
        if isSeeking {
            if let value = timeSlider?.value {
                let sliderValue = Float(CMTimeGetSeconds(currentItem.duration)) * value
                if !sliderValue.isNaN {
                    currentTime = CMTimeGetSeconds(CMTimeMake(Int64(sliderValue), 1))
                }
            }
            
        }else{
            timeSlider?.value = Float(currentTime / CMTimeGetSeconds(currentItem.duration))
        }
        
        let duration = CMTimeGetSeconds(currentItem.duration)
        let remainingTime = duration - currentTime
        
        let showHours = (currentTime + remainingTime) / 3600 >= 1
        
        self.minTimeLabel?.text = currentTime.formatedTime
        self.maxTimeLabel?.text = remainingTime.isNaN ? "" : remainingTime.formatedTime
        
    }
}
