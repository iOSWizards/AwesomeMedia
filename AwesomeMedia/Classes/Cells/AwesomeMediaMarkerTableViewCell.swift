//
//  AwesomeMediaMarkersTableViewCell.swift
//  AwesomeMedia
//
//  Created by Emmanuel on 18/04/2018.
//

import UIKit

class AwesomeMediaMarkerTableViewCell: UITableViewCell {
    @IBOutlet weak var playStatusImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
