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

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cells: [MediaType] = [.video, .audio]

    override func viewDidLoad() {
        super.viewDidLoad()

        AwesomeMedia.registerVideoCell(to: tableView, withIdentifier: MediaType.video.rawValue)
        AwesomeMedia.registerAudioCell(to: tableView, withIdentifier: MediaType.audio.rawValue)
        
        // set default orientation
        awesomeOrientation = .portrait
        
        // add observers
        addObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return awesomeOrientation
    }
}

// MARK: - Table view data source

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cells[indexPath.row].rawValue, for: indexPath)

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? AwesomeMediaVideoTableViewCell {
            let mediaParams: AwesomeMediaParams = [
                .url: AwesomeMediaManager.testVideoURL,
                .coverUrl: "https://thumbs.dreamstime.com/z/awesome-word-cloud-explosion-background-51481417.jpg",
                .author: "Eric Mendez",
                .title: "WildFit",
                .duration: 7297,
                .markers: AwesomeMediaManager.testMediaMarkers]
            cell.configure(withMediaParams: mediaParams)
        } else if let cell = cell as? AwesomeMediaAudioTableViewCell {
            let mediaParams: AwesomeMediaParams = [
                .url: AwesomeMediaManager.testAudioURL,
                .coverUrl: "https://thumbs.dreamstime.com/z/awesome-word-cloud-explosion-background-51481417.jpg",
                .author: "Eric Mendez",
                .title: "WildFit",
                .duration: 232]
            cell.configure(withMediaParams: mediaParams)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch cells[indexPath.row] {
        case .audio:
            return AwesomeMediaAudioTableViewCell.defaultSize.height
        case .video:
            return AwesomeMediaVideoTableViewCell.defaultSize.height
        }
    }

}

extension UIViewController: AwesomeMediaEventObserver {
    public func addObservers() {
        AwesomeMediaNotificationCenter.addObservers([.playingAudio, .playingVideo, .paused], to: self)
    }
    
    public func startedPlayingAudio(_ notification: NSNotification) {
        if let params = notification.object as? AwesomeMediaParams {
            _ = view.addAudioPlayer(withParams: params, animated: true)
        } else {
            view.removeAudioControlView(animated: true)
        }
    }
    
    public func startedPlayingVideo(_ notification: NSNotification) {
        view.removeAudioControlView(withTimeout: 0, animated: true)
    }
    
    public func pausedPlaying() {
        view.removeAudioControlView(animated: true)
    }
}
