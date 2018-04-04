//
//  UIView+Layers.swift
//  MV UI Hacks
//
//  Created by Evandro Harrison Hoffmann on 07/07/2016.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: - Triangle
    
    public func addTringleView(_ rect: CGRect, fillColor: UIColor) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.closePath()
        
        context.setFillColor(fillColor.cgColor)
        context.fillPath()
    }
    
    // MARK: - Single corner radius
    
    public func addCornerRadius(byRoundingCorners corners: UIRectCorner, radius: CGFloat) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.frame, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = rectShape
        self.layer.masksToBounds = true
        self.layoutIfNeeded()
    }
    
    // MARK: - Blur effect
    
    public func addBluredBackground(style: UIBlurEffectStyle = .dark) {
        for view in subviews {
            if view is UIVisualEffectView {
                view.removeFromSuperview()
            }
        }
        
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    
//    // MARK: - MagicID Associations
//    
//    private static let magicID = ObjectAssociation<NSObject>()
//
//    // MARK: - MagicID
//
//    @IBInspectable
//    public var magicID: String {
//        get {
//            return UIView.magicID[self] as? String ?? ""
//        }
//        set (newValue) {
//            UIView.magicID[self] = newValue as NSObject
//        }
//    }
//
//    // MARK: - Snapshots
//
//    public func snapshotsFrom() -> [(UIView, CGPoint, CGRect)] {
//        return processSnapshots(snapshotsArray: [])
//    }
//
//    fileprivate func processSnapshots(_ subviews: [UIView]? = nil, snapshotsArray: [(UIView, CGPoint, CGRect)]) -> [(UIView, CGPoint, CGRect)] {
//        var snapshots = snapshotsArray
//        for view in (subviews ?? self.subviews) {
//            if !view.magicID.isEmpty {
//                view.subviews.forEach({ $0.isHidden = true })
//                if let snapshot = view.snapshotView(afterScreenUpdates: true) {
//                    view.subviews.forEach({ $0.isHidden = false })
//                    snapshot.magicID = view.magicID
//                    snapshots.append((snapshot, self.convert(view.center, from: view.superview), self.convert(view.frame, from: view.superview)))
//                }
//            }
//
//            if !view.subviews.isEmpty {
//                snapshots = processSnapshots(view.subviews, snapshotsArray: snapshots)
//            }
//        }
//        return snapshots
//    }
    
}
