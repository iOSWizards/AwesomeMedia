//
//  StringExtensions.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/27/18.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: AwesomeMedia.bundle, value: "", comment: "")
    }
}
