//
//  AwesomeMediaView.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/5/18.
//

import UIKit
import AVFoundation
import AwesomeLoading

public class AwesomeMediaView: UIView {

    public var mediaParams: AwesomeMediaParams = [:]
    public var controlView: AwesomeMediaVideoControlView?
    public var titleView: AwesomeMediaVideoTitleView?

    public override func awakeFromNib() {
        super.awakeFromNib()
        
        addObservers()
    }
    
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        AwesomeMediaPlayerLayer.shared.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
    }
    
    public func configure(
        withMediaParams mediaParams: AwesomeMediaParams,
        controls: AwesomeMediaVideoControls,
        states: AwesomeMediaVideoStates,
        titleViewVisible: Bool = false) {
        
        self.mediaParams = mediaParams
        
        // Control View
        configureControls(controls: controls, states: states)
        
        // Title view
        if titleViewVisible {
            configureTitle()
        }
        
        // check for media playing
        if let item = sharedAVPlayer.currentItem(withParams: mediaParams) {
            controlView?.update(withItem: item)
            
            addPlayerLayer()
        }
        
    }
    
    fileprivate func configureControls(controls: AwesomeMediaVideoControls, states: AwesomeMediaVideoStates = .standard) {
        controlView = superview?.addVideoControls(withControls: controls, states: states)
        
        controlView?.playCallback = { (isPlaying) in
            
            self.addPlayerLayer()
            
            if isPlaying {
                AwesomeMediaManager.shared.playMedia(
                    withParams: self.mediaParams,
                    inPlayerLayer: AwesomeMediaPlayerLayer.shared)
            } else {
                sharedAVPlayer.pause()
            }
        }
        controlView?.toggleViewCallback = { (_) in
            self.titleView?.toggleView()
        }
        
        // seek slider
        controlView?.timeSliderChangedCallback = { (time) in
            sharedAVPlayer.seek(toTime: time)
        }
        controlView?.timeSliderFinishedDraggingCallback = { (play) in
            if play {
                sharedAVPlayer.play()
            }
        }
        
        // Rewind
        controlView?.rewindCallback = {
            sharedAVPlayer.seekBackward()
        }
        
    }
    
    fileprivate func configureTitle() {
        titleView = superview?.addVideoTitle()
    }
}

// MARK: - Observers

fileprivate extension Selector {
    static let startedPlaying = #selector(AwesomeMediaView.startedPlaying)
    static let stopedPlaying = #selector(AwesomeMediaView.stopedPlaying)
    static let timeUpdated = #selector(AwesomeMediaView.timeUpdated)
    static let startedBuffering = #selector(AwesomeMediaView.startedBuffering)
    static let stopedBuffering = #selector(AwesomeMediaView.stopedBuffering)
}

extension AwesomeMediaView {
    
    fileprivate func addObservers() {
        AwesomeMediaNotificationCenter.shared.addObserver(self, selector: .startedPlaying, event: .startedPlaying)
        AwesomeMediaNotificationCenter.shared.addObserver(self, selector: .stopedPlaying, event: .stopedPlaying)
        AwesomeMediaNotificationCenter.shared.addObserver(self, selector: .timeUpdated, event: .timeUpdated)
        AwesomeMediaNotificationCenter.shared.addObserver(self, selector: .startedBuffering, event: .startedBuffering)
        AwesomeMediaNotificationCenter.shared.addObserver(self, selector: .stopedBuffering, event: .stopedBuffering)

    }
    
    @objc fileprivate func startedPlaying() {
        
    }
    
    @objc fileprivate func stopedPlaying() {
        
    }
    
    @objc fileprivate func timeUpdated() {
        guard let item = sharedAVPlayer.currentItem(withParams: mediaParams) else {
            return
        }
        
        //AwesomeMedia.log("Current time updated: \(item.currentTime().seconds) of \(CMTimeGetSeconds(item.duration))")
        
        // update time controls
        controlView?.update(withItem: item)
    }
    
    @objc fileprivate func startedBuffering() {
        guard !(controlView?.timerSliderIsSliding ?? false), AwesomeMedia.shouldLockControlsWhenBuffering, sharedAVPlayer.isCurrentItem(withParams: mediaParams) else {
            return
        }
        
        startLoadingAnimation()

        if let controlView = controlView {
            // bring controlview to front as loading animation will be on top
            bringSubview(toFront: controlView)
            
            // lock state for controlView
            controlView.lock(true, animated: true)
            
            // cancels auto hide
            controlView.cancelAutoHide()
        }
    }
    
    @objc fileprivate func stopedBuffering() {
        guard AwesomeMedia.shouldLockControlsWhenBuffering, sharedAVPlayer.isCurrentItem(withParams: mediaParams) else {
            return
        }
        
        stopLoadingAnimation()
        
        // unlock controls
        controlView?.lock(false, animated: true)
        
        // setup auto hide
        controlView?.setupAutoHide()
    }
}

// MARK: - Touches
extension AwesomeMediaView {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        controlView?.toggleViewIfPossible()
    }
}
