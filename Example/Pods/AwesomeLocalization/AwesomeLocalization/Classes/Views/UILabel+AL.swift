//
//  UILabel+Localized.swift
//  AwesomeLocalization
//
//  Created by Evandro Harrison Hoffmann on 10/4/17.
//

import UIKit

@IBDesignable
extension UILabel {
    
    // MARK: - Associations
    
    private static let localizedTextAssociation = ObjectAssociation<NSObject>()
    private static let customLocalizationFileAssociation = ObjectAssociation<NSObject>()
    private static let isAttributedLocalizationAssociation = ObjectAssociation<NSObject>()

    // MARK: - Inspectables
    
    @IBInspectable
    public var localizedText: String {
        get {
            return UILabel.localizedTextAssociation[self] as? String ?? ""
        }
        set (localizedText) {
            UILabel.localizedTextAssociation[self] = localizedText as NSObject
            updateLocalization()
        }
    }
    
    @IBInspectable
    public var customLocalizationFile: String? {
        get {
            return UILabel.customLocalizationFileAssociation[self] as? String
        }
        set (localizationTable) {
            UILabel.customLocalizationFileAssociation[self] = localizationTable as NSObject?
            updateLocalization()
        }
    }
    
    @IBInspectable
    public var isAttributedLocalization: Bool {
        get {
            return UILabel.isAttributedLocalizationAssociation[self] as? Bool ?? false
        }
        set (isLocalizationAttributed) {
            UILabel.isAttributedLocalizationAssociation[self] = isLocalizationAttributed as NSObject
            updateLocalization()
        }
    }
    
    // MARK: - Localization
    
    public func updateLocalization() {
        if isAttributedLocalization, let attributedText = localizedText.localizedAttributed(tableName: customLocalizationFile, font: font, fontColor: textColor, alignment: textAlignment) {
            self.attributedText = attributedText
        } else {
            text = localizedText.localized(tableName: customLocalizationFile)
        }
    }
}
