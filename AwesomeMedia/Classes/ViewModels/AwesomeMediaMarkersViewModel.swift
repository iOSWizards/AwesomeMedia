//
//  AwesomeMediaMarkersViewModel.swift
//  AwesomeMedia
//
//  Created by Emmanuel on 19/04/2018.
//

import Foundation
import UIKit

open class AwesomeMediaMarkersViewModel: NSObject {
    
    open var currentTime: Double?
    open var markers = [AwesomeMediaMarker]()
    open var showHours = false
    
}

// MARK: - Markers TableView Datasource and Delegate

extension AwesomeMediaMarkersViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Quantity
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.markers.count
    }
    
    // MARK: - Cell Configuration
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "marker", for: indexPath) as! AwesomeMediaMarkerTableViewCell
        
        cell.titleLabel.text = viewModel.markers[indexPath.row].title
        cell.timeLabel.text = viewModel.markers[indexPath.row].time.formatedTime
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.markerCallback?(viewModel.markers[indexPath.row])
    }
    
    // MARK: - Dimensions
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
