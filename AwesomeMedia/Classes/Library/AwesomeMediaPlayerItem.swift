//
//  AwesomeMediaPlayerItem.swift
//  Pods
//
//  Created by Antonio da Silva on 13/06/2017.
//
//

import AVFoundation

/// Responsible for handling the KVO operations that happen on the AVPlayerItem.

public enum AwesomeMediaPlayerItemKeyPaths: String {
    case playbackLikelyToKeepUp = "playbackLikelyToKeepUp"
    case playbackBufferFull = "playbackBufferFull"
    case status = "status"
}

public class AwesomeMediaPlayerItem: AVPlayerItem {
    
    var observersKeyPath = [String: NSObject?]()
    var keysPathArray:[String]!
    
    convenience init(url URL: URL, keysPathArray: [String]) {
        self.init(url: URL)
        self.keysPathArray = keysPathArray
    }
    
    deinit {
        for (keyPath, observer) in observersKeyPath {
            if let observer = observer {
                self.removeObserver(observer, forKeyPath: keyPath)
            }
        }
    }
    
    override public func addObserver(_ observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions = [], context: UnsafeMutableRawPointer?) {
        super.addObserver(observer, forKeyPath: keyPath, options: options, context: context)
        if keysPathArray.contains(keyPath) {
            let obj = observersKeyPath[keyPath] as? NSObject
            if obj == nil {
                observersKeyPath[keyPath] = observer
            } else {
                self.removeObserver(obj!, forKeyPath: keyPath)
                observersKeyPath[keyPath] = observer
            }
        }
    }
    
    override public func removeObserver(_ observer: NSObject, forKeyPath keyPath: String, context: UnsafeMutableRawPointer?) {
        super.removeObserver(observer, forKeyPath: keyPath, context: context)
        observersKeyPath[keyPath] = nil
    }
    
    public override func removeObserver(_ observer: NSObject, forKeyPath keyPath: String) {
        super.removeObserver(observer, forKeyPath: keyPath)
        observersKeyPath[keyPath] = nil
    }
    
}
