//
//  UINavigationItem+AL.swift
//  AwesomeLocalization
//
//  Created by Evandro Harrison Hoffmann on 10/10/17.
//

import UIKit

@IBDesignable
extension UINavigationItem {
    
    // MARK: - Associations
    
    private static let localizedTextAssociation = ObjectAssociation<NSObject>()
    private static let customLocalizationFileAssociation = ObjectAssociation<NSObject>()
    
    // MARK: - Inspectables
    
    @IBInspectable
    public var localizedText: String {
        get {
            return UINavigationItem.localizedTextAssociation[self] as? String ?? ""
        }
        set (localizedText) {
            UINavigationItem.localizedTextAssociation[self] = localizedText as NSObject
            updateLocalization()
        }
    }
    
    @IBInspectable
    public var customLocalizationFile: String? {
        get {
            return UINavigationItem.customLocalizationFileAssociation[self] as? String
        }
        set (localizationTable) {
            UINavigationItem.customLocalizationFileAssociation[self] = localizationTable as NSObject?
            updateLocalization()
        }
    }
    
    // MARK: - Localization
    
    public func updateLocalization() {
        title = localizedText.localized(tableName: customLocalizationFile)
    }
}

