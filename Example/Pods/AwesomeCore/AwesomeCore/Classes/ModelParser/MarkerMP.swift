//
//  MarkerMP.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 10/07/2017.
//

import Foundation

public struct MarkerMP {
    
    private init() {
        
    }
    
    /// Parses an JSON object to the model Marker, in case the json object:
    /// has no _title_ or _time_ or _courseChapterSectionMarkerId_ it returns nil.
    ///
    /// - Parameters:
    ///   - jsonObject: JSON object to be parsed.
    ///   - parseSuccess: Marker object with its properties populated.
    public static func parseMarkerFrom(jsonObject: [String: AnyObject]) -> Marker? {
        
        var marker = Marker()
        
        marker.courseChapterSectionMarkerId = AwesomeCoreParser.intValue(jsonObject, key: "id")
        marker.title = ParserCoreHelper.parseString(jsonObject, key: "title")
        marker.time = AwesomeCoreParser.intValue(jsonObject, key: "time")
        
        if marker.validate() {
            return marker
        }
    
        return nil
        
    }
    
}
