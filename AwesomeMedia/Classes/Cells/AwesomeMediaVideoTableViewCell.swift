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
    @IBOutlet public weak var controlToggleButton: UIButton!
    public var controlView: AwesomeMediaVideoControlView?

    public override func awakeFromNib() {
        super.awakeFromNib()
        
        controlView = addVideoControls()
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
    
    // MARK: - Control
    
    @IBAction func controlToggleButtonPressed(_ sender: Any) {
        controlView?.toggleViewIfPossible()
    }
    
}
