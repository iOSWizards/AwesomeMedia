//
//  AwesomeMediaView.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 16/01/2017.
//
//

import UIKit

@IBDesignable
open class AwesomeMediaView: UIView {

    // MARK: - Components
    
    @IBOutlet open weak var controlsView: UIView?
    @IBOutlet weak var timeSlider: UISlider?
    @IBOutlet weak var minTimeLabel: UILabel?
    @IBOutlet weak var maxTimeLabel: UILabel?
    @IBOutlet weak var playButton: UIButton?
    @IBOutlet weak var fullscreenButton: UIButton?
    @IBOutlet weak var markersButton: UIButton?
    
    // MARK: - Configurations
    
    @IBInspectable open var skipTime: Int = 0
    @IBInspectable open var fullscreenOnLandscape: Bool = false

    open override func awakeFromNib() {
        timeSlider?.addTarget(self, action: #selector(AwesomeMediaView.timeSliderUpdated(_:)), for: .valueChanged)
        timeSlider?.addTarget(self, action: #selector(AwesomeMediaView.timeSliderBeganUpdating(_:)), for: .touchDown)
        timeSlider?.addTarget(self, action: #selector(AwesomeMediaView.timeSliderEndedUpdating(_:)), for: .touchUpInside)
        timeSlider?.addTarget(self, action: #selector(AwesomeMediaView.timeSliderEndedUpdating(_:)), for: .touchUpOutside)
        
        playButton?.addTarget(self, action: #selector(AwesomeMediaView.togglePlay(_:)), for: .touchUpInside)
        
        fullscreenButton?.addTarget(self, action: #selector(AwesomeMediaView.togglePlay(_:)), for: .touchUpInside)
    }

    // MARK: - Events
    
    // MARK: - Play / Pause
    
    @IBAction open func togglePlay(_ sender: AnyObject){
        guard let playButton = playButton else {
            return
        }
        playButton.isSelected = !playButton.isSelected
        
        if playButton.isSelected {
            play(sender)
        }else{
            pause(sender)
        }
    }
    
    @IBAction open func play(_ sender: AnyObject){
        
    }
    
    @IBAction open func pause(_ sender: AnyObject){
        
    }
    
    @IBAction open func stop(_ sender: AnyObject){
        
    }
    
    // MARK: - Speed
    
    @IBAction open func toggleSpeed(_ sender: AnyObject){
        
    }
    
    // MARK: - Seeking
    
    @IBAction open func skipBackward(_ sender: AnyObject){
        
    }
    
    @IBAction open func skipForward(_ sender: AnyObject){
        
    }
    
    // MARK: - Slider
    
    @IBAction open func timeSliderUpdated(_ sender: AnyObject){
        
    }
    
    @IBAction open func timeSliderBeganUpdating(_ sender: AnyObject){
        
    }
    
    @IBAction open func timeSliderEndedUpdating(_ sender: AnyObject){
        
    }
    
    // MARK: - Layout Changes
    
    @IBAction open func toggleFullscreen(_ sender: AnyObject){
        guard let fullscreenButton = fullscreenButton else {
            return
        }
        fullscreenButton.isSelected = !fullscreenButton.isSelected
        
        if fullscreenButton.isSelected {
            fullscreen(sender)
        }else{
            smallscreen(sender)
        }
    }
    
    @IBAction open func fullscreen(_ sender: AnyObject){
        
    }
    
    @IBAction open func smallscreen(_ sender: AnyObject){
        
    }
}
