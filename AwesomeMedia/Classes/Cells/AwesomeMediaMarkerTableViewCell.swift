//
//  AwesomeMediaMarkersTableViewCell.swift
//  AwesomeMedia
//
//  Created by Emmanuel on 18/04/2018.
//

import UIKit

class AwesomeMediaMarkerTableViewCell: UITableViewCell {
    @IBOutlet weak var playStatusImage: UIImageView!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if animated {
            UIView.animate(withDuration: 0.3) {
                self.update(selected: selected)
            }
        } else {
            self.update(selected: selected)
        }
    }
    
    fileprivate func update(selected: Bool) {
        self.selectedView.isHidden = !selected
        self.playStatusImage.isHidden = !selected
    }

}
