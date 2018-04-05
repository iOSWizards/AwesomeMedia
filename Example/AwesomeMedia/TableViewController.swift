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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MediaType.video.rawValue, for: indexPath)

        if let cell = cell as? AwesomeMediaVideoTableViewCell {
            cell.coverImageView.image = #imageLiteral(resourceName: "awesome")
            
            cell.controlView?.fullscreenCallback = {
                let viewController = AwesomeMediaVideoViewController.newInstance
                
                self.present(viewController, animated: true, completion: {
                    viewController.coverImageView.image = #imageLiteral(resourceName: "awesome")
                })
            }
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AwesomeMediaVideoTableViewCell.defaultSize.height
    }

}
