//
//  AMAVPlayerItem.swift
//  AwesomeLoading
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 16/05/18.
//

import AVFoundation

// MARK: - Responsible for handling the KVO operations that happen on the AVPlayerItem.

public enum AwesomeMediaPlayerItemKeyPaths: String {
    case playbackLikelyToKeepUp
    case playbackBufferFull
    case playbackBufferEmpty
    case status
    case timeControlStatus
}

public class AMAVPlayerItem: AVPlayerItem {
    
    private var observersKeyPath = [String: NSObject?]()
    private var addedAddtionalStatus: Bool = false
    private var keysPathArray: [AwesomeMediaPlayerItemKeyPaths] = [.playbackLikelyToKeepUp, .playbackBufferFull, .playbackBufferEmpty, .status, .timeControlStatus]
    
    deinit {
        var obs: NSObject?
        for (keyPath, observer) in observersKeyPath {
            if let observer = observer {
                self.removeObserver(observer, forKeyPath: keyPath)
                obs = observer
            }
        }
        if addedAddtionalStatus, let obs = obs {
            self.removeObserver(obs, forKeyPath: "status")
            addedAddtionalStatus = false
        }
    }
    
    override public func addObserver(_ observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions = [], context: UnsafeMutableRawPointer?) {
        super.addObserver(observer, forKeyPath: keyPath, options: options, context: context)
        if !addedAddtionalStatus, keyPath == "status", observersKeyPath["status"] != nil {
            addedAddtionalStatus = true
        }
        observersKeyPath[keyPath] = observer
    }
    
    override public func removeObserver(_ observer: NSObject, forKeyPath keyPath: String, context: UnsafeMutableRawPointer?) {
        super.removeObserver(observer, forKeyPath: keyPath, context: context)
        observersKeyPath[keyPath] = nil
        observersKeyPath.removeValue(forKey: keyPath)
    }
    
    public override func removeObserver(_ observer: NSObject, forKeyPath keyPath: String) {
        super.removeObserver(observer, forKeyPath: keyPath)
        observersKeyPath[keyPath] = nil
        observersKeyPath.removeValue(forKey: keyPath)
    }
    
}
