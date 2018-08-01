//
//  CourseChapterMP.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 13/07/17.
//

import Foundation

public struct CourseChapterMP {
    
    private init() {
        
    }
    
    public static func parseCourseChapterFrom(jsonObject: [String: AnyObject]) -> ACCourseChapter? {
        
        var array: [Section] = []
        if let jsonArray = jsonObject["sections"] as? [[String: AnyObject]] {
            for object in jsonArray {
                if let section = SectionMP.parseSectionFrom(jsonObject: object) {
                    array.append(section)
                }
            }
        }
        
        let courseChapter = ACCourseChapter(
            courseChapterId: AwesomeCoreParser.intValue(jsonObject, key: "id"),
            title: ParserCoreHelper.parseString(jsonObject, key: "title"),
            position: AwesomeCoreParser.intValue(jsonObject, key: "position"),
            isCompleted: ParserCoreHelper.parseBool(jsonObject, key: "is_read") as! Bool,
            sections: array)
        
        
        return courseChapter
    }
    
}
