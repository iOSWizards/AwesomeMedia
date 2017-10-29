//
//  AwesomeMediaAVPlayer.swift
//  Pods
//
//  Created by Antonio da Silva on 20/06/2017.
//
//

import AVFoundation

/// Responsible for handling the KVO operations that happen on the AVPlayer.

public enum AwesomeMediaAVPlayerKeyPaths: String {
    case timeControlStatus = "timeControlStatus"
}

public class AwesomeMediaAVPlayer: AVPlayer {
    
    private var observersKeyPath = [String: NSObject?]()
    private var keysPathArray: [String]!
    
    override init() {
        self.keysPathArray = [AwesomeMediaAVPlayerKeyPaths.timeControlStatus.rawValue]
        super.init()
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
