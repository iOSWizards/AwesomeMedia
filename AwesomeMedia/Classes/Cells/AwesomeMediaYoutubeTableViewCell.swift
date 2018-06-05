//
//  AwesomeMediaYoutubeTableViewCell.swift
//  AwesomeMedia
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 28/05/18.
//

import UIKit
import youtube_ios_player_helper

public class AwesomeMediaYoutubeTableViewCell: UITableViewCell {

    @IBOutlet var youtubeView: AwesomeMediaYoutubeView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(withMediaParams mediaParams: AwesomeMediaParams) {
        //        BitmovinTracking.start(withParams: mediaParams)
        
        guard let youtubeUrl = mediaParams.youtubeUrl, let youtubeId = AwesomeMedia.extractYoutubeVideoId(videoUrl: youtubeUrl) else {
            return
        }
        
        youtubeView.loadCoverImage(with: mediaParams)
        youtubeView.youtubePlayerView.load(withVideoId: youtubeId, playerVars: ["playsinline": 1,
                                                                                "showinfo": 0,
                                                                                "autohide": 1,
                                                                                "modestbranding": 1])
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
