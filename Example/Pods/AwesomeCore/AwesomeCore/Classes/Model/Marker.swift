//
//  Marker.swift
//  AwesomeCore_Example
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 10/07/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

public struct Marker: Codable, Equatable {
    
    public var courseChapterSectionMarkerId: Int = -1
    public var title: String = ""
    public var time: Int = -1
    
    public init() {
        self.courseChapterSectionMarkerId = -1
        self.title = ""
        self.time = -1
    }
    
    public init(courseChapterSectionMarkerId: Int, title: String, time: Int) {
        self.courseChapterSectionMarkerId = courseChapterSectionMarkerId
        self.title = title
        self.time = time
    }
    
}

// MARK: - Model validation

extension Marker {
    
    func validate() -> Bool {
        if title.isEmpty || time <= -1 || courseChapterSectionMarkerId <= -1 {
            return false
        }
        return true
    }
    
    public static func ==(lhs: Marker, rhs: Marker) -> Bool {
        if lhs.title != rhs.title {
            return false
        }
        if lhs.courseChapterSectionMarkerId != rhs.courseChapterSectionMarkerId {
            return false
        }
        if lhs.time != rhs.time {
            return false
        }
        return true
    }
    
}
