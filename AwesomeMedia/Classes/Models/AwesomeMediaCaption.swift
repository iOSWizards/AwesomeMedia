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
    
    public init(url: String, label: String, language: String){
        self.url = url
        self.label = label
        self.language = language
    }
}
