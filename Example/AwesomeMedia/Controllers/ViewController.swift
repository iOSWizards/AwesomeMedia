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
    case verticalVideo
}

struct MediaCell {
    var type = MediaType.video
    var mediaParams = AwesomeMediaParams()
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Testing Variables
    public static let testVideoURL2 = "http://overmind2.mindvalleyacademy.com/api/v1/assets/cb19bc38-d804-4c30-b1f1-79d28d9d71d4.m3u8"
    public static let testVideoURL3 = "http://overmind2.mindvalleyacademy.com/api/v1/assets/b78856cc-d0f0-4069-b1e1-9dbbe47b4df6.m3u8"
    public static let testMediaMarkers = [AwesomeMediaMarker(title: "Intro", time: 120),
                                          AwesomeMediaMarker(title: "About WildFit", time: 360),
                                          AwesomeMediaMarker(title: "Day 1", time: 420),
                                          AwesomeMediaMarker(title: "Test Marker 1", time: 422),
                                          AwesomeMediaMarker(title: "Test Marker 2", time: 424),
                                          AwesomeMediaMarker(title: "Test Marker 3", time: 426),
                                          AwesomeMediaMarker(title: "Test Marker 4", time: 428),
                                          AwesomeMediaMarker(title: "Test Marker 5", time: 430),
                                          AwesomeMediaMarker(title: "Test Marker 6", time: 440),
                                          AwesomeMediaMarker(title: "Test Marker 7", time: 441)]
    public static let testAudioURL = "https://archive.org/download/VirtualHaircut/virtualbarbershop.mp3"
    public static let testPDFURL = "https://www.paloaltonetworks.com/content/dam/pan/en_US/assets/pdf/datasheets/wildfire/wildfire-ds.pdf"
    
    let cells: [MediaCell] = [
        MediaCell(type: .video,
                  mediaParams: AwesomeMediaParams(
                    url: "https://overmind2.mvstg.com/api/v1/assets/7cdddc7f-7344-4eee-8f05-eaeb49cc11ec.m3u8",
                    coverUrl: "https://thumbs.dreamstime.com/z/awesome-word-cloud-explosion-background-51481417.jpg",
                    author: "John",
                    title: "Caption test",
                    duration: 20,
                    markers: testMediaMarkers,
                    params: ["id":"123"])),
        MediaCell(type: .video,
                  mediaParams: AwesomeMediaParams(
                    url: "https://overmind2.mvstg.com/api/v1/assets/86f21617-6c69-40ef-9cca-d927bf737de1.m3u8",
                    coverUrl: "https://cdn.wccftech.com/wp-content/uploads/2017/05/subtitle-of-a-blu-ray-movie.jpg",
                    author: "John",
                    title: "Caption test 2",
                    duration: 20,
                    markers: testMediaMarkers,
                    params: ["id":"123"])),
        MediaCell(type: .audio,
                  mediaParams: AwesomeMediaParams(
                    url: testAudioURL,
                    coverUrl: "https://i.ytimg.com/vi/fwLuHqMMonc/0.jpg",
                    author: "The barber",
                    title: "Virtual Barbershop",
                    duration: 232,
                    size: "2 mb",
                    params: ["id":"45"])),
        MediaCell(type: .file,
                  mediaParams: AwesomeMediaParams(
                    url: testPDFURL,
                    coverUrl: "https://i0.wp.com/res.cloudinary.com/changethatmind/image/upload/v1501884914/wildfitsales.png?fit=500%2C500&ssl=1",
                    author: "Eric Mendez",
                    title: "Wildfit",
                    size: "2 mb",
                    type: "PDF",
                    params: ["id":"45"])),
        MediaCell(type: .image,
                  mediaParams: AwesomeMediaParams(
                    coverUrl: "https://www.awesometlv.co.il/wp-content/uploads/2016/01/awesome_logo-01.png")),
        /*MediaCell(type: .video,
                  mediaParams: AwesomeMediaParams(
                    url: testVideoURL,
                    coverUrl: "https://i0.wp.com/res.cloudinary.com/changethatmind/image/upload/v1501884914/wildfitsales.png?fit=500%2C500&ssl=1",
                    author: "Eric Mendez",
                    title: "WildFit 2",
                    duration: 12312,
                    markers: testMediaMarkers,
                    params: ["id":"45"])),*/
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
                    markers: testMediaMarkers,
                    params: ["id":"45"])),
        MediaCell(type: .youtube,
                  mediaParams: AwesomeMediaParams(
                    youtubeUrl: "https://www.youtube.com/watch?v=5WOxJ9rvU1s&t=3s",
                    coverUrl: "https://i0.wp.com/res.cloudinary.com/changethatmind/image/upload/v1501884914/wildfitsales.png?fit=500%2C500&ssl=1")),
        MediaCell(type: .youtube,
                  mediaParams: AwesomeMediaParams(
                    youtubeUrl: "https://www.youtube.com/watch?v=5WOxJ9rvU1s&t=3s",
                    coverUrl: "https://i0.wp.com/res.cloudinary.com/changethatmind/image/upload/v1501884914/wildfitsales.png?fit=500%2C500&ssl=1")),
        MediaCell(type: .verticalVideo,
                  mediaParams: AwesomeMediaParams(
                    url: testAudioURL,
                    coverUrl: "https://i.ytimg.com/vi/BiRED7kH-nQ/maxresdefault.jpg",
                    backgroundUrl: "https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4",
                    author: "Brett Ninja",
                    authorAvatar: "https://thumbs.dreamstime.com/z/awesome-word-cloud-explosion-background-51481417.jpg",
                    title: "Pushing the Senses",
                    about: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                    duration: 20,
                    shouldShowMiniPlayer: true,
                    sharingItems: ["jajajaja...."],
                    favourited: true))
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
        case .verticalVideo:
            return AwesomeMediaVideoTableViewCell.defaultSize.height
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if cells[indexPath.row].type == .verticalVideo {
            presentVerticalVideoFullscreen(withMediaParams: cells[indexPath.row].mediaParams)
        }
    }

}

extension UIViewController: AwesomeMediaEventObserver {
    public func addObservers() {
        AwesomeMediaNotificationCenter.addObservers([.showMiniPlayer, .hideMiniPlayer], to: self)
    }
    
    public func removeObservers() {
        AwesomeMediaNotificationCenter.removeObservers(from: self)
    }
    
    public func showMiniPlayer(_ notification: NSNotification) {
        if let params = notification.object as? AwesomeMediaParams {
            _ = view.addAudioPlayer(withParams: params, animated: true)
        } else {
            view.removeAudioControlView(animated: true)
        }
    }
    
    public func hideMiniPlayer(_ notification: NSNotification) {
        view.removeAudioControlView(animated: true)
    }
}
