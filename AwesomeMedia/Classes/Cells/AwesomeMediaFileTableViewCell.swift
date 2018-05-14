//
//  AwesomeMediaFileTableViewCell.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 5/3/18.
//

import UIKit

public class AwesomeMediaFileTableViewCell: UITableViewCell {
    
    @IBOutlet public weak var mainView: UIView!
    @IBOutlet public weak var coverImageView: UIImageView!
    @IBOutlet public weak var coverIconImageView: UIImageView!
    @IBOutlet public weak var fullscreenButton: UIButton!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var descLabel: UILabel!
    
    // Public variables
    public var mediaParams = AwesomeMediaParams()

    public override func setSelected(_ selected: Bool, animated: Bool) {
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
    
    @IBAction public func fullscreenButtonPressed(_ sender: Any) {
        guard let url = mediaParams.url?.url else {
            return
        }
        
        self.parentViewController?.presentWebPageInSafari(withURL: url)
        
        // track event
        track(event: .toggleFullscreen, source: .fileCell, params: mediaParams)
    }
    
    // MARK: - Dimensions
    
    public static var defaultSize: CGSize {
        var defaultSize = UIScreen.main.bounds.size
        
        defaultSize.height = isPad ? 200 : 140
        
        return defaultSize
    }
}

// MARK: - Media Information

extension AwesomeMediaFileTableViewCell {
    
    public func updateMediaInformation() {
        titleLabel.text = mediaParams.title
        
        descLabel.text = ""
        
        if let type = mediaParams.type {
            descLabel.text = type.uppercased().appending(" ")
            
            coverIconImageView.isHidden = type.uppercased() != "PDF"
        }
        
        if let size = mediaParams.size {
            descLabel.text?.append("(\(size.uppercased()))")
        }
    }
    
    public func loadCoverImage() {
        guard let coverImageUrl = mediaParams.coverUrl else {
            return
        }
        
        // set the cover image
        coverImageView.setImage(coverImageUrl)
    }
}
