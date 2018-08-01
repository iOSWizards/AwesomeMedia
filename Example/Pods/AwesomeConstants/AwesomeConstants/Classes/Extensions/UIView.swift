//
//  UIView+Parallax.swift
//  Quests
//
//  Created by Evandro Harrison Hoffmann on 4/1/17.
//  Copyright © 2017 Mindvalley. All rights reserved.
//

import UIKit

// MARK: - Background effect

extension UIView {

    public func clearMotionEffects() {
        let motionEffects = self.motionEffects
        for motionEffect in motionEffects {
            self.removeMotionEffect(motionEffect)
        }
    }

    public func addBackgroundEffect(withMargin margin: Double, inverted: Bool = false) {
        //remove motion effects
        clearMotionEffects()

        // Set vertical effect
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = inverted ? margin : -margin
        verticalMotionEffect.maximumRelativeValue = inverted ? -margin : margin

        // Set horizontal effect
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = inverted ? margin : -margin
        horizontalMotionEffect.maximumRelativeValue = inverted ? -margin : margin

        // Create group to combine both
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]

        // Add both effects to your view
        self.addMotionEffect(group)
    }

}
