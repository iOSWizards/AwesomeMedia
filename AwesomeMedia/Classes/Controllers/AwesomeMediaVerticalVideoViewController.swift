//
//  AwesomeMediaAudioSoulvanaViewController.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 8/8/18.
//

import UIKit

public class AwesomeMediaVerticalVideoViewController: AwesomeMediaAudioViewController {
    
    @IBOutlet public weak var mediaView: UIView!
    @IBOutlet public weak var authorImageView: UIImageView!
    @IBOutlet public weak var authorNameLabel: UILabel!
    @IBOutlet public weak var aboutAudioTextView: UITextView!
    
    override func configure() {
        super.configure()
        
        setupAuthorInfo()
        
        // remove player layer so that we can add it again when needed
        mediaView.removePlayerLayer()
        
        // check for media playing
        if let item = sharedAVPlayer.currentItem(withParams: mediaParams) {
            controlView?.update(withItem: item)
            
            mediaView.addPlayerLayer()
        }
    }
    
    fileprivate func setupAuthorInfo() {
        authorImageView.setImage(mediaParams.authorAvatar)
        authorNameLabel.text = mediaParams.author
        aboutAudioTextView.text = mediaParams.about
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        AwesomeMediaPlayerLayer.shared.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
}
