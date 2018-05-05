//
//  AwesomeMediaEventObserver.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/20/18.
//

import Foundation

public extension Selector {
    public static let playing = #selector(AwesomeMediaEventObserver.startedPlaying)
    public static let playingAudio = #selector(AwesomeMediaEventObserver.startedPlayingAudio(_:))
    public static let playingVideo = #selector(AwesomeMediaEventObserver.startedPlayingVideo(_:))
    public static let paused = #selector(AwesomeMediaEventObserver.pausedPlaying)
    public static let stopped = #selector(AwesomeMediaEventObserver.stoppedPlaying)
    public static let timeUpdated = #selector(AwesomeMediaEventObserver.timeUpdated)
    public static let startedBuffering = #selector(AwesomeMediaEventObserver.startedBuffering)
    public static let stopedBuffering = #selector(AwesomeMediaEventObserver.stoppedBuffering)
    public static let finishedPlaying = #selector(AwesomeMediaEventObserver.finishedPlaying)
    public static let speedRateChanged = #selector(AwesomeMediaEventObserver.speedRateChanged)
    public static let timedOut = #selector(AwesomeMediaEventObserver.timedOut)
}

@objc public protocol AwesomeMediaEventObserver {
    func addObservers()
    func removeObservers()
    @objc optional func startedPlaying()
    @objc optional func startedPlayingAudio(_ notification: NSNotification)
    @objc optional func startedPlayingVideo(_ notification: NSNotification)
    @objc optional func pausedPlaying()
    @objc optional func stoppedPlaying()
    @objc optional func timeUpdated()
    @objc optional func startedBuffering()
    @objc optional func stoppedBuffering()
    @objc optional func finishedPlaying()
    @objc optional func speedRateChanged()
    @objc optional func timedOut()
}
