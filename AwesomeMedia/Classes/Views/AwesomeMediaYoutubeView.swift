//
//  AwesomeMediaYoutubeView.swift
//  AwesomeMedia
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 28/05/18.
//

import Foundation
import AwesomeImage
import WebKit

open class AwesomeMediaYoutubeView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var overlayerView: UIView!
    
    // Private variables
    private var playsInLine: Bool = true
    fileprivate var bufferTimer: Timer?
    var isLoadingYoutube: Bool = false
    var url: String = ""
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle(for: AwesomeMediaYoutubeView.self).loadNibNamed("AwesomeMediaYoutubeView", owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
    
    public func loadVideoUrl(with mediaParams: AwesomeMediaParams) {
        guard let url = mediaParams.youtubeUrl else {
            return
        }
        
        self.url = url
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
    
    func playYoutubeVideo() {
        
        if isLoadingYoutube { return }
        isLoadingYoutube = true
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = false
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        
        contentView.addSubview(webView)
        let youtubeURL = URL(string: url)
        
        webView.loadHTMLString("<video width=\"320\" height=\"240\" autoplay> <source src=\"movie.mp4\" type=\"video/mp4\"></video>", baseURL: nil)
        webView.load(URLRequest(url: youtubeURL!))
        
    }
    
    @IBAction func playVideo(_ sender: UIButton) {
        //        showCoverAndPlay(false)
        sharedAVPlayer.stop()
        playYoutubeVideo()
        //        youtubePlayerView.playVideo()
        //        startBufferTimer()
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
        //        youtubePlayerView.stopVideo()
        showCoverAndPlay(true)
        contentView.stopLoadingAnimation()
        cancelBufferTimer()
    }
    
}

extension AwesomeMediaYoutubeView: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        contentView.startLoadingAnimation()
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        isLoadingYoutube = false
        contentView.stopLoadingAnimation()
    }
    
}
