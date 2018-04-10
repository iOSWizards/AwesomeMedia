//
//  AwesomeMediaVideoTitleView.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/5/18.
//

import UIKit

public class AwesomeMediaVideoTitleView: UIView {

    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var closeButton: UIButton!
    @IBOutlet public weak var airplayButton: UIButton!

    // Callbacks
    public var closeCallback: (() -> Void)?
    public var airplayCallback: (() -> Void)?
    
    // Configuration
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }
    
    public func configure() {
       
    }
    
    // MARK: - Events
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        closeCallback?()
    }
    
    @IBAction func airplayButtonPressed(_ sender: Any) {
        airplayCallback?()
    }
    
}

// MARK: - Toggle View
extension AwesomeMediaVideoTitleView {
    public func toggleView() {
        animateToggle(direction: .up)
    }
}


// MARK: - View Initialization

extension AwesomeMediaVideoTitleView {
    public static var newInstance: AwesomeMediaVideoTitleView {
        return AwesomeMedia.bundle.loadNibNamed("AwesomeMediaVideoTitleView", owner: self, options: nil)![0] as! AwesomeMediaVideoTitleView
    }
}

extension UIView {
    public func addVideoTitle() -> AwesomeMediaVideoTitleView {

        // remove title view before adding new one
        removeVideoTitleView()
        
        let controlView = AwesomeMediaVideoTitleView.newInstance
        addSubview(controlView)
        controlView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: controlView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: controlView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: controlView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: controlView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 91))
        
        return controlView
    }
    
    public func removeVideoTitleView() {
        for subview in subviews where subview is AwesomeMediaVideoTitleView {
            subview.removeFromSuperview()
        }
    }
}

