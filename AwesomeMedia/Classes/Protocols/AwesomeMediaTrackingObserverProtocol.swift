//
//  AwesomeMediaTrackingObserverProtocol.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 5/9/18.
//

import Foundation

public extension Selector {
    public static let startedPlaying = #selector(AwesomeMediaTrackingObserver.startedPlaying)
    public static let stoppedPlaying = #selector(AwesomeMediaTrackingObserver.stoppedPlaying)
    public static let sliderChanged = #selector(AwesomeMediaTrackingObserver.sliderChanged)
    public static let openFullscreen = #selector(AwesomeMediaTrackingObserver.openFullscreen)
    public static let closeFullscreen = #selector(AwesomeMediaTrackingObserver.closeFullscreen)
    public static let minimizeFullscreen = #selector(AwesomeMediaTrackingObserver.minimizeFullscreen)
    public static let openedMarkers = #selector(AwesomeMediaTrackingObserver.openedMarkers)
    public static let closedMarkers = #selector(AwesomeMediaTrackingObserver.closedMarkers)
    public static let selectedMarker = #selector(AwesomeMediaTrackingObserver.selectedMarker)
    public static let toggleSpeed = #selector(AwesomeMediaTrackingObserver.toggleSpeed)
    public static let tappedRewind = #selector(AwesomeMediaTrackingObserver.tappedRewind)
    public static let tappedAdvance = #selector(AwesomeMediaTrackingObserver.tappedAdvance)
    public static let tappedAirplay = #selector(AwesomeMediaTrackingObserver.tappedAirplay)
    public static let rotateToLandscape = #selector(AwesomeMediaTrackingObserver.rotateToLandscape)
    public static let rotateToPortrait = #selector(AwesomeMediaTrackingObserver.rotateToPortrait)
    public static let downloadedMedia = #selector(AwesomeMediaTrackingObserver.downloadedMedia)
}

@objc public protocol AwesomeMediaTrackingObserver {
    func addObservers()
    func removeObservers()
    @objc func startedPlaying(_ sender: Notification?)
    @objc func stoppedPlaying(_ sender: Notification?)
    @objc func sliderChanged(_ sender: Notification?)
    @objc func openFullscreen(_ sender: Notification?)
    @objc func closeFullscreen(_ sender: Notification?)
    @objc func minimizeFullscreen(_ sender: Notification?)
    @objc func openedMarkers(_ sender: Notification?)
    @objc func closedMarkers(_ sender: Notification?)
    @objc func selectedMarker(_ sender: Notification?)
    @objc func toggleSpeed(_ sender: Notification?)
    @objc func tappedRewind(_ sender: Notification?)
    @objc func tappedAdvance(_ sender: Notification?)
    @objc func tappedAirplay(_ sender: Notification?)
    @objc func rotateToLandscape(_ sender: Notification?)
    @objc func rotateToPortrait(_ sender: Notification?)
    @objc func downloadedMedia(_ sender: Notification?)
}
