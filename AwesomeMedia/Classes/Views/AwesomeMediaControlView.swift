//
//  AwesomeMediaControlView.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/23/18.
//

import UIKit
import AVFoundation

public typealias PlaybackCallback = (_ playing: Bool) -> Void
public typealias FullScreenCallback = () -> Void
public typealias ToggleViewCallback = (Bool) -> Void
public typealias TimeSliderChangedCallback = (Double) -> Void
public typealias TimeSliderFinishedDraggingCallback = (Bool) -> Void
public typealias RewindCallback = () -> Void
public typealias JumpToCallback = () -> Void

public class AwesomeMediaControlView: UIView {
    
    @IBOutlet public weak var playButton: UIButton!
    @IBOutlet public weak var timeStackView: UIStackView!
    @IBOutlet public weak var minTimeLabel: UILabel!
    @IBOutlet public weak var maxTimeLabel: UILabel!
    @IBOutlet public weak var timeSlider: UISlider!
    @IBOutlet public weak var toggleFullscreenButton: UIButton!
    @IBOutlet public weak var rewindButton: UIButton!
    @IBOutlet public weak var playlistButton: UIButton!
    @IBOutlet public weak var jumptoButton: UIButton!
    @IBOutlet public weak var speedButton: UIButton!
    @IBOutlet public weak var speedLabel: UILabel!
    @IBOutlet public weak var jumptoLabel: UILabel!
    @IBOutlet public weak var speedView: UIView!
    @IBOutlet public weak var jumptoView: UIView!
    @IBOutlet public weak var pausedView: UIView!
    @IBOutlet public weak var playingView: UIView!
    @IBOutlet public weak var timeLabel: UILabel!
    
    // Callbacks
    public var playCallback: PlaybackCallback?
    public var fullscreenCallback: FullScreenCallback?
    public var toggleViewCallback: ToggleViewCallback?
    public var jumpToCallback: JumpToCallback?
    public var timeSliderChangedCallback: TimeSliderChangedCallback?
    public var timeSliderFinishedDraggingCallback: TimeSliderFinishedDraggingCallback?
    public var rewindCallback: RewindCallback?
    
    // Private Variables
    fileprivate var states: AwesomeMediaVideoStates = .standard
    fileprivate var controls: AwesomeMediaVideoControls = .standard
    fileprivate var playButtonStateBeforeSliding = false
    
    // Public Variables
    public var shouldShowInfo = true
    public var timerSliderIsSliding = false
    public var isLocked = false
    
    // Configuration
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        updateControls(isPortrait: UIApplication.shared.statusBarOrientation.isPortrait)
    }
    
    public func configure(withControls controls: AwesomeMediaVideoControls, states: AwesomeMediaVideoStates) {
        self.states = states
        self.controls = controls
        
        // show or hide buttons depending on request
        setupControls()
        
        // set thumb slider image
        timeSlider.setThumbImage()
        
        // make sure that pausedView is visible
        updatePlayState()
    }
    
    public func setupControls() {
        timeStackView.isHidden = !controls.contains(.time)
        jumptoView.isHidden = !controls.contains(.jumpto)
        speedView.isHidden = !controls.contains(.speed)
        playlistButton.isHidden = !controls.contains(.playlist)
        rewindButton.isHidden = !controls.contains(.rewind)
        toggleFullscreenButton.isHidden = !controls.contains(.fullscreen) && !controls.contains(.minimize)
        toggleFullscreenButton.setImage(controls.contains(.fullscreen) ? UIImage.image("btnFullscreen") : UIImage.image("btnMinimize"), for: .normal)
    }
    
    public func updateControls(isPortrait: Bool) {
        setupControls()
        
        if controls.contains([.jumpto, .speed, .playlist, .rewind]) {
            jumptoView.isHidden = isPortrait
            speedView.isHidden = isPortrait
            playlistButton.isHidden = isPortrait
            rewindButton.isHidden = isPortrait
        }
    }
    
    // update playback time
    public func update(withItem item: AVPlayerItem) {
        if !timerSliderIsSliding {
            timeSlider.maximumValue = item.durationInSeconds
            timeSlider.value = item.currentTimeInSeconds
        }
        minTimeLabel.text = item.minTimeString
        maxTimeLabel.text = item.maxTimeString
        
        // update play/pause state based on player rate
        playButton.isSelected = sharedAVPlayer.isPlaying
        
        // set to false as the item being playing is the current item
        shouldShowInfo = false
        
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
    
    @IBAction func playButtonPressed(_ sender: Any) {
        playButton.isSelected = !playButton.isSelected
        updatePlayState()
        playCallback?(playButton.isSelected)
    }
    
    @IBAction func rewindButtonPressed(_ sender: Any) {
        rewindCallback?()
    }
    
    @IBAction func playlistButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func speedButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func jumptoButtonPressed(_ sender: Any) {
        jumpToCallback?()
    }
    
    @IBAction func toggleFullscreenButtonPressed(_ sender: Any) {
        fullscreenCallback?()
    }
    
    @IBAction func timeSliderValueChanged(_ sender: Any) {
        guard timerSliderIsSliding else {
            return
        }
        
        timeSliderChangedCallback?(Double(timeSlider.value))
    }
    
    @IBAction func timeSliderStartedDragging(_ sender: Any) {
        timerSliderIsSliding = true
        playButtonStateBeforeSliding = playButton.isSelected
    }
    
    @IBAction func timeSliderFinishedDragging(_ sender: Any) {
        timerSliderIsSliding = false
        timeSliderFinishedDraggingCallback?(playButtonStateBeforeSliding)
    }
    
    // MARK: - Control Toggle
    
    public func reset() {
        playButton.isSelected = false
        timeSlider.value = 0
        minTimeLabel.text = "00:00"
        maxTimeLabel.text = "00:00"
        shouldShowInfo = true
        
        updatePlayState()
    }
}

// MARK: - Control State

extension AwesomeMediaControlView: AwesomeMediaControlState {
    
    public func lock(_ lock: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.setLockedState(locked: lock)
            }
        } else {
            setLockedState(locked: lock)
        }
    }
    
    public func setLockedState(locked: Bool) {
        self.isLocked = locked
        
        let lockedAlpha: CGFloat = 0.5
        
        playButton.isUserInteractionEnabled = !locked
        playButton.alpha = locked ? lockedAlpha : 1.0
        
        timeSlider.isUserInteractionEnabled = !locked
        timeSlider.alpha = locked ? lockedAlpha : 1.0
    }
}

