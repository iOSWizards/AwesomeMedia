//
//  AwesomeMediaMarkersViewController.swift
//  AwesomeMedia
//
//  Created by Emmanuel on 18/04/2018.
//

import UIKit

public typealias MarkerCallback = (AwesomeMediaMarker?) -> Void

public class AwesomeMediaMarkersViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton?
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    // ViewModel
    public var viewModel = AwesomeMediaMarkersViewModel()
    
    // Callbacks
    public var markerCallback: MarkerCallback?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareForAnimation()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateIn()
    }
    
    // MARK - Animations
    
    public func prepareForAnimation() {
        contentView?.isHidden = true
        self.closeButton?.alpha = 0
    }
    
    public func animateIn() {
        contentView.isHidden = false
        contentView.frame.origin.x = self.view.frame.size.width
        
        UIView.animate(withDuration: 0.3) {
            self.closeButton?.alpha = 1
            self.contentView.frame.origin.x = self.view.frame.size.width - self.contentView.frame.size.width
        }
    }
    
    public func animateOut(completion: @escaping ()->Void) {
        UIView.animate(withDuration: 0.2, animations: {
            self.closeButton?.alpha = 0
            self.contentView.frame.origin.x = self.view.frame.size.width
            self.contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (completed) in
            completion()
        }
    }
    
    // MARK: - EVENTS
    @IBAction public func closeButtonPressed(_ sender: AnyObject) {
        animateOut {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
}

// MARK: - ViewController Initialization

extension AwesomeMediaMarkersViewController {
    public static var newInstance: AwesomeMediaMarkersViewController {
        let storyboard = UIStoryboard(name: "AwesomeMedia", bundle: AwesomeMedia.bundle)
        
        return storyboard.instantiateViewController(withIdentifier: "AwesomeMediaMarkersViewController") as! AwesomeMediaMarkersViewController
    }
}

extension UIViewController {
    public func showMarkers(_ markerCallback: MarkerCallback? = nil) {
        let viewController = AwesomeMediaMarkersViewController.newInstance
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: false, completion: nil)
        
        viewController.markerCallback = markerCallback
    }
}
