//
//  AwesomeMediaCaptionViewController.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 6/7/18.
//

import UIKit

public typealias CaptionCallback = (AwesomeMediaCaption?) -> Void

public class AwesomeMediaCaptionsViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton?
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    // ViewModel
    public var viewModel = AwesomeMediaCaptionsViewModel()
    
    // Callbacks
    public var captionCallback: CaptionCallback?
    
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
    
    public func close() {
        animateOut {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: - EVENTS
    @IBAction public func closeButtonPressed(_ sender: AnyObject) {
        close()
        
        // track event
        track(event: .closedCaptions, source: .videoFullscreen)
    }
    
}

// MARK: - ViewController Initialization

extension AwesomeMediaCaptionsViewController {
    public static var newInstance: AwesomeMediaCaptionsViewController {
        let storyboard = UIStoryboard(name: "AwesomeMedia", bundle: AwesomeMedia.bundle)
        
        return storyboard.instantiateViewController(withIdentifier: "AwesomeMediaCaptionsViewController") as! AwesomeMediaCaptionsViewController
    }
}

extension UIViewController {
    public func showCaptions(_ captions: [AwesomeMediaCaption], captionCallback: CaptionCallback? = nil) {
        let viewController = AwesomeMediaCaptionsViewController.newInstance
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.viewModel.captions = captions
        self.present(viewController, animated: false, completion: nil)
        
        viewController.captionCallback = captionCallback
    }
}
