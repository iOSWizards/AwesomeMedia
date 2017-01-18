//
//  FullscreenMediaViewController.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 18/01/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import AwesomeMedia

class FullscreenMediaViewController: AwesomeMediaViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AwesomeMedia.shared.playerDelegate = self
        prepareMedia(withUrl: URL(string: "http://overmind2.mindvalleyacademy.com/api/v1/assets/267bb3c6-d042-40ea-b1bd-9c9325c413eb.m3u8")!)
    }
}

extension FullscreenMediaViewController: AwesomeMediaPlayerDelegate {
    
    public func didChangeSpeed(to: Float) {
        print("FullscreenMediaViewController didChangeSpeed(\(to))")
    }
    
    public func didChangeSlider(to: Float) {
        print("FullscreenMediaViewController didChangeSlider(\(to))")
    }
    
    public func didStopPlaying(stop: Bool) {
        print("FullscreenMediaViewController didStopPlaying")
    }
    
    public func didStartPlaying(start: Bool) {
        print("FullscreenMediaViewController didStartPlaying")
    }
    
    public func didPausePlaying(pause: Bool) {
        print("FullscreenMediaViewController didPausePlaying")
    }
}
