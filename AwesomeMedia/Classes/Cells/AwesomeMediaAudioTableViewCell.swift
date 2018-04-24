//
//  AwesomeMediaAudioTableViewCell.swift
//  AwesomeLoading
//
//  Created by Evandro Harrison Hoffmann on 4/19/18.
//

import UIKit

public class AwesomeMediaAudioTableViewCell: UITableViewCell {

    @IBOutlet public weak var coverImageView: UIImageView!
    @IBOutlet public weak var playButton: UIButton!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var timeLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var fullscreenButton: UIButton!
    
    public var mediaParams: AwesomeMediaParams = [:]
    public var isLocked = false
    
    // Callbacks
    public var fullScreenCallback: FullScreenCallback?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        addObservers()
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
    
    
    // MARK: - Dimensions
    
    public static var defaultSize: CGSize {
        var defaultSize = UIScreen.main.bounds.size
        
        defaultSize.height = 140
        
        return defaultSize
    }
}

// MARK: - Media Information

extension AwesomeMediaAudioTableViewCell {
    
    public func updateMediaInformation() {
        titleLabel.text = AwesomeMediaManager.title(forParams: mediaParams)
        timeLabel.text = AwesomeMediaManager.duration(forParams: mediaParams).formatedTime
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

extension AwesomeMediaAudioTableViewCell: AwesomeMediaEventObserver {
    
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

extension AwesomeMediaAudioTableViewCell: AwesomeMediaControlState {
    
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
