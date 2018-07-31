//
//  String+Localized.swift
//  Mindvalley
//
//  Created by Evandro Harrison Hoffmann on 10/4/17.
//  Copyright © 2017 Mindvalley. All rights reserved.
//

import Foundation

extension String {
    
    // MARK: - Data
    
    public var utf8Data: Data? {
        return data(using: String.Encoding.utf8)
    }
    
    // MARK: - HTML
    
    public var stripHTML: String? {
        return replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    public func appendHTML(font: UIFont? = nil, fontColor: UIColor? = nil, alignment: NSTextAlignment? = nil) -> String {
        var styles = ""
        
        if let color = fontColor?.toHexString() {
            styles.append("color: \(color);")
        }
        
        if let font = font {
            let fontName = font.fontName.replacingOccurrences(of: ".", with: "")
            let fontFamily = fontName.components(separatedBy: "-").first ?? ""
            
            styles.append("font-size: \(font.pointSize)px;")
            styles.append("font-family: '-apple-system', '\(fontFamily)', '\(fontName)', '\(fontFamily)-Bold';")
        }
        
        if let alignment = alignment {
            switch alignment {
            case .center:
                styles.append("text-align: center;")
                break
            case .justified:
                styles.append("text-align: justified;")
                break
            case .left:
                styles.append("text-align: left;")
                break
            case .right:
                styles.append("text-align: right;")
                break
            case .natural:
                styles.append("text-align: natural;")
                break
            }
        }
        
        //styles
        let body = "body {\(styles)}"
        let bold = "b {font-weight: bold;}"
        
        return ("<html><head><style>\(body) \(bold)</style></head><body>\(self)</body></html>")
    }
    
    // MARK: - Localization
    
    public var localized: String {
        return self.localized()
    }
    
    public func localized(tableName: String? = nil, bundle: Bundle = .main) -> String {
        return NSLocalizedString(self, tableName: tableName ?? "Localizable", bundle: bundle, value: "", comment: "")
    }
    
    public func localizedAttributed(tableName: String? = nil, bundle: Bundle = .main, font: UIFont? = nil, fontColor: UIColor? = nil, alignment: NSTextAlignment? = nil) -> NSAttributedString? {
        let localizedString = localized(tableName: tableName, bundle: bundle)
        
        return localizedString.appendHTML(font: font, fontColor: fontColor, alignment: alignment).utf8Data?.attributedString
    }
    
}
