//
//  AwesomeMediaYoutubeTableViewCell.swift
//  AwesomeMedia
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 28/05/18.
//

import UIKit
import youtube_ios_player_helper

public class AwesomeMediaYoutubeTableViewCell: UITableViewCell {

    @IBOutlet var youtubePlayerView: YTPlayerView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var playButton: UIImageView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(withMediaParams mediaParams: AwesomeMediaParams) {
//        BitmovinTracking.start(withParams: mediaParams)
        
        guard let youtubeId = mediaParams.youtubeId else {
            return
        }
        
        loadCoverImage(with: mediaParams)
        youtubePlayerView.delegate = self
        youtubePlayerView.load(withVideoId: youtubeId, playerVars: ["playsinline": 1,
                                                                    "showinfo": 0,
                                                                    "autohide": 1,
                                                                    "modestbranding": 1])
        AwesomeMediaManager.shared.youtubePlayerView = youtubePlayerView
    }
    
    // MARK: - Dimensions
    
    public static var defaultSize: CGSize {
        var defaultSize = UIScreen.main.bounds.size
        
        if isPad {
            defaultSize.width = 616
        }
        defaultSize.height = (defaultSize.width*9)/16
        
        return defaultSize
    }
    
}

// MARK: - Youtube Player

extension AwesomeMediaYoutubeTableViewCell: YTPlayerViewDelegate {
    
    public func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .buffering || state == .playing {
            sharedAVPlayer.stop()
            self.coverImageView.isHidden = true
            self.playButton.isHidden = true
        } else if state == .ended {
            self.coverImageView.isHidden = false
            self.playButton.isHidden = false
            youtubePlayerView.stopVideo()
        }
    }
}

// MARK: - Media Information

extension AwesomeMediaYoutubeTableViewCell {
    
    public func loadCoverImage(with mediaParams: AwesomeMediaParams) {
        guard let coverImageUrl = mediaParams.coverUrl else {
            return
        }
        
        // set the cover image
        coverImageView.setImage(coverImageUrl) { (_) in }
    }
}
