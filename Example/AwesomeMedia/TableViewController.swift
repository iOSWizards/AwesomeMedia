//
//  TableViewController.swift
//  AwesomeMedia_Example
//
//  Created by Evandro Harrison Hoffmann on 4/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import AwesomeMedia

enum MediaType: String {
    case video
    case audio
}

class TableViewController: UITableViewController {
    
    let cells: [MediaType] = [.video, .audio]

    override func viewDidLoad() {
        super.viewDidLoad()

        AwesomeMedia.registerVideoCell(to: tableView, withIdentifier: MediaType.video.rawValue)
        AwesomeMedia.registerAudioCell(to: tableView, withIdentifier: MediaType.audio.rawValue)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cells[indexPath.row].rawValue, for: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? AwesomeMediaVideoTableViewCell {
            let mediaParams: AwesomeMediaParams = [
                .url: AwesomeMediaManager.testVideoURL,
                .coverUrl: "https://thumbs.dreamstime.com/z/awesome-word-cloud-explosion-background-51481417.jpg",
                .author: "Eric Mendez",
                .title: "WildFit",
                .markers: AwesomeMediaManager.testMediaMarkers]
            cell.configure(withMediaParams: mediaParams)
        } else if let cell = cell as? AwesomeMediaAudioTableViewCell {
            let mediaParams: AwesomeMediaParams = [
                .url: AwesomeMediaManager.testAudioURL,
                .coverUrl: "https://thumbs.dreamstime.com/z/awesome-word-cloud-explosion-background-51481417.jpg",
                .author: "Eric Mendez",
                .title: "WildFit",
                .duration: 3600]
            cell.configure(withMediaParams: mediaParams)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch cells[indexPath.row] {
        case .audio:
            return AwesomeMediaAudioTableViewCell.defaultSize.height
        case .video:
            return AwesomeMediaVideoTableViewCell.defaultSize.height
        }
    }

}
