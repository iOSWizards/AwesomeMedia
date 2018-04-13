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
    case video = "ninja"
}

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        AwesomeMedia.registerVideoCell(to: tableView, withIdentifier: MediaType.video.rawValue)
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
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MediaType.video.rawValue, for: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? AwesomeMediaVideoTableViewCell {
            let mediaParams: AwesomeMediaParams = [
                .url: AwesomeMediaManager.testVideoURL,
                .coverUrl: "https://thumbs.dreamstime.com/z/awesome-word-cloud-explosion-background-51481417.jpg"]
            cell.configure(withMediaParams: mediaParams, toggleFullscreen: {
                let viewController = AwesomeMediaVideoViewController.newInstance
                viewController.mediaParams = mediaParams
                
                self.present(viewController, animated: true, completion: {
                    
                })
            })
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AwesomeMediaVideoTableViewCell.defaultSize.height
    }

}
