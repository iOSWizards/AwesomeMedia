//
//  AwesomeMediaMiniAudioView.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/25/18.
//

import UIKit

public class AwesomeMediaAudioPlayerView: UIView {

    @IBOutlet public weak var mainView: UIView!
    @IBOutlet public weak var coverImageView: UIImageView!
    @IBOutlet public weak var fullscreenButton: UIButton!
    @IBOutlet public weak var playButton: UIButton!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var timeLabel: UILabel?
    
    // Public variables
    public var mediaParams: AwesomeMediaParams = [:]
    public var isLocked = false
    
    // Private variables
    fileprivate var bottomConstraint: NSLayoutConstraint?
    
    // Callbacks
    public var fullScreenCallback: FullScreenCallback?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        addObservers()
    }
    
    public func configure(withMediaParams mediaParams: AwesomeMediaParams) {
        self.mediaParams = mediaParams
        
        // Load cover Image
        loadCoverImage()
        
        // Set Media Information
        updateMediaInformation()
        
        // Update play button status
        updatePlayStatus()
    }
    
    // MARK: - Events
    
    @IBAction func playButtonPressed(_ sender: Any) {
        playButton.isSelected = !playButton.isSelected
        
        // Play/Stop media
        if playButton.isSelected {
            AwesomeMediaManager.shared.playMedia(withParams: self.mediaParams)
        } else {
            sharedAVPlayer.pause()
        }
    }
    
    @IBAction func fullscreenButtonPressed(_ sender: Any) {
        fullScreenCallback?()
    }
    
}

// MARK: - Media Information

extension AwesomeMediaAudioPlayerView {
    
    public func updateMediaInformation() {
        titleLabel.text = AwesomeMediaManager.title(forParams: mediaParams)
        timeLabel?.text = AwesomeMediaManager.duration(forParams: mediaParams).formatedTime
    }
    
    public func loadCoverImage() {
        guard let coverImageUrl = AwesomeMediaManager.coverUrl(forParams: mediaParams) else {
            return
        }
        
        // set the cover image
        coverImageView.setImage(coverImageUrl.absoluteString)
    }
    
    fileprivate func updatePlayStatus() {
        playButton.isSelected = sharedAVPlayer.isPlaying(withParams: mediaParams)
    }
}

// MARK: - Observers

extension AwesomeMediaAudioPlayerView: AwesomeMediaEventObserver {
    
    public func addObservers() {
        AwesomeMediaNotificationCenter.addObservers(.basic, to: self)
    }
    
    public func startedPlaying() {
        guard sharedAVPlayer.isPlaying(withParams: mediaParams) else {
            return
        }
        
        playButton.isSelected = true
        
        // update Control Center
        AwesomeMediaControlCenter.updateControlCenter(withParams: mediaParams)
    }
    
    public func pausedPlaying() {
        playButton.isSelected = sharedAVPlayer.isPlaying(withParams: mediaParams)
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
        
        lock(false, animated: true)
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

// MARK: - View Initialization

extension AwesomeMediaAudioPlayerView {
    public static var newInstance: AwesomeMediaAudioPlayerView {
        return AwesomeMedia.bundle.loadNibNamed("AwesomeMediaAudioPlayerView", owner: self, options: nil)![0] as! AwesomeMediaAudioPlayerView
    }
}

extension UIView {
    public func addAudioPlayer(withParams params: AwesomeMediaParams) -> AwesomeMediaAudioPlayerView {
        
        // remove video control view before adding new
        removeAudioControlView()
        
        let playerView = AwesomeMediaAudioPlayerView.newInstance
        playerView.configure(withMediaParams: params)
        addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: playerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: playerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        
        playerView.bottomConstraint = NSLayoutConstraint(item: playerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        addConstraint(playerView.bottomConstraint!)
        
        addConstraint(NSLayoutConstraint(item: playerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 88))
        
        return playerView
    }
    
    public func removeAudioControlView() {
        for subview in subviews where subview is AwesomeMediaVideoControlView {
            subview.removeFromSuperview()
        }
    }
}
