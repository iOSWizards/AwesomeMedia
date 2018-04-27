//
//  AwesomeMediaVideoViewController.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/4/18.
//

import UIKit

public class AwesomeMediaVideoViewController: UIViewController {

    @IBOutlet public weak var playerView: AwesomeMediaView!
    
    // Public variables
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
        playerView.controlView?.jumpToCallback = {
            self.showMarkers(AwesomeMediaManager.markers(forParams: self.mediaParams)) { (mediaMarker) in
                if let mediaMarker = mediaMarker {
                    sharedAVPlayer.seek(toTime: mediaMarker.time)
                    sharedAVPlayer.play()
                }
            }
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
        
        // adds player layer in case it's not visible
        playerView.addPlayerLayer()
    }
    
    @IBAction func toggleControlsButtonPressed(_ sender: Any) {
        playerView.controlView?.toggleViewIfPossible()
    }
    
    // MARK: - Marker Selected
    public func markerSelected(marker: AwesomeMediaMarker) {
        
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

extension UIViewController {
    public func presentVideoFullscreen(withMediaParams mediaParams: AwesomeMediaParams) {
        let viewController = AwesomeMediaVideoViewController.newInstance
        viewController.mediaParams = mediaParams
        
        interactor = AwesomeMediaInteractor()
        viewController.transitioningDelegate = self
        viewController.interactor = interactor
        
        self.present(viewController, animated: true, completion: nil)
    }
}
