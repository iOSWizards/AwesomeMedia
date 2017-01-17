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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AwesomeMedia.shared.playerDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
