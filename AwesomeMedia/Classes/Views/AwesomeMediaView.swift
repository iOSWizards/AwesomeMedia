//
//  AwesomeMediaView.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/5/18.
//

import UIKit
import AVFoundation

public class AwesomeMediaView: UIView {

    public var avPlayerLayer = AVPlayerLayer()

    public override func awakeFromNib() {
        super.awakeFromNib()
        
        addPlayerLayer()
    }
    
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        avPlayerLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
    }
    
    public func addPlayerLayer(){
        self.layer.insertSublayer(avPlayerLayer, at: 0)
        self.layer.masksToBounds = true
    }
}
