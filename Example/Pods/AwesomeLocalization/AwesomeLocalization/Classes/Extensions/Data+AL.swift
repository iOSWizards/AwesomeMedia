//
//  Data+Attributed.swift
//  AwesomeLocalization
//
//  Created by Evandro Harrison Hoffmann on 10/5/17.
//

import Foundation

extension Data {
    public var attributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options:[
                NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html,
                NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
                ], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
