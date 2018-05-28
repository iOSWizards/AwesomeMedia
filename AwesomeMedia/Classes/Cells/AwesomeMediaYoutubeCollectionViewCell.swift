//
//  AwesomeMediaYoutubeCollectionViewCell.swift
//  AwesomeMedia
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 28/05/18.
//

import UIKit

public class AwesomeMediaYoutubeCollectionViewCell: UICollectionViewCell {
    
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
    
}
