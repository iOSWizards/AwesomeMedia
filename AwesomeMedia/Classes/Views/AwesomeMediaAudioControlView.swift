//
//  AwesomeMediaAudioControlView.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/23/18.
//

import UIKit

class AwesomeMediaAudioControlView: AwesomeMediaControlView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // Configuration
    public func configure(withParams params: AwesomeMediaParams, trackingSource: AwesomeMediaTrackingSource) {
        self.trackingSource = trackingSource
        
        titleLabel.text = AwesomeMediaManager.title(forParams: params)
        
        reset()
    }

}
