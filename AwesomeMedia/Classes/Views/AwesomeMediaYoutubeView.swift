//
//  AwesomeMediaYoutubeView.swift
//  AwesomeMedia
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 28/05/18.
//

import Foundation
import AwesomeImage
import youtube_ios_player_helper

open class AwesomeMediaYoutubeView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var youtubePlayerView: YTPlayerView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var playButton: UIImageView!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle(for: AwesomeMediaYoutubeView.self).loadNibNamed("AwesomeMediaYoutubeView", owner: self, options: nil)
        
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(playVideo))
        contentView.addGestureRecognizer(gesture)
        contentView.isUserInteractionEnabled = true
        
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
        coverImageView.setImage(coverImageUrl)
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
    
    @objc func playVideo() {
        contentView.startLoadingAnimation()
        youtubePlayerView.playVideo()
    }
    
    public func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .buffering {
            sharedAVPlayer.stop()
        } else if state == .playing {
            contentView.stopLoadingAnimation()
            sharedAVPlayer.stop()
//            showCoverAndPlay(false)
        } else if state == .ended {
//            showCoverAndPlay(true)
            youtubePlayerView.stopVideo()
        }
    }
}
