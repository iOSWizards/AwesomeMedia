//
//  UITableViewCellExtensions.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 5/3/18.
//

import UIKit

extension UITableViewCell {
    
    fileprivate static var isAdjustingSize = false
    
    public var tableView: UITableView? {
        var view: UIView? = superview
        
        while view != nil, !(view is UITableView) {
            view = view?.superview
        }
        
        return view as? UITableView
    }
    
    public func updateTableView() {
        guard !UITableViewCell.isAdjustingSize else {
            return
        }
        UITableViewCell.isAdjustingSize = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {
            if let tableView = self.tableView {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            UITableViewCell.isAdjustingSize = false
        }
    }
    
}
