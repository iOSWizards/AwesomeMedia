//
//  AwesomeMediaYoutubeView.swift
//  AwesomeMedia
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 28/05/18.
//

import Foundation
import AwesomeImage
import youtube_ios_player_helper

open class AwesomeMediaYoutubeView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var youtubePlayerView: YTPlayerView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var overlayerView: UIView!
    
    // Private variables
    private var playsInLine: Bool = true
    fileprivate var bufferTimer: Timer?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        addObservers()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle(for: AwesomeMediaYoutubeView.self).loadNibNamed("AwesomeMediaYoutubeView", owner: self, options: nil)
        
        if !playsInLine {
            /*let gesture = UITapGestureRecognizer.init(target: self, action: #selector(playVideo))
            contentView.addGestureRecognizer(gesture)
            contentView.isUserInteractionEnabled = true*/
            youtubePlayerView.isHidden = true
        }
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        youtubePlayerView.delegate = self
        AwesomeMediaManager.shared.youtubePlayerView = youtubePlayerView
    }
    
}

// MARK: - Media Information

extension AwesomeMediaYoutubeView {
    
    public func loadCoverImage(with mediaParams: AwesomeMediaParams) {
        guard let coverImageUrl = mediaParams.coverUrl else {
            return
        }
        
        // set the cover image
        coverImageView.setImage(coverImageUrl)
    }
}

// MARK: - UI Helper

extension AwesomeMediaYoutubeView {
    func showCoverAndPlay(_ enable: Bool) {
        guard self.overlayerView.isHidden != !enable else {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayerView.alpha = enable ? 1 : 0
        }, completion: { (_) in
            self.overlayerView.isHidden = !enable
        })
    }
}

// MARK: - Actions

extension AwesomeMediaYoutubeView {
    
    @IBAction func playVideo(_ sender: UIButton) {
        showCoverAndPlay(false)
        sharedAVPlayer.stop()
        contentView.startLoadingAnimation()
        youtubePlayerView.playVideo()
        startBufferTimer()
    }
    
    public func startBufferTimer() {
        cancelBufferTimer()
        bufferTimer = Timer.scheduledTimer(withTimeInterval: AwesomeMedia.bufferTimeout, repeats: false, block: { (timer) in
            self.parentViewController?.showMediaTimedOutAlert(onWait: {
                self.playVideo(self.playButton)
            }, onCancel: {
                self.reset()
            })
        })
    }
    
    public func cancelBufferTimer() {
        bufferTimer?.invalidate()
        bufferTimer = nil
    }
    
    public func reset() {
        youtubePlayerView.stopVideo()
        showCoverAndPlay(true)
        contentView.stopLoadingAnimation()
        cancelBufferTimer()
    }
    
}

// MARK: - Youtube Player

extension AwesomeMediaYoutubeView: YTPlayerViewDelegate {
    
    public func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if isPad {
            youtubePlayerView.webView?.allowsPictureInPictureMediaPlayback = false
            youtubePlayerView.webView?.allowsInlineMediaPlayback = false
            // these two lines above fix the problem of not playing on iPad
        }
        
        // ends custom animation at this moment
        contentView.stopLoadingAnimation()
        cancelBufferTimer()
        showCoverAndPlay(false)
        
        if state == .buffering {
            // it's buffering
        } else if state == .playing {
            // it's playing
        } else if state == .ended {
            reset()
        }
    }
}

// MARK: - Observers

extension AwesomeMediaYoutubeView: AwesomeMediaEventObserver {
    
    public func addObservers() {
        AwesomeMediaNotificationCenter.addObservers(.basic, to: self)
    }
    
    public func removeObservers() {
        AwesomeMediaNotificationCenter.removeObservers(from: self)
    }
    
    public func startedPlaying() {
        reset()
    }
    
    public func pausedPlaying() {
        reset()
    }
    
    public func stoppedPlaying() {
        
    }
    
    public func timeUpdated() {
        
    }
    
    public func startedBuffering() {
        reset()
    }
    
    public func stoppedBuffering() {
        reset()
    }
    
    public func finishedPlaying() {
        
    }
    
}
