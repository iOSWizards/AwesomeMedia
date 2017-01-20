//
//  AwesomeMediaViewController.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 18/01/2017.
//
//

import UIKit

open class AwesomeMediaViewController: UIViewController {

    @IBOutlet open weak var mediaView: AwesomeMediaView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction open func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK: - Events

extension AwesomeMediaViewController {
    
    open func prepareMedia(withUrl url: URL?, replaceCurrent: Bool = false, startPlaying: Bool = false) {
        mediaView.prepareMedia(withUrl: url, replaceCurrent: replaceCurrent, startPlaying: startPlaying)
    }
    
}

extension AwesomeMediaViewController {
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
}
