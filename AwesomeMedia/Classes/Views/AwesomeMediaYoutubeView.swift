//
//  AwesomeMediaYoutubeView.swift
//  AwesomeMedia
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 28/05/18.
//

import Foundation
import youtube_ios_player_helper

class AwesomeMediaYoutubeView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var youtubePlayerView: YTPlayerView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var playButton: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle(for: AwesomeMediaYoutubeView.self).loadNibNamed("AwesomeMediaYoutubeView", owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        youtubePlayerView.delegate = self
        AwesomeMediaManager.shared.youtubePlayerView = youtubePlayerView
    }
    
}

// MARK: - Media Information

extension AwesomeMediaYoutubeView {
    
    public func loadCoverImage(with mediaParams: AwesomeMediaParams) {
        guard let coverImageUrl = mediaParams.coverUrl else {
            return
        }
        
        // set the cover image
        coverImageView.startShimmerAnimation()
        coverImageView.setImage(coverImageUrl) { (_) in
            self.coverImageView.stopShimmerAnimation()
        }
    }
}

// MARK: - UI Helper

extension AwesomeMediaYoutubeView {
    func showCoverAndPlay(_ enable: Bool) {
        coverImageView.isHidden = !enable
        playButton.isHidden = !enable
    }
}

// MARK: - Youtube Player

extension AwesomeMediaYoutubeView: YTPlayerViewDelegate {
    
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
