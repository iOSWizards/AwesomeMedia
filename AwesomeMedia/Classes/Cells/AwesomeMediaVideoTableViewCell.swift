//
//  AwesomeMediaVideoTableViewCell.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/4/18.
//

import UIKit

public class AwesomeMediaVideoTableViewCell: UITableViewCell {

    @IBOutlet public weak var coverImageView: UIImageView!
    @IBOutlet public weak var playerView: UIView!
    @IBOutlet public weak var controlView: UIView!
    @IBOutlet public weak var playButton: UIButton!
    @IBOutlet public weak var pausedView: UIView!
    @IBOutlet public weak var mediaInfoLabel: UILabel!
    @IBOutlet public weak var playingView: UIView!
    @IBOutlet public weak var minTimeLabel: UILabel!
    @IBOutlet public weak var maxTimeLabel: UILabel!
    @IBOutlet public weak var timeSlider: UISlider!
    @IBOutlet public weak var fullscreenButton: UIButton!
    @IBOutlet public weak var controlToggleButton: UIButton!
    
    public var playCallback: ((_ playing: Bool) -> Void)?
    public var fullscreenCallback: (() -> Void)?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        togglePlay()
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Dimensions
    
    public static var defaultSize: CGSize {
        var defaultSize = UIScreen.main.bounds.size
        
        defaultSize.height = (defaultSize.width*9)/16
        
        return defaultSize
    }
    
    // MARK: - Events
    
    @IBAction func fullscreenButtonPressed(_ sender: Any) {
        fullscreenCallback?()
    }
    
    // MARK: - Play/Pause
    
    @IBAction func playButtonPressed(_ sender: Any) {
        playButton.isSelected = !playButton.isSelected
        togglePlay()
        playCallback?(playButton.isSelected)
        autoHideControl()
    }
    
    fileprivate func togglePlay() {
        pausedView.isHidden = playButton.isSelected
        playingView.isHidden = !playButton.isSelected
    }
    
    // MARK: - Control
    
    @IBAction func controlToggleButtonPressed(_ sender: Any) {
        guard playButton.isSelected || controlView.isHidden else {
            return
        }
        toggleControl()
    }
    
    public func toggleControl() {
        let hideAnimation = {
            UIViewPropertyAnimator(duration: AwesomeMedia.autoHideControlViewAnimationTime, curve: .easeOut) {
                self.controlView.frame.origin.y = self.frame.size.height
                self.controlView.alpha = 0
            }
        }()
        hideAnimation.addCompletion { (_) in
            self.controlView.isHidden = true
        }
        
        let showAnimation = {
            UIViewPropertyAnimator(duration: AwesomeMedia.autoHideControlViewAnimationTime, curve: .linear) {
                self.controlView.isHidden = false
                self.controlView.alpha = 1
                self.controlView.frame.origin.y = self.frame.size.height-self.controlView.frame.size.height
            }
        }()
        showAnimation.addCompletion { (_) in
            self.autoHideControl()
        }
        
        if controlView.isHidden {
            showAnimation.startAnimation()
        } else {
            hideAnimation.startAnimation()
        }
    }
    
    fileprivate var autoHideControlTimer: Timer?
    public func autoHideControl() {
        autoHideControlTimer?.invalidate()
        
        guard !controlView.isHidden, playButton.isSelected else {
            return
        }
        
        autoHideControlTimer = Timer.scheduledTimer(withTimeInterval: AwesomeMedia.autoHideControlViewTime, repeats: false) { (_) in
            self.toggleControl()
        }
    }
    
}
