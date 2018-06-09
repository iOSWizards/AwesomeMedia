//
//  AwesomeMediaVideoControlView.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/5/18.
//

import UIKit
import AVFoundation

public typealias JumpToCallback = () -> Void
public typealias FullScreenCallback = () -> Void
public typealias ToggleViewCallback = (Bool) -> Void

public class AwesomeMediaVideoControlView: AwesomeMediaControlView {
    
    // Outlets
    @IBOutlet public weak var timeStackView: UIStackView!
    @IBOutlet public weak var toggleFullscreenButton: UIButton!
//    @IBOutlet public weak var playlistButton: UIButton!
    @IBOutlet public weak var jumptoButton: UIButton!
    @IBOutlet public weak var jumptoLabel: UILabel!
    @IBOutlet public weak var jumptoView: UIView!
    @IBOutlet public weak var pausedView: UIView!
    @IBOutlet public weak var playingView: UIView!
    @IBOutlet public weak var timeLabel: UILabel!
    
    // Callbacks
    public var fullscreenCallback: FullScreenCallback?
    public var toggleViewCallback: ToggleViewCallback?
    public var jumpToCallback: JumpToCallback?

    // Private Variables
    fileprivate var autoHideControlTimer: Timer?
    fileprivate var bottomConstraint: NSLayoutConstraint?
    fileprivate var states: AwesomeMediaVideoStates = .standard
    fileprivate var controls: AwesomeMediaVideoControls = .standard
    
    // Configuration
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        updateControls(isPortrait: UIApplication.shared.statusBarOrientation.isPortrait)
    }
    
    public func configure(withControls controls: AwesomeMediaVideoControls, states: AwesomeMediaVideoStates, trackingSource: AwesomeMediaTrackingSource) {
        self.states = states
        self.controls = controls
        self.trackingSource = trackingSource
        
        // show or hide buttons depending on request
        setupControls()
        
        // make sure that pausedView is visible
        updatePlayState()
    }
    
    public func setupControls() {
        timeStackView.isHidden = !controls.contains(.time)
        jumptoView.isHidden = !controls.contains(.jumpto)
        speedView.isHidden = !controls.contains(.speed)
//        playlistButton.isHidden = !controls.contains(.playlist)
        rewindButton.isHidden = !controls.contains(.rewind)
        toggleFullscreenButton.isHidden = !controls.contains(.fullscreen) && !controls.contains(.minimize)
        toggleFullscreenButton.setImage(controls.contains(.fullscreen) ? UIImage.image("btnFullscreen") : UIImage.image("btnMinimize"), for: .normal)
    }
    
    public func updateControls(isPortrait: Bool) {
        setupControls()
        
        if controls.contains(.jumpto) {
            jumptoView.isHidden = isPortrait
        }
        
        if controls.contains(.speed) {
            speedView.isHidden = isPortrait
        }
        
//        if controls.contains(.playlist) {
//            playlistButton.isHidden = isPortrait
//        }
        
        if controls.contains(.rewind) {
            rewindButton.isHidden = isPortrait
        }
    }
    
    public override func update(withItem item: AVPlayerItem) {
        super.update(withItem: item)
        updatePlayState()
    }
    
    // update play/pause state
    fileprivate func updatePlayState() {
        
        // Show/Hide paused and playing states based on play button
        pausedView.isHidden = playButton.isSelected
        playingView.isHidden = !playButton.isSelected
        
        // in case play button has been selected once, show info will be set as false
        if playButton.isSelected {
            shouldShowInfo = false
        }
        
        // make sure that it won't show the paused view if we started playing at least once
        if !states.contains(.info) || !shouldShowInfo {
            pausedView.isHidden = true
            playingView.isHidden = false
        }
    }
    
    // MARK: - Events
    
    @IBAction func jumptoButtonPressed(_ sender: Any) {
        jumpToCallback?()
        setupAutoHide()
        
        // tracking event
        track(event: .openedMarkers, source: trackingSource)
    }
    
    @IBAction func toggleFullscreenButtonPressed(_ sender: Any) {
        fullscreenCallback?()
        setupAutoHide()
        
        // tracking event
        track(event: .toggleFullscreen, source: trackingSource)
    }
    
    @IBAction func playlistButtonPressed(_ sender: Any) {
        setupAutoHide()
        
        // tracking event
        //track(event: .togglePlaylist, source: trackingSource)
    }
    
    @IBAction override func playButtonPressed(_ sender: Any) {
        super.playButtonPressed(sender)
        updatePlayState()
        setupAutoHide()
    }
    
    @IBAction override func rewindButtonPressed(_ sender: Any) {
        super.rewindButtonPressed(sender)
        
        setupAutoHide()
    }
    
    @IBAction override func speedButtonPressed(_ sender: Any) {
        super.speedButtonPressed(sender)
        
        setupAutoHide()
    }
    
    @IBAction override func timeSliderValueChanged(_ sender: Any) {
        super.timeSliderValueChanged(sender)
    }
    
    @IBAction override func timeSliderStartedDragging(_ sender: Any) {
        super.timeSliderStartedDragging(sender)
        
        cancelAutoHide()
    }
    
    @IBAction override func timeSliderFinishedDragging(_ sender: Any) {
        super.timeSliderFinishedDragging(sender)
        
        setupAutoHide()
    }
    
    public override func reset() {
        super.reset()
        updatePlayState()
        show()
    }
}

