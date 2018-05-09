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
        AwesomeMediaHelper.shared.addObservers()
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
    }
}

extension AwesomeMediaHelper: AwesomeMediaTrackingObserver {
    func addObservers() {
        AwesomeMediaTrackingNotificationCenter.addObservers(to: AwesomeMediaHelper.shared)
    }
    
    func removeObservers() {
        AwesomeMediaTrackingNotificationCenter.removeObservers(from: AwesomeMediaHelper.shared)
    }
    
    func startedPlaying(_ sender: Notification?) {
        guard let trackingObject = sender?.object as? AwesomeMediaTrackingObject else {
            return
        }
        
        print("tracking \(sender?.name.rawValue ?? ""): \(trackingObject.source.rawValue)")
    }
    
    func stoppedPlaying(_ sender: Notification?) {
        
    }
    
    func sliderChanged(_ sender: Notification?) {
        
    }
    
    func openFullscreen(_ sender: Notification?) {
        
    }
    
    func closeFullscreen(_ sender: Notification?) {
        
    }
    
    func minimizeFullscreen(_ sender: Notification?) {
        
    }
    
    func openedMarkers(_ sender: Notification?) {
        
    }
    
    func closedMarkers(_ sender: Notification?) {
        
    }
    
    func selectedMarker(_ sender: Notification?) {
        
    }
    
    func toggledSpeed(_ sender: Notification?) {
        
    }
    
    func tappedRewind(_ sender: Notification?) {
        
    }
    
    func tappedAdvance(_ sender: Notification?) {
        
    }
    
    func tappedAirplay(_ sender: Notification?) {
        
    }
    
    func rotateToLandscape(_ sender: Notification?) {
        
    }
    
    func rotateToPortrait(_ sender: Notification?) {
        
    }
    
    func downloadedMedia(_ sender: Notification?) {
        
    }
    
    
}
