//
//  BitmovinTracking.swift
//  AwesomeMedia
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 19/05/18.
//

import AVFoundation
import BitmovinAnalyticsCollector

public class BitmovinTracking: NSObject {
    
    fileprivate static var shared = BitmovinTracking()
    fileprivate var analyticsCollector: BitmovinAnalytics?
    fileprivate var key: String?
    
    
    public static func configure(with key: String) {
         BitmovinTracking.shared.key = key
    }
    
    public static func start(withParams params: AwesomeMediaParams) {
        guard let key =  BitmovinTracking.shared.key else {
            debugPrint("You must set the Bitmovin product key before using it.")
            return
        }
        
        let config: BitmovinAnalyticsConfig = BitmovinAnalyticsConfig(key: key)
        config.videoId = params.params["videoId"] as? String ?? ""
        config.customData1 = params.params["assetId"] as? String ?? ""
        config.customData2 = params.params["questId"] as? String ?? ""
        config.customData3 = params.params["id"] as? String ?? ""
        BitmovinTracking.shared.analyticsCollector = BitmovinAnalytics(config: config)
        
    }
    
}

// MARK: - AVPlayer Extension

extension AVPlayer {
    public func attachBitmovinTracker() {
        BitmovinTracking.shared.analyticsCollector?.attachAVPlayer(player: self)
    }
}
