//
//  AwesomeMediaAudioSoulvanaViewController.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 8/8/18.
//

import UIKit

public class AwesomeMediaAudioAuthorViewController: AwesomeMediaAudioViewController {
    
    @IBOutlet public weak var authorImageView: UIImageView!
    @IBOutlet public weak var authorNameLabel: UILabel!
    @IBOutlet public weak var aboutAudioTextView: UITextView!
    
    override func configure() {
        super.configure()
        
        setupAuthorInfo()
    }
    
    fileprivate func setupAuthorInfo() {
        authorImageView.setImage(mediaParams.authorAvatar)
        authorNameLabel.text = mediaParams.author
        aboutAudioTextView.text = mediaParams.about
    }
}
