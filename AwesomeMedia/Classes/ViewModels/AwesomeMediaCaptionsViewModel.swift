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

public struct AwesomeMediaCaptionCellObject {
    public var caption: AwesomeMediaCaption?
    
    public init(caption: AwesomeMediaCaption? = nil) {
        self.caption = caption
    }
}

public class AwesomeMediaCaptionsViewModel: NSObject {
    
    public var cells = [AwesomeMediaCaptionCellObject]()
    public var selectedIndex = 0
    
    public func configure(with captions: [AwesomeMediaCaption], current: AwesomeMediaCaption?) {
        
        var cells = [AwesomeMediaCaptionCellObject]()
        
        cells.append(AwesomeMediaCaptionCellObject())
        
        for caption in captions {
            if current == caption {
                selectedIndex = cells.count
            }
            
            cells.append(AwesomeMediaCaptionCellObject(caption: caption))
        }
     
        self.cells = cells
    }
    
}

// MARK: - Captions TableView Datasource and Delegate

extension AwesomeMediaCaptionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Quantity
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cells.count
    }
    
    // MARK: - Cell Configuration
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type: AwesomeMediaCaptionCellType = viewModel.selectedIndex == indexPath.row ? .captionSelected : .caption
        let cell = tableView.dequeueReusableCell(withIdentifier: type.rawValue, for: indexPath) as! AwesomeMediaCaptionTableViewCell
        
        cell.titleLabel.text = viewModel.cells[indexPath.row].caption?.label ?? "Off".localized
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.captionCallback?(viewModel.cells[indexPath.row].caption)
        
        // select index
        viewModel.selectedIndex = indexPath.row
        tableView.reloadData()
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
