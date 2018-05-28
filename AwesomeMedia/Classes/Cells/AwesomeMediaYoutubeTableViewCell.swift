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
        
        youtubePlayerView.delegate = self
        youtubePlayerView.load(withVideoId: youtubeId, playerVars: ["playsinline": 1])
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
        }
    }
    
}
