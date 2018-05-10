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
    case file
    case image
}

struct MediaCell {
    var type = MediaType.video
    var mediaParams = AwesomeMediaParams()
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cells: [MediaCell] = [
        MediaCell(type: .video,
                  mediaParams: AwesomeMediaParams([
                    .url: AwesomeMediaManager.testVideoURL,
                    .coverUrl: "https://thumbs.dreamstime.com/z/awesome-word-cloud-explosion-background-51481417.jpg",
                    .author: "Eric Mendez",
                    .title: "WildFit",
                    .duration: 7297,
                    .markers: AwesomeMediaManager.testMediaMarkers,
                    .id: "45"])),
        MediaCell(type: .audio,
                  mediaParams: AwesomeMediaParams([
                    .url: AwesomeMediaManager.testAudioURL,
                    .coverUrl: "https://i.ytimg.com/vi/fwLuHqMMonc/0.jpg",
                    .author: "The barber",
                    .title: "Virtual Barbershop",
                    .size: "2 mb",
                    .duration: 232,
                    .id: "45"])),
        MediaCell(type: .file,
                  mediaParams: AwesomeMediaParams([
                    .url: AwesomeMediaManager.testPDFURL,
                    .coverUrl: "https://i0.wp.com/res.cloudinary.com/changethatmind/image/upload/v1501884914/wildfitsales.png?fit=500%2C500&ssl=1",
                    .author: "Eric Mendez",
                    .title: "Wildfit",
                    .type: "PDF",
                    .size: "2 mb",
                    .id: "45"])),
        MediaCell(type: .image,
                  mediaParams: AwesomeMediaParams([
                    .coverUrl: "https://www.awesometlv.co.il/wp-content/uploads/2016/01/awesome_logo-01.png"])),
        MediaCell(type: .video,
                  mediaParams: AwesomeMediaParams([
                    .url: AwesomeMediaManager.testVideoURL2,
                    .coverUrl: "https://i0.wp.com/res.cloudinary.com/changethatmind/image/upload/v1501884914/wildfitsales.png?fit=500%2C500&ssl=1",
                    .author: "Eric Mendez",
                    .title: "WildFit 2",
                    .duration: 12312,
                    .markers: AwesomeMediaManager.testMediaMarkers,
                    .id: "45"])),
        MediaCell(type: .image,
                  mediaParams: AwesomeMediaParams([
                    .coverUrl: "https://i0.wp.com/res.cloudinary.com/changethatmind/image/upload/v1501884914/wildfitsales.png?fit=500%2C500&ssl=1"])),
        MediaCell(type: .video,
                  mediaParams: AwesomeMediaParams([
                    .url: AwesomeMediaManager.testVideoURL3,
                    .coverUrl: "https://thumbs.dreamstime.com/z/awesome-word-cloud-explosion-background-51481417.jpg",
                    .author: "Eric Mendez",
                    .title: "WildFit 3",
                    .duration: 33222,
                    .markers: AwesomeMediaManager.testMediaMarkers,
                    .id: "45"])),
        ]
    var mediaParamsArray: [AwesomeMediaParams] {
        var mediaParamsArray = [AwesomeMediaParams]()
        for cell in cells {
            mediaParamsArray.append(cell.mediaParams)
        }
        
        return mediaParamsArray
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // register cells
        AwesomeMediaHelper.registerCells(forTableView: tableView)
        
        // set default orientation
        awesomeMediaOrientation = .portrait
        
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AwesomeMediaHelper.stopIfNeeded()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return awesomeMediaOrientation
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        handleOrientationChange(withMediaParams: mediaParamsArray)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cells[indexPath.row].type.rawValue, for: indexPath)

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? AwesomeMediaVideoTableViewCell {
            cell.configure(withMediaParams: cells[indexPath.row].mediaParams)
        } else if let cell = cell as? AwesomeMediaAudioTableViewCell {
            cell.configure(withMediaParams: cells[indexPath.row].mediaParams)
        } else if let cell = cell as? AwesomeMediaFileTableViewCell {
            cell.configure(withMediaParams: cells[indexPath.row].mediaParams)
        } else if let cell = cell as? AwesomeMediaImageTableViewCell {
            cell.configure(withMediaParams: cells[indexPath.row].mediaParams)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch cells[indexPath.row].type {
        case .audio:
            return AwesomeMediaAudioTableViewCell.defaultSize.height
        case .video:
            return AwesomeMediaVideoTableViewCell.defaultSize.height
        case .file:
            return AwesomeMediaFileTableViewCell.defaultSize.height
        case .image:
            return AwesomeMediaImageTableViewCell.size(withTableView: tableView, indexPath: indexPath).height
        }
    }

}

extension UIViewController: AwesomeMediaEventObserver {
    public func addObservers() {
        AwesomeMediaNotificationCenter.addObservers([.playingAudio, .playingVideo], to: self)
    }
    
    public func removeObservers() {
        AwesomeMediaNotificationCenter.removeObservers(from: self)
    }
    
    public func startedPlayingAudio(_ notification: NSNotification) {
        if let params = notification.object as? AwesomeMediaParams {
            _ = view.addAudioPlayer(withParams: params, animated: true)
        } else {
            view.removeAudioControlView(animated: true)
        }
    }
    
    public func startedPlayingVideo(_ notification: NSNotification) {
        view.removeAudioControlView(animated: true)
    }
}
