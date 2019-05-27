//
//  AwesomeMediaYoutubeTableViewCell.swift
//  AwesomeMedia
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 28/05/18.
//

import UIKit

public class AwesomeMediaYoutubeTableViewCell: UITableViewCell {
    
    @IBOutlet var youtubeView: AwesomeMediaYoutubeView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(withMediaParams mediaParams: AwesomeMediaParams) {
        youtubeView.loadCoverImage(with: mediaParams)
        youtubeView.loadVideoUrl(with: mediaParams)
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
