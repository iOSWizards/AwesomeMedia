//
//  AwesomeMediaMarkersViewController.swift
//  AwesomeMedia
//
//  Created by Emmanuel on 18/04/2018.
//

import UIKit

public protocol AwesomeMediaMarkersViewControllerDelegate {
    func markerSelected(marker: AwesomeMediaMarker)
}

public class AwesomeMediaMarkersViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton?
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    // ViewModel
    public var viewModel = AwesomeMediaMarkersViewModel()
    
    // Delegate
    public var delegate: AwesomeMediaMarkersViewControllerDelegate?
    
    // Public Variables
    public var isOpeningFromPanning =  false
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        configureForPanning()
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
        closeButton?.alpha = 0
        contentView?.isHidden = true
    }
    
    public func animateIn() {
        let originalFrame = contentView.frame
        
        contentView.isHidden = false
        contentView.frame.origin.x = self.view.frame.size.width
        
        if !isOpeningFromPanning {
            UIView.animate(withDuration: 0.3, animations: {
                self.closeButton?.alpha = 1
                self.contentView.frame = originalFrame
            }) { (completed) in
                // code to run after animating in
            }
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
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Panning
    fileprivate var initialCenter = CGPoint(x: 0, y: 0)
    fileprivate var initialTouchPoint = CGPoint(x: 0, y: 0)
    fileprivate var lastDistanceFromTarget = CGPoint(x: 0, y: 0)
    fileprivate let distanceToClose: CGFloat = 100
    fileprivate let alphaAnimationTime: Double = 0.2
    
    public func configureForPanning() {
        let pan = UIPanGestureRecognizer(target: self, action: .pan)
        
        pan.maximumNumberOfTouches = 1
        pan.minimumNumberOfTouches = 1
        view.addGestureRecognizer(pan)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

// MARK: - Markers TableView Datasource and Delegate
extension AwesomeMediaMarkersViewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowCount(section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cell(tableView, indexPath: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.markerSelected(marker: viewModel.marker(forIndexPath: indexPath))
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
}

// MARK - Selectors

fileprivate extension Selector {
    static let pan = #selector(AwesomeMediaMarkersViewController.pan(_:))
}

// MARK: - @OBJC FUNCTIONS
extension AwesomeMediaMarkersViewController {
    @objc public func pan(_ rec: UIPanGestureRecognizer) {
        let point: CGPoint = rec.location(in: self.view)
        let distance: CGPoint = CGPoint(x: point.x, y: point.y - initialTouchPoint.y)
        
        switch rec.state {
        case .began:
            initialTouchPoint = point
        default:
            break
        }
        
        updateContentPosition(withDistance: distance, state: rec.state)
    }
    
    public func updateContentPosition(withDistance distance: CGPoint, state: UIGestureRecognizerState) {
        let xPoint: CGFloat = self.view.frame.size.width - self.contentView.frame.size.width/2
        let targetCenter = CGPoint(x: xPoint, y: self.contentView.center.y)
        let distanceFromTarget = CGPoint(x: targetCenter.x - contentView.center.x, y: targetCenter.y - contentView.center.y)
        
        var initialCenter = targetCenter
        
        if isOpeningFromPanning {
            initialCenter.x = self.view.frame.size.width + self.contentView.frame.size.width/2
        }
        
        switch state {
        case .began:
            break
        case .changed:
            contentView.center.x = initialCenter.x + distance.x
            
        // avoid going further than the initial position to the left
            if contentView.center.x < targetCenter.x {
                contentView.center.x = targetCenter.x
            }
            
            closeButton?.alpha = 1 - abs(distanceFromTarget.x / contentView.frame.size.width)
            
        case .ended:
            isOpeningFromPanning = false
            
            if lastDistanceFromTarget.x > distanceFromTarget.x {
                closeButtonPressed(self)
                
            } else {
                // returns to initial configuration
                contentView.translatesAutoresizingMaskIntoConstraints = false
                
                UIView.animate(withDuration: 0.3) {
                    self.contentView.center = targetCenter
                }
                
                closeButton?.alpha = 1
            }
            
        default:
            break
        }
        
        // set lastDistance to distanceFromTarget
        lastDistanceFromTarget = distanceFromTarget
    }
}
