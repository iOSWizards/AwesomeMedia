//
//  AwesomeMediaVideoViewController.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/4/18.
//

import UIKit

public class AwesomeMediaVideoViewController: UIViewController {

    @IBOutlet public weak var coverImageView: UIImageView!
    @IBOutlet public weak var playerView: UIView!
    @IBOutlet public weak var controlView: UIView!
    @IBOutlet public weak var playButton: UIButton!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var titleView: UIView!
    @IBOutlet public weak var minTimeLabel: UILabel!
    @IBOutlet public weak var maxTimeLabel: UILabel!
    @IBOutlet public weak var timeSlider: UISlider!
    @IBOutlet public weak var minimizeButton: UIButton!
    @IBOutlet public weak var controlToggleButton: UIButton!
    @IBOutlet public weak var closeButton: UIButton!
    @IBOutlet public weak var airplayButton: UIButton!
    @IBOutlet public weak var rewindButton: UIButton!
    @IBOutlet public weak var playlistButton: UIButton!
    @IBOutlet public weak var jumptoButton: UIButton!
    @IBOutlet public weak var speedButton: UIButton!
    @IBOutlet public weak var speedLabel: UILabel!
    @IBOutlet public weak var jumptoLabel: UILabel!
    @IBOutlet public weak var speedView: UIView!
    @IBOutlet public weak var jumptoView: UIView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        timeSlider.setThumbImage()
        
        jumptoView.isHidden = true
    }
    
    // MARK: - Events
    
    @IBAction func closeButtonPressed(_ sender: Any) {
    }
    
    @IBAction func airplayButtonPressed(_ sender: Any) {
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
    }
    
    @IBAction func rewindButtonPressed(_ sender: Any) {
    }
    
    @IBAction func playlistButtonPressed(_ sender: Any) {
    }
    
    @IBAction func speedButtonPressed(_ sender: Any) {
    }
    
    @IBAction func jumptoButtonPressed(_ sender: Any) {
    }
    
    @IBAction func minimizeButtonPressed(_ sender: Any) {
    }
    
    @IBAction func timeSliderValueChanged(_ sender: Any) {
    }
    
}

// MARK: - ViewController Initialization

extension AwesomeMediaVideoViewController {
    public static var newInstance: AwesomeMediaVideoViewController {
        let storyboard = UIStoryboard(name: "AwesomeMedia", bundle: AwesomeMedia.bundle)
        
        return storyboard.instantiateViewController(withIdentifier: "AwesomeMediaVideoViewController") as! AwesomeMediaVideoViewController
    }
}

