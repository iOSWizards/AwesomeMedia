//
//  AwesomeMediaCaption.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 6/6/18.
//

import Foundation

public struct AwesomeMediaCaption {
    public var url: String = ""
    public var label: String = ""
    public var language: String = ""
    public var isDefault: Bool = false
    
    public init(url: String, label: String, language: String, isDefault: Bool){
        self.url = url
        self.label = label
        self.language = language
        self.isDefault = isDefault
    }
}
