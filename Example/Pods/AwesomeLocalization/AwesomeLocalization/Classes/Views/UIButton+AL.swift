//
//  UIView+Localized.swift
//  AwesomeLocalization
//
//  Created by Evandro Harrison Hoffmann on 10/4/17.
//

import UIKit

@IBDesignable
extension UIButton {
    
    // MARK: - Associations
    
    private static let localizedTextAssociation = ObjectAssociation<NSObject>()
    private static let customLocalizationFileAssociation = ObjectAssociation<NSObject>()
    private static let isAttributedLocalizationAssociation = ObjectAssociation<NSObject>()
    
    // MARK: - Inspectables
    
    @IBInspectable
    public var localizedText: String {
        get {
            return UIButton.localizedTextAssociation[self] as? String ?? ""
        }
        set (localizedText) {
            UIButton.localizedTextAssociation[self] = localizedText as NSObject
            updateLocalization()
        }
    }
    
    @IBInspectable
    public var customLocalizationFile: String? {
        get {
            return UIButton.customLocalizationFileAssociation[self] as? String
        }
        set (localizationTable) {
            UIButton.customLocalizationFileAssociation[self] = localizationTable as NSObject?
            updateLocalization()
        }
    }
    
    @IBInspectable
    public var isAttributedLocalization: Bool {
        get {
            return UIButton.isAttributedLocalizationAssociation[self] as? Bool ?? false
        }
        set (isLocalizationAttributed) {
            UIButton.isAttributedLocalizationAssociation[self] = isLocalizationAttributed as NSObject
            updateLocalization()
        }
    }
    
    // MARK: - Localization
    
    public func updateLocalization() {
        if isAttributedLocalization,  let attributedText = localizedText.localizedAttributed(tableName: customLocalizationFile, font: titleLabel?.font, fontColor: titleColor(for: .normal), alignment: titleLabel?.textAlignment) {
            setAttributedTitle(attributedText, for: .normal)
        } else {
            setTitle(localizedText.localized(tableName: customLocalizationFile), for: .normal)
        }
    }
}

