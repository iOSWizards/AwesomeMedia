//
//  AwesomeMediaPlayerLayer.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/10/18.
//

import AVFoundation

public class AwesomeMediaPlayerLayer: AVPlayerLayer {
    
    public static var shared: AwesomeMediaPlayerLayer = {
        return newInstance
    }()
    
    public static var newInstance: AwesomeMediaPlayerLayer {
        let playerLayer = AwesomeMediaPlayerLayer()
        
        return playerLayer
    }
}

extension UIView {
    
    public func addPlayerLayer(_ playerLayer: AVPlayerLayer = AwesomeMediaPlayerLayer.shared) {
        removePlayerLayer()
        
        self.layer.insertSublayer(playerLayer, at: 0)
        self.layer.masksToBounds = true
    }
    
    public func removePlayerLayer() {
        guard let sublayers = layer.sublayers else {
            return
        }
        
        for sublayer in sublayers where sublayer is AwesomeMediaPlayerLayer {
            sublayer.removeFromSuperlayer()
        }
    }
    
}
