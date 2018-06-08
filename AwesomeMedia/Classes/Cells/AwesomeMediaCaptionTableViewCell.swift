//
//  AwesomeMediaCaptionTableViewCell.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 6/7/18.
//

import UIKit

class AwesomeMediaCaptionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tickImageView: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        
    }

}
