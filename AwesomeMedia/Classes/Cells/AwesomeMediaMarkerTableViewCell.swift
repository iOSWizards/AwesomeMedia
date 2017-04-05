//
//  MediaMarkerTableViewCell.swift
//  Micro Learning App
//
//  Created by Evandro Harrison Hoffmann on 19/09/2016.
//  Copyright © 2016 Mindvalley. All rights reserved.
//

import UIKit

open class AwesomeMediaMarkerTableViewCell: UITableViewCell {
    
    @IBOutlet open weak var timeLabel: UILabel!
    @IBOutlet open weak var titleLabel: UILabel!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
