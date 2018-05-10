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
        log(notification: sender)
    }
    
    func stoppedPlaying(_ sender: Notification?) {
        log(notification: sender)
    }
    
    func sliderChanged(_ sender: Notification?) {
        log(notification: sender)
    }
    
    func toggleFullscreen(_ sender: Notification?) {
        log(notification: sender)
    }
    
    func closeFullscreen(_ sender: Notification?) {
        log(notification: sender)
    }
    
    func openedMarkers(_ sender: Notification?) {
        log(notification: sender)
    }
    
    func closedMarkers(_ sender: Notification?) {
        log(notification: sender)
    }
    
    func selectedMarker(_ sender: Notification?) {
        log(notification: sender)
    }
    
    func toggledSpeed(_ sender: Notification?) {
        log(notification: sender)
    }
    
    func tappedRewind(_ sender: Notification?) {
        log(notification: sender)
    }
    
    func tappedAdvance(_ sender: Notification?) {
        log(notification: sender)
    }
    
    func tappedAirplay(_ sender: Notification?) {
        log(notification: sender)
    }
    
    func changedOrientation(_ sender: Notification?) {
        log(notification: sender)
    }
    
    func openedFullscreenWithRotation(_ sender: Notification?) {
        log(notification: sender)
    }
    
    func tappedDownload(_ sender: Notification?) {
        log(notification: sender)
    }
    
    func deletedDownload(_ sender: Notification?) {
        log(notification: sender)
    }
    
    func timedOut(_ sender: Notification?) {
        log(notification: sender)
    }
    
    func timeoutCancel(_ sender: Notification?) {
        log(notification: sender)
    }
    
    func timeoutWait(_ sender: Notification?) {
        log(notification: sender)
    }
    
    func playingInBackground(_ sender: Notification?) {
        log(notification: sender)
    }
    
    fileprivate func log(notification: Notification?) {
        guard let notification = notification else {
            return
        }
        
        guard let trackingObject = notification.object as? AwesomeMediaTrackingObject else {
            return
        }
        
        var string = "tracking \(trackingObject.source.rawValue): \(notification.name.rawValue)"
        
        if let value = trackingObject.value {
            string.append(" with value: \(value)")
        }
        
        string.append(" params: [\(trackingObject.params)]")
        
        print(string)
    }
    
}
