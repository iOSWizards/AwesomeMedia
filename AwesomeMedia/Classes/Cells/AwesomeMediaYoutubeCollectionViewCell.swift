//
//  AwesomeMediaYoutubeCollectionViewCell.swift
//  AwesomeMedia
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 28/05/18.
//

import UIKit

open class AwesomeMediaYoutubeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet open var youtubeView: AwesomeMediaYoutubeView!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(withMediaParams mediaParams: AwesomeMediaParams) {
        youtubeView.loadCoverImage(with: mediaParams)
        youtubeView.loadVideoUrl(with: mediaParams)
    }
    
}
