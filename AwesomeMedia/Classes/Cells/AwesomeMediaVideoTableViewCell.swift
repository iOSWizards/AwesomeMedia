//
//  AwesomeMediaVideoTableViewCell.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/4/18.
//

import UIKit

public class AwesomeMediaVideoTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet public weak var playerView: AwesomeMediaView!
    
    // MARK: - Variables
    
    var fullScreenControls: AwesomeMediaVideoControls = .all

    // MARK: - Methods
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /*public override func layoutSubviews() {
        super.layoutSubviews()
        
        if !UIApplication.shared.statusBarOrientation.isPortrait, sharedAVPlayer.isPlaying(withParams: playerView.mediaParams) {
            self.parentViewController?.presentVideoFullscreen(withMediaParams: playerView.mediaParams)
        }
    }*/
    
    public func configure(withMediaParams mediaParams: AwesomeMediaParams,
                          widthControls controls: AwesomeMediaVideoControls = .standard,
                          fullScreenControls: AwesomeMediaVideoControls = .all,
                          fullScreenTitleViewVisible: Bool = true) {
        //BitmovinTracking.start(withParams: mediaParams)
        self.fullScreenControls = fullScreenControls
        var mediaParams = mediaParams
        
        playerView.configure(withMediaParams: mediaParams,
                             controls: controls,
                             states: [.info],
                             trackingSource: .videoCell)
        
        //mediaParams.params = [:]
        
        playerView.controlView?.fullscreenCallback = { [weak self] in
            guard let self = self else { return }
            self.parentViewController?.presentVideoFullscreen(withMediaParams: mediaParams,
                                                              withControls: self.fullScreenControls,
                                                              titleViewVisible: fullScreenTitleViewVisible)
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
