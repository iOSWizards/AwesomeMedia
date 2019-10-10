//
//  AwesomeMediaHelper.swift
//  AwesomeMedia_Example
//
//  Created by Evandro Harrison Hoffmann on 5/3/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import AwesomeMedia


class AwesomeMediaHelper {
    
    static var shared = AwesomeMediaHelper()
    
    static func start() {
//        BitmovinTracking.configure(with: "testingKey")
        
    }
    
    static func stop() {
        sharedAVPlayer.stop()
    }
    
    static func stopIfNeeded() {
        AwesomeMedia.stopPlayingIfIsVideoAndNotFullscreen()
    }
    
    static func applicationDidEnterBackground() {
        AwesomeMedia.didEnterBackground()
    }
    
    static func applicationDidBecomeActive() {
        AwesomeMedia.didBecomeActive()
    }
    
    static func registerCells(forTableView tableView: UITableView) {
        AwesomeMedia.registerVideoCell(to: tableView, withIdentifier: MediaType.video.rawValue)
        AwesomeMedia.registerAudioCell(to: tableView, withIdentifier: MediaType.audio.rawValue)
        AwesomeMedia.registerFileCell(to: tableView, withIdentifier: MediaType.file.rawValue)
        AwesomeMedia.registerImageCell(to: tableView, withIdentifier: MediaType.image.rawValue)
        AwesomeMedia.registerYoutubeCell(to: tableView, withIdentifier: MediaType.youtube.rawValue)
    }
}
