//
//  AwesomeMediaVideoViewController.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/4/18.
//

import UIKit

public class AwesomeMediaVideoViewController: UIViewController {
    
    public static var presentingVideoInFullscreen = false

    @IBOutlet public weak var playerView: AwesomeMediaView!
    
    // Public variables
    public var mediaParams = AwesomeMediaParams()
    var controls: AwesomeMediaVideoControls = .all
    var startOnTime: Double?
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        playerView.configure(withMediaParams: mediaParams,
                             controls: controls,
                             states: .standard,
                             trackingSource: .videoFullscreen,
                             titleViewVisible: true,
                             startOnTime: startOnTime)
        playerView.controlView?.fullscreenCallback = {
            self.close()
            
            // track event
            track(event: .toggleFullscreen, source: .videoFullscreen)
        }
        playerView.controlView?.jumpToCallback = {
            self.showMarkers(self.mediaParams.markers) { (mediaMarker) in
                if let mediaMarker = mediaMarker {
                    sharedAVPlayer.seek(toTime: mediaMarker.time)
                    sharedAVPlayer.play()
                }
            }
        }
        playerView.titleView?.closeCallback = {
            sharedAVPlayer.stop()
            self.close()
            
            // track event
            track(event: .closeFullscreen, source: .videoFullscreen)
            track(event: .stoppedPlaying, source: .videoFullscreen)
        }
        playerView.finishedPlayingCallback = {
            self.close()
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // adds player layer in case it's not visible
        playerView.addPlayerLayer()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AwesomeMediaVideoViewController.presentingVideoInFullscreen = false
        
        // remove observers when leaving
        playerView.removeObservers()
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // track event
        track(event: .changedOrientation, source: .audioFullscreen, value: UIApplication.shared.statusBarOrientation)
    }
    
    // MARK: Events
    
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
            if AwesomeMedia.shouldStopVideoWhenCloseFullScreen {
                sharedAVPlayer.stop()
                AwesomeMedia.shouldStopVideoWhenCloseFullScreen = false
            }
            AwesomeMediaVideoViewController.presentingVideoInFullscreen = false
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
    public func presentVideoFullscreen(withMediaParams mediaParams: AwesomeMediaParams,
                                       withControls controls: AwesomeMediaVideoControls = .all,
                                       startOnTime: Double? = nil) {
        guard !AwesomeMediaVideoViewController.presentingVideoInFullscreen else {
            return
        }
        AwesomeMediaPlayerType.type = .video
        AwesomeMediaVideoViewController.presentingVideoInFullscreen = true
        
        let viewController = AwesomeMediaVideoViewController.newInstance
        viewController.mediaParams = mediaParams
        viewController.controls = controls
        
        interactor = AwesomeMediaInteractor()
        viewController.transitioningDelegate = self
        viewController.interactor = interactor
        
        self.present(viewController, animated: true, completion: nil)
    }
}