// MARK: - Control Toggle
    
extension AwesomeMediaVideoControlView {
    
    public var shouldToggleControl: Bool {
        return playButton.isSelected || isHidden
    }
    
    public func toggleViewIfPossible() {
        guard shouldToggleControl else {
            return
        }
        toggleView()
    }
    
    fileprivate func toggleView() {
        cancelAutoHide()
        
        animateToggle(direction: .down) { (hidden) in
            if !hidden {
                self.setupAutoHide()
            }
        }
        toggleViewCallback?(isHidden)
    }
    
    public func setupAutoHide() {
        cancelAutoHide()
        
        guard !isHidden, playButton.isSelected, !isLocked else {
            return
        }
        
        autoHideControlTimer = Timer.scheduledTimer(withTimeInterval: AwesomeMedia.autoHideControlViewTime, repeats: false) { (_) in
            self.toggleView()
        }
    }
    
    public func cancelAutoHide() {
        autoHideControlTimer?.invalidate()
    }
    
    public func show() {
        cancelAutoHide()
        
        guard isHidden else {
            return
        }
        
        toggleView()
    }
    
}

// MARK: - View Initialization

extension AwesomeMediaVideoControlView {
    public static var newInstance: AwesomeMediaVideoControlView {
        return AwesomeMedia.bundle.loadNibNamed("AwesomeMediaVideoControlView", owner: self, options: nil)![0] as! AwesomeMediaVideoControlView
    }
}

extension UIView {
    public func addVideoControls(withControls controls: AwesomeMediaVideoControls = .standard, states: AwesomeMediaVideoStates = .standard, trackingSource: AwesomeMediaTrackingSource) -> AwesomeMediaVideoControlView {
        
        // remove video control view before adding new
        removeVideoControlView()
        
        let controlView = AwesomeMediaVideoControlView.newInstance
        controlView.configure(withControls: controls, states: states, trackingSource: trackingSource)
        addSubview(controlView)
        controlView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: controlView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: controlView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        
        controlView.bottomConstraint = NSLayoutConstraint(item: controlView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        addConstraint(controlView.bottomConstraint!)
        
        addConstraint(NSLayoutConstraint(item: controlView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 91))
        
        return controlView
    }

    public func removeVideoControlView() {
        for subview in subviews where subview is AwesomeMediaVideoControlView {
            subview.removeFromSuperview()
        }
    }
}
