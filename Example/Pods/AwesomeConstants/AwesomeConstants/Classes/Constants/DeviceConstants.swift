//
//  SchemaConstants.swift
//  Mindvalley
//
//  Created by Evandro Harrison Hoffmann on 2/14/18.
//  Copyright © 2018 Mindvalley. All rights reserved.
//

import UIKit

public var isPad: Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}

public var isPhone: Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
}

public var isPadPro1366: Bool {
    return UIScreen.main.bounds.width >= 1366 || UIScreen.main.bounds.height >= 1366
}

public var isPhonePlus: Bool {
    return UIScreen.main.traitCollection.displayScale == 3.0
}

public var isPhoneX: Bool {
    return (UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436)
}

public var isLandscape: Bool {
    return (UIDevice.current.orientation.isLandscape || !UIDevice.current.orientation.isPortrait) && UIDevice.current.orientation.isValidInterfaceOrientation
}

public var screenSizeDisregardingOrientation: CGSize {
    if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    return CGSize(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width)
}

public var aspectRatio16_9: CGFloat {
    return CGFloat(9.0/16.0)
}
