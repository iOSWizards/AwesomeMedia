//
//  UIBarItem.swift
//  AwesomeLocalization
//
//  Created by Evandro Harrison Hoffmann on 10/10/17.
//

import UIKit

@IBDesignable
extension UIBarItem {
    
    // MARK: - Associations
    
    private static let localizedTextAssociation = ObjectAssociation<NSObject>()
    private static let customLocalizationFileAssociation = ObjectAssociation<NSObject>()
    
    // MARK: - Inspectables
    
    @IBInspectable
    public var localizedText: String {
        get {
            return UIBarItem.localizedTextAssociation[self] as? String ?? ""
        }
        set (localizedText) {
            UIBarItem.localizedTextAssociation[self] = localizedText as NSObject
            updateLocalization()
        }
    }
    
    @IBInspectable
    public var customLocalizationFile: String? {
        get {
            return UIBarItem.customLocalizationFileAssociation[self] as? String
        }
        set (localizationTable) {
            UIBarItem.customLocalizationFileAssociation[self] = localizationTable as NSObject?
            updateLocalization()
        }
    }
    
    // MARK: - Localization
    
    public func updateLocalization() {
        title = localizedText.localized(tableName: customLocalizationFile)
    }
}


