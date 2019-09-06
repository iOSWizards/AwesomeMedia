//
//  AwesomeMediaAudioViewController.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/23/18.
//

import UIKit
import AwesomeDownloading

public class AwesomeMediaAudioViewController: UIViewController {
    
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var controlView: AwesomeMediaAudioControlView!
    @IBOutlet weak var minimizeButton: UIButton!
    @IBOutlet weak var topControlsStackView: UIStackView!
    @IBOutlet weak var airplayButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var downloadStateStackView: UIStackView!
    @IBOutlet weak var downloadStateLabel: UILabel!
    @IBOutlet weak var downloadStateImageView: UIImageView!
    @IBOutlet weak var downloadProgressView: UIProgressView!
    
    // Public Variaables
    public var mediaParams = AwesomeMediaParams()
    
    // Private Variables
    fileprivate var downloadState: AwesomeMediaDownloadState = .none

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure controller
        configure()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add observers
        addObservers()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove observers
        removeObservers()
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // track event
        track(event: .changedOrientation, source: .audioFullscreen, value: UIApplication.shared.statusBarOrientation)
    }
    
    // Configure
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateAppearance(isPortrait: UIApplication.shared.statusBarOrientation.isPortrait)
    }
    
    fileprivate func configure() {
        configureControls()
        refreshDownloadState()
        loadCoverImage()
        play()
        
        // Refresh controls
        refreshControls()
        
        // check for loading state
        coverImageView.stopLoadingAnimation()
        if AwesomeMediaManager.shared.mediaIsLoading(withParams: mediaParams) {
            coverImageView.startLoadingAnimation()
        }
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func configureControls() {
        controlView.configure(withParams: mediaParams, trackingSource: .audioFullscreen)
        
        // play/pause
        controlView.playCallback = { [weak self] (isPlaying) in
            if isPlaying {
                self?.play()
            } else {
                sharedAVPlayer.pause()
            }
        }
        
        // seek slider
        controlView.timeSliderChangedCallback = { (time) in
            sharedAVPlayer.seek(toTime: time)
        }
        controlView.timeSliderFinishedDraggingCallback = { (play) in
            if play {
                sharedAVPlayer.play()
            }
        }
        
        // Rewind
        controlView.rewindCallback = {
            sharedAVPlayer.seekBackward()
        }
        
        // Speed
        controlView.speedToggleCallback = {
            sharedAVPlayer.toggleSpeed()
        }
        
    }
    
    public func updateAppearance(isPortrait: Bool) {
        contentStackView.axis = isPortrait ? .vertical : .horizontal
        contentStackView.alignment = (isPortrait || isPhone) ? .fill : .center
        contentStackView.spacing = (isPortrait || isPhone) ? 0 : 60
    }
    
    // MARK: - Events

    @IBAction func minimizeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        // track event
        track(event: .toggleFullscreen, source: .audioFullscreen)
    }
    
    @IBAction func airplayButtonPressed(_ sender: Any) {
        view.showAirplayMenu()
        
        // track event
        track(event: .tappedAirplay, source: .audioFullscreen)
    }
    
    @IBAction func downloadButtonPressed(_ sender: Any) {
        switch downloadState {
        case .downloaded:
            deleteMedia()
        case .downloading:
            break
        default:
            downloadMedia()
        }
        
        // track event
        track(event: .tappedDownload, source: .audioFullscreen)
    }
    
    fileprivate func downloadMedia() {
        downloadState = .downloading
        updateDownloadState()
        
        downloadProgressView.progress = 0
        
        AwesomeDownloading.downloadMedia(withUrl: mediaParams.url?.url, completion: { (success) in
            self.refreshDownloadState()
            
            if success, sharedAVPlayer.isPlaying {
                // play offline media
                sharedAVPlayer.stop()
                self.play()
            }
        }, progressUpdated: {(progress) in
            self.downloadProgressView.progress = progress
        })
        
    }
    
    fileprivate func deleteMedia() {
        sharedAVPlayer.stop()
        self.confirmMediaDeletion(withUrl: mediaParams.url?.url,
                                  fromView: downloadButton,
                                  withTitle: "availableoffline_delete_title".localized,
                                  withMessage: "availableoffline_delete_message".localized,
                                  withConfirmButtonTitle: "availableoffline_delete_button_confirm".localized,
                                  withCancelButtonTitle: "availableoffline_delete_button_cancel".localized,
                                  completion: {(success) in
                                    if success {
                                        // play online media
                                        sharedAVPlayer.stop()
                                        self.play()
                                        
                                        // update download button
                                        self.refreshDownloadState()
                                    }
                                    
                                    // track event
                                    track(event: .deletedDownload, source: .audioFullscreen)
        })
        
    }
    
    fileprivate func play() {
        AwesomeMediaManager.shared.playMedia(
            withParams: self.mediaParams,
            inPlayerLayer: AwesomeMediaPlayerLayer.shared,
            viewController: self)
    }
    
    fileprivate func refreshControls() {
        // update slider
        timeUpdated()
        
        // update play button state
        controlView.playButton.isSelected = sharedAVPlayer.isPlaying(withParams: mediaParams)
    }
}

