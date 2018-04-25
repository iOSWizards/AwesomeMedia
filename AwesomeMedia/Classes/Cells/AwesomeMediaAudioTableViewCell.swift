//
//  AwesomeMediaAudioTableViewCell.swift
//  AwesomeLoading
//
//  Created by Evandro Harrison Hoffmann on 4/19/18.
//

import UIKit

public class AwesomeMediaAudioTableViewCell: UITableViewCell {

    @IBOutlet public weak var audioPlayerView: AwesomeMediaAudioPlayerView!
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    public func configure(withMediaParams mediaParams: AwesomeMediaParams) {
        audioPlayerView.configure(withMediaParams: mediaParams)
        audioPlayerView.fullScreenCallback = {
            self.parentViewController?.presentAudioFullscreen(withMediaParams: mediaParams)
        }
    }
    
    // MARK: - Dimensions
    
    public static var defaultSize: CGSize {
        var defaultSize = UIScreen.main.bounds.size
        
        defaultSize.height = 140
        
        return defaultSize
    }
}
