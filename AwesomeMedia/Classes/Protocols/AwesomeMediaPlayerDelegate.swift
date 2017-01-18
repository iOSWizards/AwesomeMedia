//
//  AwesomeMediaPlayerDelegate.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 17/01/17.
//
//

import Foundation

public protocol AwesomeMediaPlayerDelegate: class {
    
    func didChangeSpeed(to: Float)
    func didStopPlaying(stop: Bool)
    func didStartPlaying(start: Bool)
    func didPausePlaying(pause: Bool)
    func didChangeSlider(to: Float)
    
}
