//
//  AVAssetExtensions.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 6/7/18.
//

import Foundation
import MediaPlayer

extension AVAsset {
    
    public static func configureAsset(for composition: AVMutableComposition, url: URL, ofType type: AVMediaType) {
        
        let asset = AVAsset(url: url)
        
        let assetTrack = composition.addMutableTrack(withMediaType: type, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        if let ofTrack = asset.tracks(withMediaType: type).first {
            do {
                try assetTrack?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, asset.duration), of: ofTrack, at: kCMTimeZero)
            } catch {
                print("Failed inserting time range to video.")
            }
        }
    }
}
