//
//  AwesomeMedia+Cells.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/4/18.
//

import Foundation

extension AwesomeMedia {
    
    public static func registerVideoCell(to tableView: UITableView, withIdentifier identifier: String) {
        tableView.register(UINib(nibName: "AwesomeMediaVideoTableViewCell", bundle: AwesomeMedia.bundle), forCellReuseIdentifier: identifier)
    }
    
}
