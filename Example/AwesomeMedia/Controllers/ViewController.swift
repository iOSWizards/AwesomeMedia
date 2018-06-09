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
    case youtube
}

struct MediaCell {
    var type = MediaType.video
    var mediaParams = AwesomeMediaParams()
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cells: [MediaCell] = [
        MediaCell(type: .video,
                  mediaParams: AwesomeMediaParams(
                    url: "https://overmind2.mvstg.com/api/v1/assets/05f9aea7-9c70-4cbc-a891-2b04805801e3.mp4",
                    coverUrl: "https://thumbs.dreamstime.com/z/awesome-word-cloud-explosion-background-51481417.jpg",
                    author: "John",
                    title: "Caption test",
                    duration: 120,
                    markers: AwesomeMediaManager.testMediaMarkers,
                    captions: [AwesomeMediaCaption(url: "https://overmind2.mvstg.com/api/v1/assets/cd2b9789-13f8-4e40-b4cb-a1c75a07f6f7.vtt", label: "Danish", language: "de", isDefault: false),
                               AwesomeMediaCaption(url: "https://overmind2.mvstg.com/api/v1/assets/1a06d26b-ceb1-439a-99ea-6071a95e25d4.vtt", label: "Spanish", language: "es", isDefault: false),
                               AwesomeMediaCaption(url: "https://overmind2.mvstg.com/api/v1/assets/f9d83a3b-c9b3-464c-8b20-4a2a4735a015.vtt", label: "English", language: "en", isDefault: true)],
                    params: ["id":"45"])),
        MediaCell(type: .audio,
                  mediaParams: AwesomeMediaParams(
                    url: AwesomeMediaManager.testAudioURL,
                    coverUrl: "https://i.ytimg.com/vi/fwLuHqMMonc/0.jpg",
                    author: "The barber",
                    title: "Virtual Barbershop",
                    duration: 232,
                    size: "2 mb",
                    params: ["id":"45"])),
        MediaCell(type: .file,
                  mediaParams: AwesomeMediaParams(
                    url: AwesomeMediaManager.testPDFURL,
                    coverUrl: "https://i0.wp.com/res.cloudinary.com/changethatmind/image/upload/v1501884914/wildfitsales.png?fit=500%2C500&ssl=1",
                    author: "Eric Mendez",
                    title: "Wildfit",
                    size: "2 mb",
                    type: "PDF",
                    params: ["id":"45"])),
        MediaCell(type: .image,
                  mediaParams: AwesomeMediaParams(
                    coverUrl: "https://www.awesometlv.co.il/wp-content/uploads/2016/01/awesome_logo-01.png")),
        MediaCell(type: .video,
                  mediaParams: AwesomeMediaParams(
                    url: AwesomeMediaManager.testVideoURL,
                    coverUrl: "https://i0.wp.com/res.cloudinary.com/changethatmind/image/upload/v1501884914/wildfitsales.png?fit=500%2C500&ssl=1",
                    author: "Eric Mendez",
                    title: "WildFit 2",
                    duration: 12312,
                    markers: AwesomeMediaManager.testMediaMarkers,
                    params: ["id":"45"])),
        MediaCell(type: .image,
                  mediaParams: AwesomeMediaParams(
                    coverUrl: "https://i0.wp.com/res.cloudinary.com/changethatmind/image/upload/v1501884914/wildfitsales.png?fit=500%2C500&ssl=1")),
        MediaCell(type: .video,
                  mediaParams: AwesomeMediaParams(
                    url: "https://overmind2.mvstg.com/api/v1/assets/0892a82b-a9ad-4069-a5b6-cf2e6103267c.m3u8",
                    coverUrl: "https://thumbs.dreamstime.com/z/awesome-word-cloud-explosion-background-51481417.jpg",
                    author: "Eric Mendez",
                    title: "WildFit 3",
                    duration: 33222,
                    markers: AwesomeMediaManager.testMediaMarkers,
                    params: ["id":"45"])),
        MediaCell(type: .youtube,
                  mediaParams: AwesomeMediaParams(
                    youtubeUrl: "https://www.youtube.com/watch?v=5WOxJ9rvU1s&t=3s",
                    coverUrl: "https://i0.wp.com/res.cloudinary.com/changethatmind/image/upload/v1501884914/wildfitsales.png?fit=500%2C500&ssl=1")),
        MediaCell(type: .youtube,
                  mediaParams: AwesomeMediaParams(
                    youtubeUrl: "https://www.youtube.com/watch?v=5WOxJ9rvU1s&t=3s",
                    coverUrl: "https://i0.wp.com/res.cloudinary.com/changethatmind/image/upload/v1501884914/wildfitsales.png?fit=500%2C500&ssl=1"))
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
        } else if let cell = cell as? AwesomeMediaYoutubeTableViewCell {
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
        case .youtube:
            return AwesomeMediaYoutubeTableViewCell.defaultSize.height
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
