//
//  AwesomeMediaVideoControlView.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/5/18.
//

import UIKit
import AVFoundation

public struct AwesomeMediaVideoControls: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let time = AwesomeMediaVideoControls(rawValue: 0)
    public static let jumpto = AwesomeMediaVideoControls(rawValue: 1)
    public static let speed = AwesomeMediaVideoControls(rawValue: 2)
    public static let playlist = AwesomeMediaVideoControls(rawValue: 3)
    public static let fullscreen = AwesomeMediaVideoControls(rawValue: 4)
    public static let minimize = AwesomeMediaVideoControls(rawValue: 5)
    public static let rewind = AwesomeMediaVideoControls(rawValue: 6)
    
    public static let standard: AwesomeMediaVideoControls = [.time, .fullscreen]
    public static let all: AwesomeMediaVideoControls = [.standard, .jumpto, .speed, .playlist, .minimize, .rewind]
}


public struct AwesomeMediaVideoStates: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let info = AwesomeMediaVideoStates(rawValue: 0)
    
    public static let standard: AwesomeMediaVideoStates = []
}

public typealias PlaybackCallback = (_ playing: Bool) -> Void
public typealias FullScreenCallback = () -> Void
public typealias ToggleViewCallback = (Bool) -> Void

public class AwesomeMediaVideoControlView: UIView {

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
    
    // Private Variables
    fileprivate var autoHideControlTimer: Timer?
    fileprivate var states: AwesomeMediaVideoStates = .standard
    fileprivate var controls: AwesomeMediaVideoControls = .standard
    
    // Public Variables
    public var shouldShowInfo = true
    
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
        togglePlay()
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
        
        jumptoView.isHidden = isPortrait
        speedView.isHidden = isPortrait
        playlistButton.isHidden = isPortrait
        rewindButton.isHidden = isPortrait
    }
    
    // update playback time
    public func update(withItem item: AVPlayerItem) {
        timeSlider.maximumValue = item.durationInSeconds
        timeSlider.value = item.currentTimeInSeconds
        minTimeLabel.text = item.minTimeString
        maxTimeLabel.text = item.maxTimeString
    }
    
    // MARK: - Events
    
    @IBAction func playButtonPressed(_ sender: Any) {
        playButton.isSelected = !playButton.isSelected
        togglePlay()
        playCallback?(playButton.isSelected)
        autoHideControl()
    }
    
    @IBAction func rewindButtonPressed(_ sender: Any) {
    }
    
    @IBAction func playlistButtonPressed(_ sender: Any) {
    }
    
    @IBAction func speedButtonPressed(_ sender: Any) {
    }
    
    @IBAction func jumptoButtonPressed(_ sender: Any) {
    }
    
    @IBAction func toggleFullscreenButtonPressed(_ sender: Any) {
        fullscreenCallback?()
    }
    
    @IBAction func timeSliderValueChanged(_ sender: Any) {
    }
    
}

// MARK: - Play/Pause
extension AwesomeMediaVideoControlView {
    fileprivate func togglePlay() {
        pausedView.isHidden = playButton.isSelected
        playingView.isHidden = !playButton.isSelected
        
        if !states.contains(.info) || !shouldShowInfo {
            pausedView.isHidden = true
            playingView.isHidden = false
        }
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
    
    public func toggleView() {
        autoHideControlTimer?.invalidate()
        
        animateToggle(direction: .down) { (hidden) in
            if !hidden {
                self.autoHideControl()
            }
        }
        toggleViewCallback?(isHidden)
    }
    
    public func autoHideControl() {
        autoHideControlTimer?.invalidate()
        
        guard !isHidden, playButton.isSelected else {
            return
        }
        
        autoHideControlTimer = Timer.scheduledTimer(withTimeInterval: AwesomeMedia.autoHideControlViewTime, repeats: false) { (_) in
            self.toggleView()
        }
    }
}

// MARK: - View Initialization

extension AwesomeMediaVideoControlView {
    public static var newInstance: AwesomeMediaVideoControlView {
        return AwesomeMedia.bundle.loadNibNamed("AwesomeMediaVideoControlView", owner: self, options: nil)![0] as! AwesomeMediaVideoControlView
    }
}

extension UIView {
    public func addVideoControls(withControls controls: AwesomeMediaVideoControls = .standard, states: AwesomeMediaVideoStates = .standard) -> AwesomeMediaVideoControlView {
        
        let controlView = AwesomeMediaVideoControlView.newInstance
        
        controlView.configure(withControls: controls, states: states)
        
        addSubview(controlView)
        
        controlView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: controlView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: controlView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: controlView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: controlView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 91))
        
        return controlView
    }
}
