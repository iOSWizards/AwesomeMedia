//
//  AwesomeMediaControlView.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/23/18.
//

import UIKit
import AVFoundation

public typealias PlaybackCallback = (_ playing: Bool) -> Void
public typealias TimeSliderChangedCallback = (Double) -> Void
public typealias TimeSliderFinishedDraggingCallback = (Bool) -> Void
public typealias RewindCallback = () -> Void
public typealias ForwardCallback = () -> Void
public typealias SpeedToggleCallback = () -> Void
public typealias ToggleViewCallback = (Bool) -> Void
public typealias FavouriteCallback = (Bool) -> Void

public class AwesomeMediaControlView: UIView {
    
    @IBOutlet public weak var playButton: UIButton!
    @IBOutlet public weak var minTimeLabel: UILabel!
    @IBOutlet public weak var maxTimeLabel: UILabel!
    @IBOutlet public weak var timeSlider: UISlider!
    @IBOutlet public weak var rewindButton: UIButton!
    @IBOutlet public weak var forwardButton: UIButton?
    @IBOutlet public weak var speedButton: UIButton?
    @IBOutlet public weak var speedLabel: UILabel?
    @IBOutlet public weak var speedView: UIView?
    @IBOutlet public weak var favouriteButton: UIButton?

    // Callbacks
    public var playCallback: PlaybackCallback?
    public var timeSliderChangedCallback: TimeSliderChangedCallback?
    public var timeSliderFinishedDraggingCallback: TimeSliderFinishedDraggingCallback?
    public var rewindCallback: RewindCallback?
    public var forwardCallback: ForwardCallback?
    public var speedToggleCallback: SpeedToggleCallback?
    public var toggleViewCallback: ToggleViewCallback?
    public var favouriteCallback: FavouriteCallback?
    
    // Private Variables
    fileprivate var autoHideControlTimer: Timer?
    fileprivate var playButtonStateBeforeSliding = false
    
    // Public Variables
    public var shouldShowInfo = true
    public var timerSliderIsSliding = false
    public var isLocked = false
    public var trackingSource: AwesomeMediaTrackingSource = .unknown
    
    // Configuration
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        // set thumb slider image
        timeSlider.setThumbImage()
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
    }
    
    // MARK: - Events
    
    @IBAction func playButtonPressed(_ sender: Any) {
        playButton.isSelected = !playButton.isSelected
        playCallback?(playButton.isSelected)
        
        // tracking event
        if playButton.isSelected {
            track(event: .startedPlaying, source: trackingSource)
        } else {
            track(event: .stoppedPlaying, source: trackingSource)
        }
    }
    
    @IBAction func rewindButtonPressed(_ sender: Any) {
        rewindCallback?()
        
        // tracking event
        track(event: .tappedRewind, source: trackingSource, value: AwesomeMedia.backwardForwardStep)
    }
    
    @IBAction func forwardButtonPressed(_ sender: Any) {
        forwardCallback?()
        
        // tracking event
        track(event: .tappedAdvance, source: trackingSource, value: AwesomeMedia.backwardForwardStep)
    }
    
    @IBAction func speedButtonPressed(_ sender: Any) {
        speedToggleCallback?()
        
        // tracking event
        track(event: .toggledSpeed, source: trackingSource, value: sharedAVPlayer.rate)
    }
    
    @IBAction func favouriteButtonPressed(_ sender: Any) {
        favouriteButton?.isSelected = !(favouriteButton?.isSelected ?? false)

        favouriteCallback?(favouriteButton?.isSelected ?? false)
    }
    
    @IBAction func timeSliderValueChanged(_ sender: Any) {
        guard timerSliderIsSliding else {
            return
        }
        
        timeSliderChangedCallback?(Double(timeSlider.value))
        
        // tracking event
        track(event: .sliderChanged, source: trackingSource, value: timeSlider.value)
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

    // MARK: - Control Toggle
    
    public var shouldToggleControl: Bool {
        return playButton.isSelected || isHidden
    }
    
    public func toggleViewIfPossible() {
        guard shouldToggleControl else {
            return
        }
        toggleView()
    }
    
    func toggleView() {
        cancelAutoHide()
        
        animateToggle(direction: .down) { (hidden) in
            if !hidden {
                self.setupAutoHide()
            }
        }
        toggleViewCallback?(isHidden)
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
        
        rewindButton.isUserInteractionEnabled = !locked
        rewindButton.alpha = locked ? lockedAlpha : 1.0
        
        forwardButton?.isUserInteractionEnabled = !locked
        forwardButton?.alpha = locked ? lockedAlpha : 1.0
        
        speedView?.isUserInteractionEnabled = !locked
        speedView?.alpha = locked ? lockedAlpha : 1.0

        favouriteButton?.isUserInteractionEnabled = !locked
        favouriteButton?.alpha = locked ? lockedAlpha : 1.0
    }
}
