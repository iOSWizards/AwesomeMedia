//
//  AwesomeMediaVideoViewController.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/4/18.
//

import UIKit

public class AwesomeMediaVideoViewController: UIViewController {

    @IBOutlet public weak var playerView: AwesomeMediaView!
    
    public var mediaParams: AwesomeMediaParams = [:]
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        playerView.configure(withMediaParams: mediaParams,
                             controls: .all,
                             states: .standard,
                             titleViewVisible: true)
        playerView.controlView?.fullscreenCallback = {
            self.close()
        }
        playerView.titleView?.closeCallback = {
            sharedAVPlayer.stop()
            self.close()
        }
        playerView.finishedPlayingCallback = {
            self.close()
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if AwesomeMediaManager.shared.mediaIsLoading(withParams: mediaParams) {
            playerView.startLoadingAnimation()
        }
    }
    
}

extension AwesomeMediaVideoViewController {
    fileprivate func close() {
        dismiss(animated: true) {
            // dismiss callback
        }
    }
}

// MARK: - ViewController Initialization

extension AwesomeMediaVideoViewController {
    public static var newInstance: AwesomeMediaVideoViewController {
        let storyboard = UIStoryboard(name: "AwesomeMedia", bundle: AwesomeMedia.bundle)
        
        return storyboard.instantiateViewController(withIdentifier: "AwesomeMediaVideoViewController") as! AwesomeMediaVideoViewController
    }
}

