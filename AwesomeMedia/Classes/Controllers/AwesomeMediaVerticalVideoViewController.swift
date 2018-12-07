//
//  AwesomeMediaAudioSoulvanaViewController.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 8/8/18.
//

import UIKit
import AVKit

public class AwesomeMediaVerticalVideoViewController: UIViewController {
    
    @IBOutlet public weak var mediaView: UIView!
    @IBOutlet public weak var authorImageView: UIImageView!
    @IBOutlet public weak var authorNameLabel: UILabel!
    @IBOutlet public weak var aboutAudioTextView: UITextView!
    @IBOutlet public weak var coverImageView: UIImageView!
    @IBOutlet public weak var minimizeButton: UIButton!
    @IBOutlet public weak var toggleControlsButton: UIButton!
    @IBOutlet public weak var shareButton: UIButton!
    @IBOutlet public weak var controlView: AwesomeMediaAudioControlView!
    
    // Public Variaables
    public var mediaParams = AwesomeMediaParams()
    
    // Private Variables
    fileprivate var backgroundPlayer = AVPlayer()
    fileprivate var backgroundPlayerLayer = AwesomeMediaPlayerLayer.newInstance
    
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
    
    /*public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // track event
        track(event: .changedOrientation, source: .audioFullscreen, value: UIApplication.shared.statusBarOrientation)
    }*/
    
