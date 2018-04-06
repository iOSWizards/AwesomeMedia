//
//  AwesomeMediaView.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/5/18.
//

import UIKit
import AVFoundation

public class AwesomeMediaView: UIView {

    public var avPlayerLayer = AVPlayerLayer()
    public var mediaParams: AwesomeMediaParams = [:]
    public var controlView: AwesomeMediaVideoControlView?

    public override func awakeFromNib() {
        super.awakeFromNib()
        
        avPlayerLayer.videoGravity = .resizeAspectFill
        
        addPlayerLayer()
        
        addObservers()
    }
    
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        avPlayerLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
    }
    
    public func addPlayerLayer(){
        self.layer.insertSublayer(avPlayerLayer, at: 0)
        self.layer.masksToBounds = true
    }
    
    public func configure(
        withMediaParams mediaParams: AwesomeMediaParams,
        controls: [AwesomeMediaVideoControls],
        states: [AwesomeMediaVideoStates]) {
        
        self.mediaParams = mediaParams
        
        controlView = superview?.addVideoControls(withControls: controls, states: states)
        controlView?.playCallback = { (isPlaying) in
            if isPlaying {
                AwesomeMediaManager.shared.playMedia(
                    withParams: self.mediaParams,
                    inPlayerLayer: self.avPlayerLayer)
                self.controlView?.shouldShowInfo = false
            } else {
                AwesomeMediaManager.shared.avPlayer.pause()
            }
        }
    }
}

// MARK: - Observers

fileprivate extension Selector {
    static let startedPlaying = #selector(AwesomeMediaView.startedPlaying)
    static let stopedPlaying = #selector(AwesomeMediaView.stopedPlaying)
}

extension AwesomeMediaView {
    
    fileprivate func addObservers() {
        AwesomeMediaNotificationCenter.shared.addObserver(self, selector: .startedPlaying, event: .startedPlaying)
        AwesomeMediaNotificationCenter.shared.addObserver(self, selector: .stopedPlaying, event: .stopedPlaying)
    }
    
    @objc fileprivate func startedPlaying() {
        
    }
    
    @objc fileprivate func stopedPlaying() {
        
    }
}

// MARK: - Touches
extension AwesomeMediaView {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        controlView?.toggleViewIfPossible()
    }
}
