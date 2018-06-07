//
//  AwesomeMediaCaptionsViewModel.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 6/7/18.
//

import Foundation
import UIKit

public enum AwesomeMediaCaptionCellType: String {
    case captionSelected
    case caption
}

open class AwesomeMediaCaptionsViewModel: NSObject {
    
    open var currentTime: Double?
    open var captions = [AwesomeMediaCaption]()
    open var showHours = false
    open var currentCaption: AwesomeMediaCaption?
    
}

// MARK: - Captions TableView Datasource and Delegate

extension AwesomeMediaCaptionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Quantity
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.captions.count
    }
    
    // MARK: - Cell Configuration
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let isCurrent = viewModel.captions[indexPath.row] == viewModel.currentCaption
        
        let cell = tableView.dequeueReusableCell(withIdentifier: isCurrent ? AwesomeMediaCaptionCellType.captionSelected.rawValue : AwesomeMediaCaptionCellType.caption.rawValue, for: indexPath) as! AwesomeMediaCaptionTableViewCell
        
        cell.titleLabel.text = viewModel.captions[indexPath.row].label
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.captionCallback?(viewModel.captions[indexPath.row])
        self.close()
        
        // track event
        track(event: .selectedCaption, source: .videoFullscreen)
    }
    
    // MARK: - Dimensions
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