    public override var shouldAutorotate: Bool {
        return false
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // Configure
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundPlayerLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    fileprivate func configure() {
        configureControls()
        loadCoverImage()
        setupAuthorInfo()
        play()
        
        // add background video
        //configureBackgroundVideo()
        
        // Refresh controls
        refreshControls()
        
        // check for loading state
        authorImageView.stopLoadingAnimation()
        if AwesomeMediaManager.shared.mediaIsLoading(withParams: mediaParams) {
            authorImageView.startLoadingAnimation()
        }
        
        // check for media playing
        if let item = sharedAVPlayer.currentItem(withParams: mediaParams) {
            controlView?.update(withItem: item)
            backgroundPlayer.play()
        } else {
            sharedAVPlayer.pause()
        }
    }
    
    fileprivate func setupAuthorInfo() {
        authorImageView.setImage(mediaParams.coverUrl)
        authorNameLabel.text = mediaParams.author
        aboutAudioTextView.text = mediaParams.about
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func configureControls() {
        controlView.configure(withParams: mediaParams, trackingSource: .audioFullscreen)
        
        // show or hide sharing and favourite buttons
        configureSharingAndFavourite()
        
        // play/pause
        controlView.playCallback = { (isPlaying) in
            if isPlaying {
                self.play()
                //self.controlView.setupAutoHide()
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
        
        // Forward
        controlView.forwardCallback = {
            sharedAVPlayer.seekForward()
        }
        
        // Favourite
        controlView.favouriteCallback = { (isFavourited) in
            if isFavourited {
                notifyMediaEvent(.favourited, object: self.mediaParams as AnyObject)
            } else {
                notifyMediaEvent(.unfavourited, object: self.mediaParams as AnyObject)
            }
        }
        
    }
    
    fileprivate func configureBackgroundVideo() {
        guard let backgroundStringUrl = mediaParams.backgroundUrl, let backgroundUrl = URL(string: backgroundStringUrl) else {
            return
        }
        
        // configure player item
        let playerItem = AVPlayerItem(url: backgroundUrl)
        backgroundPlayer.replaceCurrentItem(with: playerItem)
        backgroundPlayer.isMuted = true
        
        // configures autoplay loop
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerItem, queue: .main) { _ in
            self.backgroundPlayer.seek(to: kCMTimeZero)
            self.backgroundPlayer.play()
        }
        
        // add player layer
        backgroundPlayerLayer.player = backgroundPlayer
        backgroundPlayerLayer.backgroundColor = nil
        mediaView.addPlayerLayer(backgroundPlayerLayer)
    }
    
    // MARK: - Events
    
    @IBAction func minimizeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        // track event
        track(event: .toggleFullscreen, source: .audioFullscreen)
    }
    
    @IBAction func toggleControls(_ sender: Any) {
        controlView.show()
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        
        guard let sharingItems = self.mediaParams.sharingItems else {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        
        self.present(activityViewController, animated: true, completion: nil)
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
    
    fileprivate func configureSharingAndFavourite() {
        
        // show or hide shareButton
        showButton( mediaParams.sharingItems != nil, button: shareButton)
        
        // show or hide favouriteButton
        showButton(mediaParams.favourited != nil, button: controlView.favouriteButton)
        
        if let favourited = mediaParams.favourited {
            controlView.favouriteButton?.isSelected = favourited
        }
    }
    
    fileprivate func showButton(_ show: Bool, button: UIButton?) {
        button?.isUserInteractionEnabled = show
        button?.alpha = show ? 1.0 : 0
    }
}

// MARK: - Media Information

extension AwesomeMediaVerticalVideoViewController {
    
    public func loadCoverImage() {
        guard let coverImageUrl = mediaParams.coverUrl else {
            return
        }
        
        // set the cover image
        coverImageView.setImage(coverImageUrl)
    }
}

// MARK: - Observers

extension AwesomeMediaVerticalVideoViewController: AwesomeMediaEventObserver {
    
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
        
        // play background
        backgroundPlayer.play()
    }
    
    public func pausedPlaying() {
        controlView.playButton.isSelected = sharedAVPlayer.isPlaying(withParams: mediaParams)
        
        // cancels auto hide
        controlView.show()
        
        // pause background
        backgroundPlayer.pause()
    }
    
    public func stoppedPlaying() {
        pausedPlaying()
        stoppedBuffering()
        finishedPlaying()
        
        // remove media alert if present
        removeAlertIfPresent()
        
        // cancels auto hide
        controlView.show()
        
        // pause background
        backgroundPlayer.pause()
    }
    
    public func startedBuffering() {
        guard sharedAVPlayer.isCurrentItem(withParams: mediaParams) else {
            stoppedBuffering()
            return
        }
        
        authorImageView.startLoadingAnimation()
        
        controlView.lock(true, animated: true)
        configureSharingAndFavourite()
        
        // cancels auto hide
        controlView.show()
        
        // pauses background
        backgroundPlayer.pause()
    }
    
    public func stoppedBuffering() {
        authorImageView.stopLoadingAnimation()
        
        controlView.lock(false, animated: true)
        configureSharingAndFavourite()
        
        // remove media alert if present
        removeAlertIfPresent()
        
        // setup auto hide
        //controlView?.setupAutoHide()
        
        // play background
        backgroundPlayer.play()
    }
    
    public func finishedPlaying() {
        controlView.playButton.isSelected = false
        
        controlView.lock(false, animated: true)
        configureSharingAndFavourite()
        
        // pause background
        backgroundPlayer.pause()
        
        // close Player
        dismiss(animated: true, completion: nil)
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

extension AwesomeMediaVerticalVideoViewController {
    public static var newInstance: AwesomeMediaVerticalVideoViewController {
        let storyboard = UIStoryboard(name: "AwesomeMedia", bundle: AwesomeMedia.bundle)
        
        return storyboard.instantiateViewController(withIdentifier: "AwesomeMediaVerticalVideoViewController") as! AwesomeMediaVerticalVideoViewController
    }
}

extension UIViewController {
    public func presentVerticalVideoFullscreen(withMediaParams mediaParams: AwesomeMediaParams) {
        AwesomeMediaPlayerType.type = .verticalVideo
        
        let viewController = AwesomeMediaVerticalVideoViewController.newInstance
        viewController.mediaParams = mediaParams
        
        interactor = AwesomeMediaInteractor()
        viewController.transitioningDelegate = self
        viewController.interactor = interactor
        
        self.present(viewController, animated: true, completion: nil)
    }
}
