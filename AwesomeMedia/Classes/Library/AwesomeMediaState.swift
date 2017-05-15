//
//  AwesomeMediaState.swift
//  Pods
//
//  Created by Antonio da Silva on 15/05/2017.
//
//

import Foundation

// Responsible for handling the Media Player persistent state.

struct AwesomeMediaState {
    
    // MARK: - Media State keys
    private static let keyVideo  = "AM_VIDEO_PLAYER_SPEED_KEY"
    private static let keyAudio  = "AM_AUDIO_PLAYER_SPEED_KEY"
    
    static func speedFor(_ mediaType: AMMediaType) -> Float? {
        let key = mediaType == .video ? keyVideo : keyAudio
        return UserDefaults.standard.float(forKey: key)
    }
    
    static func saveMediaPlayer(speed: Float, forMediaType mediaType: AMMediaType) {
        let key = mediaType == .video ? keyVideo : keyAudio
        UserDefaults.standard.set(speed, forKey: key)
    }
    
}
