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
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var titleView: UIView!
    @IBOutlet public weak var controlToggleButton: UIButton!
    @IBOutlet public weak var closeButton: UIButton!
    @IBOutlet public weak var airplayButton: UIButton!
    public var controlView: AwesomeMediaVideoControlView?
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        controlView = view.addVideoControls(withControls: [.rewind, .time, .playlist, .speed, .jumpto, .minimize])
    }
    
    // MARK: - Events
    
    @IBAction func closeButtonPressed(_ sender: Any) {
    }
    
    @IBAction func airplayButtonPressed(_ sender: Any) {
    }
    
    @IBAction func controlToggleButtonPressed(_ sender: Any) {
        controlView?.toggleViewIfPossible()
    }
    
}

// MARK: - ViewController Initialization

extension AwesomeMediaVideoViewController {
    public static var newInstance: AwesomeMediaVideoViewController {
        let storyboard = UIStoryboard(name: "AwesomeMedia", bundle: AwesomeMedia.bundle)
        
        return storyboard.instantiateViewController(withIdentifier: "AwesomeMediaVideoViewController") as! AwesomeMediaVideoViewController
    }
}

