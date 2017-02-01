//
//  ViewController.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 01/16/2017.
//  Copyright (c) 2017 Evandro Harrison Hoffmann. All rights reserved.
//

import UIKit
import AwesomeMedia

class MediaViewController: UIViewController {

    @IBOutlet weak var mediaView: AwesomeMediaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AwesomeMedia.shared.playerDelegate = self
        AwesomeMedia.showLogs = true
        mediaView.prepareMedia(withUrl: URL(string: "http://overmind2.mindvalleyacademy.com/api/v1/assets/267bb3c6-d042-40ea-b1bd-9c9325c413eb.m3u8")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AwesomeMedia.shared.addOrientationObserverGoingLandscape(observer: self, selector: #selector(MediaViewController.goToLandscapeController))
        
        mediaView.addPlayerLayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AwesomeMedia.shared.removeOrientationObservers(self)
    }
    
    func goToLandscapeController() {
        performSegue(withIdentifier: "presentFullScreenSegue", sender: self)
    }

}

extension MediaViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}

extension MediaViewController: AwesomeMediaPlayerDelegate {
    
    public func didChangeSpeed(to: Float) {
        print("MediaViewController didChangeSpeed(\(to))")
    }
    
    public func didChangeSlider(to: Float) {
        print("MediaViewController didChangeSlider(\(to))")
    }
    
    public func didStopPlaying() {
        print("MediaViewController didStopPlaying")
    }
    
    public func didStartPlaying() {
        print("MediaViewController didStartPlaying")
    }
    
    public func didPausePlaying() {
        print("MediaViewController didPausePlaying")
    }
    
    public func didFinishPlaying() {
        print("FullscreenMediaViewController didFinishPlaying")
    }
    
    public func didFailPlaying() {
        print("FullscreenMediaViewController didFailPlaying")
    }
    
}
