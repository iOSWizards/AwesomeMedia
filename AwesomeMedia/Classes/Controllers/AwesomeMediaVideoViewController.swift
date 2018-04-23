//
//  AwesomeMediaVideoViewController.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/4/18.
//

import UIKit

public class AwesomeMediaVideoViewController: UIViewController, AwesomeMediaMarkersViewControllerDelegate {

    @IBOutlet public weak var playerView: AwesomeMediaView!
    
    // Private Variables
    fileprivate var awesomeMediaMarkersViewController: AwesomeMediaMarkersViewController?
    fileprivate var screenEdgePanGesture: UIScreenEdgePanGestureRecognizer!
    fileprivate var initialTouchPoint = CGPoint(x: 0, y: 0)
    fileprivate var mediaMarkersStoryboardName = "AwesomeMedia"
    fileprivate var mediaMarkersViewControllerName = "MarkersVC"
    
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
        
        addEdgePanToOpenMarkers(storyboardName: "AwesomeMedia", viewControllerName: "MarkersVC")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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


// MARK - Selectors

fileprivate extension Selector {
    static let screenEdgePan = #selector(AwesomeMediaVideoViewController.screenEdgePan(_:))
}

// MARK: - Screen Edge Pan
extension AwesomeMediaVideoViewController {
    public func addEdgePanToOpenMarkers(storyboardName: String, viewControllerName: String) {
        self.mediaMarkersStoryboardName = storyboardName
        self.mediaMarkersViewControllerName = viewControllerName
        
        screenEdgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: .screenEdgePan)
        screenEdgePanGesture.edges = [.right]
        screenEdgePanGesture.delegate = self
        self.view.addGestureRecognizer(screenEdgePanGesture)
        
    }
    
    @objc func screenEdgePan(_ rec: UIPanGestureRecognizer) {
        let point: CGPoint = rec.location(in: self.view)
        let distance: CGPoint = CGPoint(x: point.x - initialTouchPoint.x, y: point.y - initialTouchPoint.y)
        
        switch rec.state {
        case .began:
            let storyboard = UIStoryboard(name: mediaMarkersStoryboardName, bundle: AwesomeMedia.bundle)
            awesomeMediaMarkersViewController = storyboard.instantiateViewController(withIdentifier: mediaMarkersViewControllerName) as? AwesomeMediaMarkersViewController
            awesomeMediaMarkersViewController?.isOpeningFromPanning = true
            awesomeMediaMarkersViewController?.delegate = self
            awesomeMediaMarkersViewController?.modalPresentationStyle = .overCurrentContext
            self.present(awesomeMediaMarkersViewController!, animated: false, completion: nil)
            
            initialTouchPoint = point
        default:
            break
        }
        
        awesomeMediaMarkersViewController?.updateContentPosition(withDistance: distance, state: rec.state)
    }
}

// MARK: Gesture Swipe to Pop
extension AwesomeMediaVideoViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

