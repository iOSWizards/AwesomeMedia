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
    
    public var mediaParams: AwesomeMediaParams = [:]
    
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
    }
    
    // MARK: - Events
    
    @IBAction func playButtonPressed(_ sender: Any) {
        playButton.isSelected = !playButton.isSelected
        
        // start playing
        AwesomeMediaManager.shared.playMedia(withParams: self.mediaParams)
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
    
    public func timeUpdated() {
        // not used
    }
    
    public func startedBuffering() {
        guard sharedAVPlayer.isCurrentItem(withParams: mediaParams) else {
            return
        }
        
        mainView.startLoadingAnimation()
    }
    
    public func stopedBuffering() {
        guard sharedAVPlayer.isCurrentItem(withParams: mediaParams) else {
            return
        }
        
        mainView.stopLoadingAnimation()
    }
    
    public func finishedPlaying() {
        playButton.isSelected = false
    }
}
