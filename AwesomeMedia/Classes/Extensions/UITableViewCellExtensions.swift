//
//  UITableViewCellExtensions.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 5/3/18.
//

import UIKit

extension UITableViewCell {
    
    public var tableView: UITableView? {
        var view: UIView? = superview
        
        while view != nil, !(view is UITableView) {
            view = view?.superview
        }
        
        return view as? UITableView
    }
    
}
