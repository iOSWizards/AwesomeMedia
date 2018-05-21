//
//  BitmovinTracking.swift
//  AwesomeMedia
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 19/05/18.
//

import AVFoundation
import BitmovinAnalyticsCollector

public class BitmovinTracking: NSObject {
    
    public static var shared = BitmovinTracking()
    public var analyticsCollector: BitmovinAnalytics?
    
    public static func start(with key: String) {
        let config: BitmovinAnalyticsConfig = BitmovinAnalyticsConfig(key: key)
        BitmovinTracking.shared.analyticsCollector = BitmovinAnalytics(config: config)
    }
    
}

extension AVPlayer {
    public func attachBitmovinTracker() {
        BitmovinTracking.shared.analyticsCollector?.attachAVPlayer(player: self)
    }
}
