//
//  AwesomeMediaAudioControlView.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/23/18.
//

import UIKit

public class AwesomeMediaAudioControlView: AwesomeMediaControlView {
    
    @IBOutlet public weak var titleLabel: UILabel!
    
    // Configuration
    public func configure(withParams params: AwesomeMediaParams, trackingSource: AwesomeMediaTrackingSource) {
        self.trackingSource = trackingSource
        
        titleLabel.text = params.title
        
        reset()
    }

    override public func toggleView() {
        cancelAutoHide()
        
        if isHidden {
            animateFadeIn {
                self.setupAutoHide()
            }
        } else {
            animateFadeOut {
                self.isHidden = true
            }
        }
        
        toggleViewCallback?(isHidden)
    }
}
