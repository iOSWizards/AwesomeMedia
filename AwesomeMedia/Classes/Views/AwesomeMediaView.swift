//
//  AwesomeMediaView.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/5/18.
//

import UIKit
import AVFoundation

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
        if let item = AwesomeMediaManager.shared.avPlayer.currentItem(ifSameUrlAs: AwesomeMediaManager.url(forParams: mediaParams)) {
            controlView?.update(withItem: item)
        }
        
        addPlayerLayer()
        
    }
    
    fileprivate func configureControls(controls: AwesomeMediaVideoControls, states: AwesomeMediaVideoStates = .standard) {
        controlView = superview?.addVideoControls(withControls: controls, states: states)
        
        controlView?.playCallback = { (isPlaying) in
            if isPlaying {
                AwesomeMediaManager.shared.playMedia(
                    withParams: self.mediaParams,
                    inPlayerLayer: AwesomeMediaPlayerLayer.shared)
                self.controlView?.shouldShowInfo = false
            } else {
                AwesomeMediaManager.shared.avPlayer.pause()
            }
        }
        controlView?.toggleViewCallback = { (_) in
            self.titleView?.toggleView()
        }
        
        // seek slider
        controlView?.timeSliderChangedCallback = { (time) in
            AwesomeMediaManager.shared.avPlayer.seek(toTime: time)
        }
        controlView?.timeSliderFinishedDraggingCallback = { (play) in
            if play {
                AwesomeMediaManager.shared.avPlayer.play()
            }
        }
        
        // Rewind
        controlView?.rewindCallback = {
            AwesomeMediaManager.shared.avPlayer.seekBackward()
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
}

extension AwesomeMediaView {
    
    fileprivate func addObservers() {
        AwesomeMediaNotificationCenter.shared.addObserver(self, selector: .startedPlaying, event: .startedPlaying)
        AwesomeMediaNotificationCenter.shared.addObserver(self, selector: .stopedPlaying, event: .stopedPlaying)
        AwesomeMediaNotificationCenter.shared.addObserver(self, selector: .timeUpdated, event: .timeUpdated)

    }
    
    @objc fileprivate func startedPlaying() {
        
    }
    
    @objc fileprivate func stopedPlaying() {
        
    }
    
    @objc fileprivate func timeUpdated() {
        guard let item = AwesomeMediaManager.shared.avPlayer.currentItem(ifSameUrlAs: AwesomeMediaManager.url(forParams: mediaParams)) else {
            return
        }
        
        //AwesomeMedia.log("Current time updated: \(item.currentTime().seconds) of \(CMTimeGetSeconds(item.duration))")
        
        // update time controls
        controlView?.update(withItem: item)
    }
}

// MARK: - Touches
extension AwesomeMediaView {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        controlView?.toggleViewIfPossible()
    }
}
