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
        setup(mediaPath: "http://overmind2.mindvalleyacademy.com/api/v1/assets/267bb3c6-d042-40ea-b1bd-9c9325c413eb.m3u8")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AwesomeMedia.shared.addOrientationObserverGoingPortrait(observer: self, selector: #selector(FullscreenMediaViewController.returnToPortraitController))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AwesomeMedia.shared.removeOrientationObservers(self)
    }
    
    func returnToPortraitController() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension FullscreenMediaViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if(UIDevice.current.userInterfaceIdiom == .pad) {
            return UIInterfaceOrientationMask.all
        }
        return UIInterfaceOrientationMask.landscape
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}

extension FullscreenMediaViewController: AwesomeMediaPlayerDelegate {
    
    public func didChangeSpeed(to: Float, mediaType: MVMediaType) {
        print("MediaViewController didChangeSpeed(\(to))")
    }
    
    public func didChangeSlider(to: Float, mediaType: MVMediaType) {
        print("MediaViewController didChangeSlider(\(to))")
    }
    
    public func didStopPlaying(mediaType: MVMediaType) {
        print("MediaViewController didStopPlaying")
    }
    
    public func didStartPlaying(mediaType: MVMediaType) {
        print("MediaViewController didStartPlaying")
    }
    
    public func didPausePlaying(mediaType: MVMediaType) {
        print("MediaViewController didPausePlaying")
    }
    
    public func didFinishPlaying(mediaType: MVMediaType) {
        print("FullscreenMediaViewController didFinishPlaying")
    }
    
    public func didFailPlaying(mediaType: MVMediaType) {
        print("FullscreenMediaViewController didFailPlaying")
    }
}

extension FullscreenMediaViewController: AwesomeMediaViewDelegate {
    
    public func didToggleControls(show: Bool) {
        print("FullscreenMediaViewController didToggleControls: \(show)")
    }
}

