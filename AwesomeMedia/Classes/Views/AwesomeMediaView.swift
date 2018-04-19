//
//  AwesomeMediaView.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/5/18.
//

import UIKit
import AVFoundation
import AwesomeLoading
import MediaPlayer

// Typealiases
public typealias FinishedPlayingCallback = () -> Void

public class AwesomeMediaView: UIView {

    public var mediaParams: AwesomeMediaParams = [:]
    public var controlView: AwesomeMediaVideoControlView?
    public var titleView: AwesomeMediaVideoTitleView?
    public var coverImageView: UIImageView?
    
    // Callbacks
    public var finishedPlayingCallback: FinishedPlayingCallback?

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
        
        // set coverImage
        addCoverImage()
        
        // check for loading state
        stopLoadingAnimation()
        if AwesomeMediaManager.shared.mediaIsLoading(withParams: mediaParams) {
            startLoadingAnimation()
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
        
        // show airplay menu
        titleView?.airplayCallback = {
            self.showAirplayMenu()
        }
    }
}

// MARK: - Observers

fileprivate extension Selector {
    static let playing = #selector(AwesomeMediaView.startedPlaying)
    static let paused = #selector(AwesomeMediaView.pausedPlaying)
    static let timeUpdated = #selector(AwesomeMediaView.timeUpdated)
    static let startedBuffering = #selector(AwesomeMediaView.startedBuffering)
    static let stopedBuffering = #selector(AwesomeMediaView.stopedBuffering)
    static let finishedPlaying = #selector(AwesomeMediaView.finishedPlaying)
}

extension AwesomeMediaView {
    
    fileprivate func addObservers() {
        AwesomeMediaNotificationCenter.shared.addObserver(self, selector: .playing, event: .playing)
        AwesomeMediaNotificationCenter.shared.addObserver(self, selector: .paused, event: .paused)
        AwesomeMediaNotificationCenter.shared.addObserver(self, selector: .timeUpdated, event: .timeUpdated)
        AwesomeMediaNotificationCenter.shared.addObserver(self, selector: .startedBuffering, event: .buffering)
        AwesomeMediaNotificationCenter.shared.addObserver(self, selector: .stopedBuffering, event: .stoppedBuffering)
        AwesomeMediaNotificationCenter.shared.addObserver(self, selector: .finishedPlaying, event: .finished)
    }
    
    @objc fileprivate func startedPlaying() {
        guard sharedAVPlayer.isPlaying(withParams: mediaParams) else {
            return
        }
        
        controlView?.playButton.isSelected = true
        
        // hide coverImage
        showCoverImage(false)
        
        // update Control Center
        AwesomeMediaControlCenter.updateControlCenter(withParams: mediaParams)
    }
    
    @objc fileprivate func pausedPlaying() {
        controlView?.playButton.isSelected = sharedAVPlayer.isPlaying(withParams: mediaParams)
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
            controlView.show()
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
    
    @objc fileprivate func finishedPlaying() {
        /*guard sharedAVPlayer.isCurrentItem(withParams: mediaParams) else {
            return
        }*/
        
        // reset controls
        controlView?.reset()
        
        // show cover image
        showCoverImage(true)
        
        // do something after finished playing
        finishedPlayingCallback?()
    }
}

// MARK: - Touches
extension AwesomeMediaView {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        controlView?.toggleViewIfPossible()
    }
}

// MARK: - Media Cover

extension AwesomeMediaView {
    public func addCoverImage() {
        // remove pre-existing cover images
        coverImageView?.removeFromSuperview()
        
        guard let coverImageUrl = AwesomeMediaManager.coverUrl(forParams: mediaParams) else {
            return
        }
        
        // set the cover image
        coverImageView = UIImageView(image: nil)
        coverImageView?.setImage(coverImageUrl.absoluteString)
        
        guard let coverImageView = coverImageView else {
            return
        }
        coverImageView.contentMode = .scaleAspectFill
        superview?.addSubview(coverImageView)
        superview?.sendSubview(toBack: coverImageView)
        
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        
        superview?.addConstraint(NSLayoutConstraint(item: coverImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        superview?.addConstraint(NSLayoutConstraint(item: coverImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        superview?.addConstraint(NSLayoutConstraint(item: coverImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        superview?.addConstraint(NSLayoutConstraint(item: coverImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        
        // hide cover image in case is not playing current item
        showCoverImage(!sharedAVPlayer.isPlaying(withParams: mediaParams))
    }
    
    public func showCoverImage(_ show: Bool) {
        coverImageView?.isHidden = !show
    }
    
    public func showAirplayMenu() {
        let volumeView = MPVolumeView()
        self.addSubview(volumeView)
        // loop through different items in MPVolumeView
        for view in volumeView.subviews {
            if let button = view as? UIButton {
                // add action to airPlayButton
                button.sendActions(for: .touchUpInside)
                // remove VolumeView - just disables it from airplay menu
//                volumeView.removeFromSuperview()
            }
        }
    }
}
