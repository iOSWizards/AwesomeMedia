//
//  AwesomeMediaMarkers.swift
//  AwesomeMedia
//
//  Created by Emmanuel on 19/04/2018.
//

import Foundation

public struct AwesomeMediaMarker {
    public var title: String = ""
    public var time: Double = 0
    
    public init(title: String, time: Double){
        self.title = title
        self.time = time
    }
}
