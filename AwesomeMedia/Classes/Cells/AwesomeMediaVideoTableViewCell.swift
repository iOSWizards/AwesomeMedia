//
//  AwesomeMediaVideoTableViewCell.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/4/18.
//

import UIKit

public class AwesomeMediaVideoTableViewCell: UITableViewCell {

    @IBOutlet public weak var playerView: AwesomeMediaView!

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /*public override func layoutSubviews() {
        super.layoutSubviews()
        
        if !UIApplication.shared.statusBarOrientation.isPortrait, sharedAVPlayer.isPlaying(withParams: playerView.mediaParams) {
            self.parentViewController?.presentVideoFullscreen(withMediaParams: playerView.mediaParams)
        }
    }*/
    
    public func configure(withMediaParams mediaParams: AwesomeMediaParams) {
        playerView.configure(withMediaParams: mediaParams,
                             controls: .standard,
                             states: [.info])
        playerView.controlView?.fullscreenCallback = {
            self.parentViewController?.presentVideoFullscreen(withMediaParams: mediaParams)
        }
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
