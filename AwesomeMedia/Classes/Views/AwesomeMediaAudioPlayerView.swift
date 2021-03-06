//
//  AwesomeMediaMiniAudioView.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/25/18.
//

import UIKit
import AwesomeUIMagic

public class AwesomeMediaAudioPlayerView: UIView {

    @IBOutlet public weak var mainView: UIView!
    @IBOutlet public weak var coverImageView: UIImageView!
    @IBOutlet public weak var fullscreenButton: UIButton!
    @IBOutlet public weak var playButton: UIButton!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var timeLabel: UILabel?
    
    // Public variables
    public var mediaParams = AwesomeMediaParams()
    public var isLocked = false
    public var canRemove = false
    public var trackingSource: AwesomeMediaTrackingSource = .audioMiniplayer
    
    // Private variables
    fileprivate var removeTimer: Timer?
    
    // Callbacks
    public var fullScreenCallback: FullScreenCallback?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // add observers
        addObservers()
    }
    
    public func configure(withMediaParams mediaParams: AwesomeMediaParams, trackingSource: AwesomeMediaTrackingSource) {
        self.mediaParams = mediaParams
        self.trackingSource = trackingSource
        
        // Load cover Image
        loadCoverImage()
        
        // Set Media Information
        updateMediaInformation()
        
        // Update play button status
        updatePlayStatus()
        
        // check for loading state
        mainView.stopLoadingAnimation()
        if AwesomeMediaManager.shared.mediaIsLoading(withParams: mediaParams) {
            mainView.startLoadingAnimation()
        }
    }
    
    // MARK: - Events
    
    @IBAction func playButtonPressed(_ sender: Any) {
        AwesomeMediaPlayerType.type = .audio
        
        playButton.isSelected = !playButton.isSelected
        
        // Play/Stop media
        if playButton.isSelected {
            AwesomeMediaManager.shared.playMedia(withParams: self.mediaParams, viewController: parentViewController)
        } else {
            sharedAVPlayer.pause()
        }
        
        // tracking event
        if playButton.isSelected {
            track(event: .startedPlaying, source: trackingSource)
        } else {
            track(event: .stoppedPlaying, source: trackingSource)
        }
    }
    
    @IBAction func fullscreenButtonPressed(_ sender: Any) {
        fullScreenCallback?()
        
        track(event: .toggleFullscreen, source: trackingSource)
    }
    
}

// MARK: - Media Information

extension AwesomeMediaAudioPlayerView {
    
    public func updateMediaInformation() {
        titleLabel.text = mediaParams.title
        timeLabel?.text = mediaParams.duration.timeString.uppercased()
    }
    
    public func loadCoverImage() {
        guard let coverImageUrl = mediaParams.coverUrl else {
            return
        }
        
        // set the cover image
        coverImageView.setImage(coverImageUrl)
    }
    
    fileprivate func updatePlayStatus() {
        playButton.isSelected = sharedAVPlayer.isPlaying(withParams: mediaParams)
    }
}

// MARK: - Observers

extension AwesomeMediaAudioPlayerView: AwesomeMediaEventObserver {
    
    public func addObservers() {
        AwesomeMediaNotificationCenter.addObservers([.basic, .timedOut, .stopped, .hideMiniPlayer], to: self)
    }
    
    public func removeObservers() {
        AwesomeMediaNotificationCenter.removeObservers(from: self)
    }
    
    public func startedPlaying() {
        guard sharedAVPlayer.isPlaying(withParams: mediaParams) else {
            return
        }
        
        // cancel remove timer
        cancelRemoveTimer()
        
        // change play button selection
        playButton.isSelected = true
        
        // update Control Center
        AwesomeMediaControlCenter.updateControlCenter(withParams: mediaParams)
        
        // remove media alert if present
        parentViewController?.removeAlertIfPresent()
    }
    
    public func pausedPlaying() {
        playButton.isSelected = sharedAVPlayer.isPlaying(withParams: mediaParams)
        
        // unlock buttons
        stoppedBuffering()
        
        // configure auto remove
        setupAutoRemove()
    }
    
