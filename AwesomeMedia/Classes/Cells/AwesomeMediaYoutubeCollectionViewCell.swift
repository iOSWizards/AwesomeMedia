//
//  AwesomeMediaYoutubeCollectionViewCell.swift
//  AwesomeMedia
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 28/05/18.
//

import UIKit
import youtube_ios_player_helper

public class AwesomeMediaYoutubeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var youtubePlayerView: YTPlayerView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var playButton: UIImageView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(withMediaParams mediaParams: AwesomeMediaParams) {
        //        BitmovinTracking.start(withParams: mediaParams)
        
        guard let youtubeUrl = mediaParams.youtubeUrl, let youtubeId = AwesomeMedia.extractYoutubeVideoId(videoUrl: youtubeUrl) else {
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

extension AwesomeMediaYoutubeCollectionViewCell: YTPlayerViewDelegate {
    
    public func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .buffering || state == .playing {
            sharedAVPlayer.stop()
            showCoverAndPlay(false)
        } else if state == .ended {
            showCoverAndPlay(true)
            youtubePlayerView.stopVideo()
        }
    }
}

// MARK: - Media Information

extension AwesomeMediaYoutubeCollectionViewCell {
    
    public func loadCoverImage(with mediaParams: AwesomeMediaParams) {
        guard let coverImageUrl = mediaParams.coverUrl else {
            return
        }
        
        // set the cover image
        coverImageView.setImage(coverImageUrl) { (_) in }
    }
}

// MARK: - UI Helper

extension AwesomeMediaYoutubeCollectionViewCell {
    func showCoverAndPlay(_ enable: Bool) {
        coverImageView.isHidden = !enable
        playButton.isHidden = !enable
    }
}
