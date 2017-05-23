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
    fileprivate var mediaDownloadLabel = "downloading_media"
    fileprivate var mediaAvailableOfflineLabel = "media_available_offline"
    
    @IBOutlet open weak var downloadLabel: UILabel?
    @IBOutlet open weak var downloadButton: UIButton?
    @IBOutlet open weak var downloadView: UIView?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        mediaView.requestPlayer()
        
    }
    
    @IBAction open func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Performs the media download or in case the file already exists
    /// shows an UIAlertController requesting delete confirmation.
    ///
    /// - Parameters:
    ///   - titleLocalized: UIAlertController title.
    ///   - messageLocalized: UIAlertController message.
    ///   - labelConfirmLocalized: UIALertController confirme button label.
    ///   - labelCancelLocalized: UIAlertController cancel label.
    ///   - actionView: UIView firing this action.
    open func downloadMedia(
        titleLocalized: String,
        messageLocalized: String,
        labelConfirmLocalized: String,
        labelCancelLocalized: String,
        actionView: UIView) {
        
        let mediaModel = self.mediaView.viewModel
        
        if AwesomeMediaDownloadState.downloaded == mediaModel.mediaDownloadState {
            confirmMediaDeletion(titleLocalized, messageLocalized, labelConfirmLocalized,  labelCancelLocalized, actionView)
        } else {
            
            self.updateDownloadView(.downloading, animated: true)
            
            // we should start downloading the media.
            mediaModel.downloadMedia({
                self.updateDownloadView(mediaModel.mediaDownloadState, animated: true)
            }, failure: {
                self.updateDownloadView(mediaModel.mediaDownloadState, animated: true)
            })
        }
        
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
    
    // MARK: - Helpers
    
    fileprivate var downloadableFileDescription: String {
        guard let fileSize = mediaView.viewModel.mediaFileSizeDescription else {
            return mediaDownloadLabel
        }
        return "\(fileSize) - \(mediaDownloadLabel)"
    }
    
    private func confirmMediaDeletion(_ title: String, _ message: String, _ labelConfirm: String, _ labelCancel: String, _ actionPresenter: UIView) {
        
        // we should delete the media.
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: labelConfirm, style: .destructive, handler: { (action) in
            self.mediaView.viewModel.deleteDownloadedMedia(completion: {(deleted) in
                self.updateDownloadView(self.mediaView.viewModel.mediaDownloadState, animated: true)
            })
        }))
        
        alertController.popoverPresentationController?.sourceView = actionPresenter
        alertController.popoverPresentationController?.sourceRect = actionPresenter.bounds
        
        alertController.addAction(UIAlertAction(title: labelCancel, style: .cancel, handler: { (action) in
            
        }))
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Events

extension AwesomeMediaViewController {
    
    open func setup(
        mediaPath: String,
        coverImagePath: String? = nil,
        authorName: String? = nil,
        title: String? = nil,
        downloadPath: String? = nil,
        mediaFileSizeDescription: String? = nil,
        mediaDownloadLabelLocalized: String? = nil,
        mediaAvailableOfflineLabelLocalized: String? = nil,
        mediaMarkers: [AwesomeMediaMarker]? = nil,
        showHours: Bool = false,
        replaceCurrent: Bool = false,
        startPlaying: Bool = false) {
        
        if let localizedLabel = mediaAvailableOfflineLabelLocalized, !localizedLabel.isEmpty {
            self.mediaAvailableOfflineLabel = localizedLabel
        }
        if let localizedLabel = mediaDownloadLabelLocalized, !localizedLabel.isEmpty {
            self.mediaDownloadLabel = localizedLabel
        }
        
        mediaView.setup(
            mediaPath: mediaPath,
            coverImagePath: coverImagePath,
            authorName: authorName,
            title: title,
            downloadPath: downloadPath,
            mediaFileSizeDescription: mediaFileSizeDescription,
            mediaMarkers: mediaMarkers,
            showHours: showHours,
            replaceCurrent: replaceCurrent,
            startPlaying: startPlaying
        )
        
        // we're updating the Download View state.
        changeDownloadView(mediaView.viewModel.mediaDownloadState)
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

// MARK: - Download media

extension AwesomeMediaViewController {
    
    open func updateDownloadView(_ toState: AwesomeMediaDownloadState, animated: Bool){
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.changeDownloadView(toState)
                self.downloadView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }, completion: { (completed) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.downloadView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
            })
        }else{
            changeDownloadView(toState)
        }
    }
    
    open func changeDownloadView(_ toState: AwesomeMediaDownloadState) {
        switch toState {
        case .streaming:
            downloadLabel?.text = ""
            downloadView?.backgroundColor = UIColor.clear
            downloadButton?.isSelected = false
            break
            
        case .downloading:
            downloadLabel?.text = downloadableFileDescription
            downloadView?.backgroundColor = UIColor.init(white: 0, alpha: 0.43)
            downloadButton?.isSelected = false
            break
            
        case .downloaded:
            downloadLabel?.text = mediaAvailableOfflineLabel
            downloadView?.backgroundColor = UIColor.init(white: 0, alpha: 0.43)
            downloadButton?.isSelected = true
            break
        }
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
            awesomeMediaMarkersViewController = storyboard.instantiateViewController(withIdentifier: mediaMarkerViewControllerName) as? AwesomeMediaMarkersViewController
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
