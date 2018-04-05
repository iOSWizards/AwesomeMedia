//
//  AwesomeMediaVideoViewController.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/4/18.
//

import UIKit

public class AwesomeMediaVideoViewController: UIViewController {

    @IBOutlet public weak var coverImageView: UIImageView!
    @IBOutlet public weak var playerView: AwesomeMediaView!
    @IBOutlet public weak var controlToggleButton: UIButton!

    public var controlView: AwesomeMediaVideoControlView?
    public var titleView: AwesomeMediaVideoTitleView?
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // add control view
        controlView = view.addVideoControls(withControls: [.rewind, .time, .playlist, .speed, .jumpto, .minimize])
        controlView?.toggleViewCallback = { (_) in
            self.titleView?.toggleView()
        }
        controlView?.fullscreenCallback = {
            self.dismiss(animated: true, completion: nil)
        }
        
        // play media
        controlView?.playCallback = { (isPlaying) in
            
            AwesomeMediaManager.shared.playMedia(withParams: [.url: "https://overmind2.mvstg.com/api/v1/assets/0af656fc-dcde-45ad-9b59-7632ca247001.m3u8"])
            self.playerView.avPlayerLayer.player = AwesomeMediaManager.shared.avPlayer
        }
        
        // add title view
        titleView = view.addVideoTitle()
        titleView?.closeCallback = {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Events
    
    @IBAction func controlToggleButtonPressed(_ sender: Any) {
        controlView?.toggleViewIfPossible()
    }
    
}

// MARK: - ViewController Initialization

extension AwesomeMediaVideoViewController {
    public static var newInstance: AwesomeMediaVideoViewController {
        let storyboard = UIStoryboard(name: "AwesomeMedia", bundle: AwesomeMedia.bundle)
        
        return storyboard.instantiateViewController(withIdentifier: "AwesomeMediaVideoViewController") as! AwesomeMediaVideoViewController
    }
}

