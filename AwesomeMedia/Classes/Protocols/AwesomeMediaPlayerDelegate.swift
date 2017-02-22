//
//  AwesomeMediaPlayerDelegate.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 17/01/17.
//
//

import Foundation

public protocol AwesomeMediaPlayerDelegate: class {
    
    func didChangeSpeed(to: Float, mediaType: MVMediaType)
    func didStopPlaying(mediaType: MVMediaType)
    func didStartPlaying(mediaType: MVMediaType)
    func didPausePlaying(mediaType: MVMediaType)
    func didFinishPlaying(mediaType: MVMediaType)
    func didFailPlaying(mediaType: MVMediaType)
    func didChangeSlider(to: Float, mediaType: MVMediaType)
    
}
