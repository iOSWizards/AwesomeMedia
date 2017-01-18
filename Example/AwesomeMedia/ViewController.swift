//
//  ViewController.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 01/16/2017.
//  Copyright (c) 2017 Evandro Harrison Hoffmann. All rights reserved.
//

import UIKit
import AwesomeMedia

class ViewController: UIViewController {

    @IBOutlet weak var mediaView: AwesomeMediaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AwesomeMedia.shared.playerDelegate = self
        AwesomeMedia.showLogs = true
        mediaView.prepareMedia(withUrl: URL(string: "http://overmind2.mindvalleyacademy.com/api/v1/assets/267bb3c6-d042-40ea-b1bd-9c9325c413eb.m3u8")!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension UIViewController: AwesomeMediaPlayerDelegate {
    
    
    public func didChangeSpeed(to: Float) {
        // do anything (tracking)
    }
    
    public func didChangeSlider(to: Float) {
        
    }
    
    public func didStopPlaying(stop: Bool) {
        
    }
    
    public func didStartPlaying(start: Bool) {
        
    }
    
    public func didPausePlaying(pause: Bool) {
        
    }
    

    
}
