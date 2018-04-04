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
    
    @IBAction func playButtonPressed(_ sender: Any) {
        playButton.isSelected = !playButton.isSelected
        togglePlay()
        playCallback?(playButton.isSelected)
    }
    
    @IBAction func fullscreenButtonPressed(_ sender: Any) {
        fullscreenCallback?()
    }
    
    func togglePlay() {
        pausedView.isHidden = playButton.isSelected
        playingView.isHidden = !playButton.isSelected
    }
    
}
