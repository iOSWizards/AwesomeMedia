//
//  AwesomeMediaImageTableViewCell.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 5/3/18.
//

import UIKit

public class AwesomeMediaImageTableViewCell: UITableViewCell {

    @IBOutlet public weak var mainView: UIView!
    @IBOutlet public weak var coverImageView: UIImageView!
    @IBOutlet public weak var coverIconImageView: UIImageView!
    @IBOutlet public weak var fullscreenButton: UIButton!
    
    // Public variables
    public var mediaParams: AwesomeMediaParams = [:]
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(withMediaParams mediaParams: AwesomeMediaParams) {
        self.mediaParams = mediaParams
        
        // Load cover Image
        loadCoverImage()
    }
    
    // MARK: - Events
    
    @IBAction public func fullscreenButtonPressed(_ sender: Any) {
        guard let url = AwesomeMediaManager.coverUrl(forParams: mediaParams) else {
            return
        }
        
        self.parentViewController?.presentWebPageInSafari(withURL: url)
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
    
    public static func size(withTableView tableView: UITableView, indexPath: IndexPath) -> CGSize {
        guard let cell = tableView.cellForRow(at: indexPath) as? AwesomeMediaImageTableViewCell else {
            return AwesomeMediaImageTableViewCell.defaultSize
        }
        
        return cell.sizeWithImage
    }
    
    public var sizeWithImage: CGSize {
        var size = AwesomeMediaImageTableViewCell.defaultSize
        
        guard let image = coverImageView.image else {
            return size
        }
        
        size.height = (AwesomeMediaImageTableViewCell.defaultSize.width*image.size.height)/image.size.width
        return size
    }
    
    public func adjustSize() {
        self.frame.size.height = sizeWithImage.height
        
        if let tableView = tableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
    }
}

// MARK: - Media Information

extension AwesomeMediaImageTableViewCell {
    
    public func loadCoverImage() {
        guard let coverImageUrl = AwesomeMediaManager.coverUrl(forParams: mediaParams) else {
            return
        }
        
        // set the cover image
        coverImageView.setImage(coverImageUrl.absoluteString) { (image) in
            
            // reset background status
            self.mainView.backgroundColor = .placeholderBackground
            self.coverIconImageView.isHidden = false
            
            if image != nil {
                self.mainView.backgroundColor = .clear
                self.coverIconImageView.isHidden = true
                //self.adjustSize()
            }
        }
    }
}