// MARK: - Media Information

extension AwesomeMediaAudioViewController {
    
    public func loadCoverImage() {
        guard let coverImageUrl = mediaParams.coverUrl else {
            return
        }
        
        // set the cover image
        coverImageView.setImage(coverImageUrl)
    }
    
    // update download state
    public func refreshDownloadState() {
        downloadState = AwesomeDownloading.mediaDownloadState(withUrl: mediaParams.url?.url)
        
        updateDownloadState()
    }
    
    public func updateDownloadState() {
        switch downloadState {
        case .downloading:
            downloadButton.isHidden = true
            downloadStateStackView.isHidden = false
            
            if let size = mediaParams.size {
                downloadStateLabel.text = "\(size.uppercased()) - \("downloading".localized)"
            } else {
                downloadStateLabel.text = "downloading".localized
            }
            downloadStateImageView.image = UIImage(named: "btnDownload", in: Bundle(for: AwesomeMedia.self), compatibleWith: nil)
            
        case .downloaded:
            downloadButton.isHidden = true
            downloadStateStackView.isHidden = false
            downloadStateLabel.text = "availableoffline".localized
            downloadStateImageView.image = UIImage(named: "icoOfflineAudio", in: Bundle(for: AwesomeMedia.self), compatibleWith: nil)

        default:
            downloadButton.isHidden = false
            downloadStateStackView.isHidden = true
        }
    }
}

// MARK: - Observers

extension AwesomeMediaAudioViewController: AwesomeMediaEventObserver {
    
    public func addObservers() {
        AwesomeMediaNotificationCenter.addObservers([.basic, .timeUpdated, .speedRateChanged, .timedOut, .stopped], to: self)
    }
    
    public func removeObservers() {
        AwesomeMediaNotificationCenter.removeObservers(from: self)
    }
    
    public func startedPlaying() {
        guard sharedAVPlayer.isPlaying(withParams: mediaParams) else {
            return
        }
        
        controlView.playButton.isSelected = true
        
        // update Control Center
        AwesomeMediaControlCenter.updateControlCenter(withParams: mediaParams)
        
        // remove media alert if present
        removeAlertIfPresent()
    }
    
    public func pausedPlaying() {
        controlView.playButton.isSelected = sharedAVPlayer.isPlaying(withParams: mediaParams)
    }
    
    public func stoppedPlaying() {
        pausedPlaying()
        stoppedBuffering()
        finishedPlaying()
        
        // remove media alert if present
        removeAlertIfPresent()
    }
    
    public func startedBuffering() {
        guard sharedAVPlayer.isCurrentItem(withParams: mediaParams) else {
            stoppedBuffering()
            return
        }
        
        coverImageView.startLoadingAnimation()
        
        controlView.lock(true, animated: true)
    }
    
    public func stoppedBuffering() {
        coverImageView.stopLoadingAnimation()
        
        controlView.lock(false, animated: true)
        
        // remove media alert if present
        removeAlertIfPresent()
    }
    
    public func finishedPlaying() {
        controlView.playButton.isSelected = false
        
        controlView.lock(false, animated: true)
    }
    
    public func timedOut() {
        showMediaTimedOutAlert()
    }
    
    public func speedRateChanged() {
        controlView.speedLabel?.text = AwesomeMediaSpeed.speedLabelForCurrentSpeed
    }
    
    public func timeUpdated() {
        guard let item = sharedAVPlayer.currentItem(withParams: mediaParams) else {
            return
        }
        
        //AwesomeMedia.log("Current time updated: \(item.currentTime().seconds) of \(CMTimeGetSeconds(item.duration))")
        
        // update time controls
        controlView?.update(withItem: item)
    }
}

// MARK: - ViewController Initialization

extension AwesomeMediaAudioViewController {
    public static var newInstance: AwesomeMediaAudioViewController {
        let storyboard = UIStoryboard(name: "AwesomeMedia", bundle: AwesomeMedia.bundle)
        
        return storyboard.instantiateViewController(withIdentifier: "AwesomeMediaAudioViewController") as! AwesomeMediaAudioViewController
    }
}

extension UIViewController {
    public func presentAudioFullscreen(withMediaParams mediaParams: AwesomeMediaParams) {
        AwesomeMediaPlayerType.type = .audio
        
        let viewController = AwesomeMediaAudioViewController.newInstance
        viewController.mediaParams = mediaParams
        
        interactor = AwesomeMediaInteractor()
        viewController.modalPresentationStyle = .fullScreen
        viewController.transitioningDelegate = self
        viewController.interactor = interactor
        
        self.present(viewController, animated: true, completion: nil)
    }
}
