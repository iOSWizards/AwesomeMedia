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
    
    public static func registerAudioCell(to tableView: UITableView, withIdentifier identifier: String) {
        tableView.register(UINib(nibName: "AwesomeMediaAudioTableViewCell", bundle: AwesomeMedia.bundle), forCellReuseIdentifier: identifier)
    }
    
    public static func registerFileCell(to tableView: UITableView, withIdentifier identifier: String) {
        tableView.register(UINib(nibName: "AwesomeMediaFileTableViewCell", bundle: AwesomeMedia.bundle), forCellReuseIdentifier: identifier)
    }
    
}
