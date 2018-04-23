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

// MARK: - TableView Configuration

extension AwesomeMediaMarkersViewModel{
    
    open func estimatedSizeForCellAtIndexPath(_ indexPath: IndexPath) -> CGFloat{
        return 74
    }
    
    open func sizeForCellAtIndexPath(_ indexPath: IndexPath) -> CGFloat{
        return UITableViewAutomaticDimension
    }
    
    open func sectionCount() -> Int{
        return 1
    }
    
    open func rowCount(_ section: Int) -> Int{
        return markers.count
    }
    
    open func cell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "marker", for: indexPath) as! AwesomeMediaMarkerTableViewCell
        
        cell.titleLabel.text = markers[indexPath.row].title
        cell.timeLabel.text = markers[indexPath.row].time.formatedTime
        
        return cell
    }
    
    open func marker(forIndexPath indexPath: IndexPath) -> AwesomeMediaMarker{
        return markers[indexPath.row]
    }
}
