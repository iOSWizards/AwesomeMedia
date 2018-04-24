//
//  AwesomeMediaAudioViewController.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/23/18.
//

import UIKit

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

    // Public Variaables
    public var mediaParams: AwesomeMediaParams = [:]
    
    // Private Variables
    fileprivate var downloadState: AwesomeMediaDownloadState = .none

    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // Configure
    fileprivate func configure() {
        configureControls()
        updateDownloadControlState()
        loadCoverImage()
        addObservers()
        play()
    }
    
    fileprivate func configureControls() {
        controlView.configure(withParams: mediaParams)
        
        // play/pause
        controlView.playCallback = { (isPlaying) in
            if isPlaying {
                self.play()
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
        
    }
    
    // MARK: - Events

    @IBAction func minimizeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func airplayButtonPressed(_ sender: Any) {
        view.showAirplayMenu()
    }
    
    @IBAction func downloadButtonPressed(_ sender: Any) {
        downloadState = .downloading
        updateDownloadControlState()
    }
    
    fileprivate func play() {
        AwesomeMediaManager.shared.playMedia(
            withParams: self.mediaParams,
            inPlayerLayer: AwesomeMediaPlayerLayer.shared)
    }
}

// MARK: - Media Information

extension AwesomeMediaAudioViewController {
    
    public func loadCoverImage() {
        guard let coverImageUrl = AwesomeMediaManager.coverUrl(forParams: mediaParams) else {
            return
        }
        
        // set the cover image
        coverImageView.setImage(coverImageUrl.absoluteString)
    }
    
    // update download state
    public func updateDownloadControlState() {
        switch downloadState {
        case .downloading:
            downloadButton.isHidden = true
            downloadStateStackView.isHidden = false
        case .downloaded:
            downloadButton.isHidden = true
            downloadStateStackView.isHidden = false
        default:
            downloadButton.isHidden = false
            downloadStateStackView.isHidden = true
        }
    }
}

// MARK: - Observers

extension AwesomeMediaAudioViewController: AwesomeMediaEventObserver {
    
    public func addObservers() {
        AwesomeMediaNotificationCenter.addObservers([.basic, .timeUpdated], to: self)
    }
    
    public func startedPlaying() {
        guard sharedAVPlayer.isPlaying(withParams: mediaParams) else {
            return
        }
        
        controlView.playButton.isSelected = true
        
        // update Control Center
        AwesomeMediaControlCenter.updateControlCenter(withParams: mediaParams)
    }
    
    public func pausedPlaying() {
        controlView.playButton.isSelected = sharedAVPlayer.isPlaying(withParams: mediaParams)
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
    }
    
    public func finishedPlaying() {
        controlView.playButton.isSelected = false
        
        controlView.lock(false, animated: true)
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