    public func stoppedPlaying() {
        pausedPlaying()
        stoppedBuffering()
        finishedPlaying()
        
        // remove media alert if present
        parentViewController?.removeAlertIfPresent()
    }
    
    public func startedBuffering() {
        guard sharedAVPlayer.isCurrentItem(withParams: mediaParams) else {
            stoppedBuffering()
            return
        }
        
        mainView.startLoadingAnimation()
        
        lock(true, animated: true)
    }
    
    public func stoppedBuffering() {
        mainView.stopLoadingAnimation()
        
        lock(false, animated: true)
    }
    
    public func finishedPlaying() {
        playButton.isSelected = false
        
        // unlock buttons
        lock(false, animated: true)
        
        // configure auto remove
        setupAutoRemove()
    }
    
    public func timedOut() {
        parentViewController?.showMediaTimedOutAlert()
    }
    
    public func hideMiniPlayer(_ notification: NSNotification) {
        remove(animated: false)
    }
}

// MARK: - States

extension AwesomeMediaAudioPlayerView: AwesomeMediaControlState {
    
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
    }
}

// MARK: - Animations

extension AwesomeMediaAudioPlayerView {
    
    public func show() {
        
        //translatesAutoresizingMaskIntoConstraints = true
        frame.origin.y = UIScreen.main.bounds.size.height
        
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.y = UIScreen.main.bounds.size.height-self.frame.size.height
        }, completion: { (_) in
            //self.translatesAutoresizingMaskIntoConstraints = false
        })
    }
    
    public func remove(animated: Bool) {
        // remove observers
        removeObservers()
        
        guard animated else {
            removeFromSuperview()
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = true
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.y = UIScreen.main.bounds.size.height
        }, completion: { (_) in
            self.removeFromSuperview()
        })
    }
    
    public func setupAutoRemove() {
        cancelRemoveTimer()
        
        guard canRemove else {
            return
        }
        
        removeTimer = Timer.scheduledTimer(withTimeInterval: AwesomeMedia.removeAudioControlViewTime, repeats: false) { (_) in
            self.remove(animated: true)
        }
    }
    
    public func cancelRemoveTimer() {
        removeTimer?.invalidate()
        removeTimer = nil
    }
    
}

// MARK: - View Initialization

extension AwesomeMediaAudioPlayerView {
    public static var newInstance: AwesomeMediaAudioPlayerView {
        return AwesomeMedia.bundle.loadNibNamed("AwesomeMediaAudioPlayerView", owner: self, options: nil)![0] as! AwesomeMediaAudioPlayerView
    }
}

extension UIView {
    
    public func addAudioPlayer(withParams params: AwesomeMediaParams, animated: Bool = false) -> AwesomeMediaAudioPlayerView? {
        
        guard !isShowingAudioControlView else {
            return nil
        }
        
        let playerView = AwesomeMediaAudioPlayerView.newInstance
        playerView.configure(withMediaParams: params, trackingSource: .audioMiniplayer)
        playerView.canRemove = true
        addSubview(playerView)
        
        playerView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: playerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: playerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: playerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: playerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: isPad ? 100 : 88))
        
        // show with animation
        if animated {
            playerView.show()
        }
        
        // add fullscreen callback
        playerView.fullScreenCallback = { [weak self] in
            guard let self = self else { return }
            guard let playerType = AwesomeMediaPlayerType.type else {
                return
            }
            
            switch playerType {
            case .video:
                self.parentViewController?.presentVideoFullscreen(withMediaParams: params)
            case .verticalVideo:
                self.parentViewController?.presentVerticalVideoFullscreen(withMediaParams: params)
            default:
                self.parentViewController?.presentAudioFullscreen(withMediaParams: params)
            }
        }
        
        return playerView
    }
    
    public func removeAudioControlView(animated: Bool = false) {
        for subview in subviews where subview is AwesomeMediaAudioPlayerView {
            (subview as? AwesomeMediaAudioPlayerView)?.remove(animated: animated)
        }
    }
    
    public var isShowingAudioControlView: Bool {
        for subview in subviews where subview is AwesomeMediaAudioPlayerView {
            return true
        }
        
        return false
    }
}
