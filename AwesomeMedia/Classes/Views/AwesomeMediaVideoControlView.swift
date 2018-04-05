//
//  AwesomeMediaVideoControlView.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/5/18.
//

import UIKit

public enum AwesomeMediaVideoControls {
    case time
    case jumpto
    case speed
    case playlist
    case fullscreen
    case minimize
    case rewind
}

public enum AwesomeMediaVideoStates {
    case info
}

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
    public var playCallback: ((_ playing: Bool) -> Void)?
    public var fullscreenCallback: (() -> Void)?
    
    // Private Variables
    fileprivate var autoHideControlTimer: Timer?
    fileprivate var states: [AwesomeMediaVideoStates] = []
    
    // Configuration
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        // execution configuration
        backgroundColor = .clear
    }
    
    public func configure(withControls controls: [AwesomeMediaVideoControls], states: [AwesomeMediaVideoStates]) {
        self.states = states
        
        // show or hide buttons depending on request
        timeStackView.isHidden = !controls.contains(.time)
        jumptoView.isHidden = !controls.contains(.jumpto)
        speedView.isHidden = !controls.contains(.speed)
        playlistButton.isHidden = !controls.contains(.playlist)
        rewindButton.isHidden = !controls.contains(.rewind)
        toggleFullscreenButton.isHidden = !controls.contains(.fullscreen) && !controls.contains(.minimize)
        toggleFullscreenButton.setImage(controls.contains(.fullscreen) ? UIImage.image("btnFullscreen") : UIImage.image("btnMinimize"), for: .normal)
        
        // set thumb slider image
        timeSlider.setThumbImage()
        
        // make sure that pausedView is visible
        togglePlay()
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
        
        if !states.contains(.info) {
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
        let hideAnimation = {
            UIViewPropertyAnimator(duration: AwesomeMedia.autoHideControlViewAnimationTime, curve: .easeOut) {
                self.frame.origin.y = self.superview?.frame.size.height ?? UIScreen.main.bounds.size.height
                self.alpha = 0
            }
        }()
        hideAnimation.addCompletion { (_) in
            self.isHidden = true
        }
        
        let showAnimation = {
            UIViewPropertyAnimator(duration: AwesomeMedia.autoHideControlViewAnimationTime, curve: .linear) {
                self.isHidden = false
                self.alpha = 1
                self.frame.origin.y = (self.superview?.frame.size.height ?? UIScreen.main.bounds.size.height) - self.frame.size.height
            }
        }()
        showAnimation.addCompletion { (_) in
            self.autoHideControl()
        }
        
        if isHidden {
            showAnimation.startAnimation()
        } else {
            hideAnimation.startAnimation()
        }
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
    public func addVideoControls(withControls controls: [AwesomeMediaVideoControls] = [.time, .fullscreen], states: [AwesomeMediaVideoStates] = []) -> AwesomeMediaVideoControlView {
        
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
