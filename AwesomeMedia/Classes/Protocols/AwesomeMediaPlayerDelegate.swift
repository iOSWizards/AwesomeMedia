//
//  AwesomeMediaPlayerDelegate.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 17/01/17.
//
//

import Foundation

public protocol AwesomeMediaPlayerDelegate: class {
    
    func didChangeSpeed(to: Float, mediaType: AMMediaType)
    func didStopPlaying(mediaType: AMMediaType)
    func didStartPlaying(mediaType: AMMediaType)
    func didPausePlaying(mediaType: AMMediaType)
    func didFinishPlaying(mediaType: AMMediaType)
    func didFailPlaying(mediaType: AMMediaType)
    func didChangeSlider(to: Float, mediaType: AMMediaType)
    
}
