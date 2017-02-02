//
//  AwesomeMediaViewController.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 18/01/2017.
//
//

import UIKit
import AVFoundation

open class AwesomeMediaViewController: UIViewController, AwesomeMediaMarkersViewControllerDelegate {

    @IBOutlet open weak var mediaView: AwesomeMediaView!
    
    fileprivate var screenEdgePanGesture: UIScreenEdgePanGestureRecognizer!
    fileprivate var initialTouchPoint = CGPoint(x: 0, y: 0)
    fileprivate var awesomeMediaMarkersViewController: AwesomeMediaMarkersViewController?
    fileprivate var mediaMarkerStoryboardName = "Media"
    fileprivate var mediaMarkerViewControllerName = "Markers"
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction open func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Media Markers
    
    open func markerSelected(marker: AwesomeMediaMarker) {
        AwesomeMedia.shared.seek(toTime: marker.time)
    }
    
    // MARK: - Navigation
    
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? AwesomeMediaMarkersViewController {
            if let currentItem = AwesomeMedia.shared.avPlayer.currentItem {
                var currentTime = CMTimeGetSeconds(currentItem.currentTime())
                viewController.viewModel.currentTime = currentTime ?? 0
            }
            
            viewController.viewModel.markers = self.mediaView.viewModel.mediaMarkers
            viewController.viewModel.showHours = self.mediaView.viewModel.showHours
            viewController.delegate = self
        }
    }
}

// MARK: - Events

extension AwesomeMediaViewController {
    
    open func setup(mediaPath: String, coverImagePath: String? = nil, authorName: String? = nil, title: String? = nil, downloadPath: String? = nil, mediaMarkers: [AwesomeMediaMarker]? = nil, showHours: Bool = false, replaceCurrent: Bool = false, startPlaying: Bool = false) {
        mediaView.setup(mediaPath: mediaPath, coverImagePath: coverImagePath, authorName: authorName, title: title, downloadPath: downloadPath, mediaMarkers: mediaMarkers, showHours: showHours, replaceCurrent: replaceCurrent, startPlaying: startPlaying)
    }
    
}

extension AwesomeMediaViewController {
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
}

// MARK: - Screen Edge Pan

extension AwesomeMediaViewController {
    
    open func addEdgePanToOpenMarkers(storyboardName: String, viewControllerName: String){
        self.mediaMarkerStoryboardName = storyboardName
        self.mediaMarkerViewControllerName = viewControllerName
        
        screenEdgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(AwesomeMediaViewController.screenEdgePan(_:)))
        screenEdgePanGesture.edges = [.right]
        screenEdgePanGesture.delegate = self
        self.view.addGestureRecognizer(screenEdgePanGesture)
    }
    
    @IBAction func screenEdgePan(_ rec: UIPanGestureRecognizer) {
        
        let point: CGPoint = rec.location(in: self.view)
        let distance: CGPoint = CGPoint(x: point.x - initialTouchPoint.x, y: point.y - initialTouchPoint.y)
        
        switch rec.state {
        case .began:
            let storyboard = UIStoryboard(name: mediaMarkerStoryboardName, bundle: Bundle.main)
            awesomeMediaMarkersViewController = storyboard.instantiateViewController(withIdentifier: mediaMarkerViewControllerName) as! AwesomeMediaMarkersViewController
            awesomeMediaMarkersViewController?.openingFromPanning = true
            awesomeMediaMarkersViewController?.viewModel.markers = self.mediaView.viewModel.mediaMarkers
            awesomeMediaMarkersViewController?.viewModel.showHours = self.mediaView.viewModel.showHours
            awesomeMediaMarkersViewController?.delegate = self
            awesomeMediaMarkersViewController?.modalPresentationStyle = .overCurrentContext
            self.present(awesomeMediaMarkersViewController!, animated: false, completion: nil)
            
            initialTouchPoint = point
            break
        default:
            break
        }
        
        awesomeMediaMarkersViewController?.updateContentPosition(withDistance: distance, state: rec.state)
    }
}

//enables swipe to pop
extension AwesomeMediaViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
