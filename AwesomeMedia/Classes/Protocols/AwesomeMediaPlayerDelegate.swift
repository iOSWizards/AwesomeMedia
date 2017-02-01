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
    func didStopPlaying()
    func didStartPlaying()
    func didPausePlaying()
    func didFinishPlaying()
    func didFailPlaying()
    func didChangeSlider(to: Float)
    
}
