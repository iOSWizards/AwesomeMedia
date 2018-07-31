//
//  StringExtensions.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/27/18.
//

import Foundation

extension String {
    public var url: URL? {
        return URL(string: self)
    }
}
