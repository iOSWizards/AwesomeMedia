//
//  AwesomeMediaEventObserver.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/20/18.
//

import Foundation

extension Selector {
    static let playing = #selector(AwesomeMediaEventObserver.startedPlaying)
    static let paused = #selector(AwesomeMediaEventObserver.pausedPlaying)
    static let timeUpdated = #selector(AwesomeMediaEventObserver.timeUpdated)
    static let startedBuffering = #selector(AwesomeMediaEventObserver.startedBuffering)
    static let stopedBuffering = #selector(AwesomeMediaEventObserver.stoppedBuffering)
    static let finishedPlaying = #selector(AwesomeMediaEventObserver.finishedPlaying)
}

@objc public protocol AwesomeMediaEventObserver {
    func addObservers()
    @objc func startedPlaying()
    @objc func pausedPlaying()
    @objc func timeUpdated()
    @objc func startedBuffering()
    @objc func stoppedBuffering()
    @objc func finishedPlaying()
}
