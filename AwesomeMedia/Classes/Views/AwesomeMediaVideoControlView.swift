//
//  AwesomeMediaVideoControlView.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/5/18.
//

import UIKit
import AVFoundation

public class AwesomeMediaVideoControlView: AwesomeMediaControlView {

    // Private Variables
    fileprivate var autoHideControlTimer: Timer?
    fileprivate var bottomConstraint: NSLayoutConstraint?
    
    // MARK: - Events
    
    @IBAction override func playButtonPressed(_ sender: Any) {
        super.playButtonPressed(sender)
        
        setupAutoHide()
    }
    
    @IBAction override func rewindButtonPressed(_ sender: Any) {
        super.rewindButtonPressed(sender)
        
        setupAutoHide()
    }
    
    @IBAction override func playlistButtonPressed(_ sender: Any) {
        super.playButtonPressed(sender)
        
        setupAutoHide()
    }
    
    @IBAction override func speedButtonPressed(_ sender: Any) {
        super.speedButtonPressed(sender)
        
        setupAutoHide()
    }
    
    @IBAction override func jumptoButtonPressed(_ sender: Any) {
        super.jumptoButtonPressed(sender)
        
        setupAutoHide()
    }
    
    @IBAction override func toggleFullscreenButtonPressed(_ sender: Any) {
        super.toggleFullscreenButtonPressed(sender)
        
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
    public func addVideoControls(withControls controls: AwesomeMediaVideoControls = .standard, states: AwesomeMediaVideoStates = .standard) -> AwesomeMediaVideoControlView {
        
        // remove video control view before adding new
        removeVideoControlView()
        
        let controlView = AwesomeMediaVideoControlView.newInstance
        controlView.configure(withControls: controls, states: states)
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
