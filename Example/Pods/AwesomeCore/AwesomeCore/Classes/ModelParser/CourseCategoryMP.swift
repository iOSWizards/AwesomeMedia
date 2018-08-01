//
//  CourseCategoryMP.swift
//  Pods
//
//  Created by Emmanuel on 28/06/2018.
//

import Foundation

public struct CourseCategoryMP {
    
    static func parseCourseCategoriesFrom(jsonObject: [String: AnyObject], key: String) -> [ACCourseCategory] {
        var courseCategories = [ACCourseCategory]()
        guard let jsonCourseCategories = jsonObject[key] as? [[String: AnyObject]] else {
            return courseCategories
        }
        for json in jsonCourseCategories {
            courseCategories.append(parseCourseCategoryFrom(jsonObject: json) )
        }
        return courseCategories
    }
    
    public static func parseCourseCategoryFrom(jsonObject: [String: AnyObject]) -> ACCourseCategory {
        return ACCourseCategory(
            id: AwesomeCoreParser.intValue(jsonObject, key: "id"),
            name: ParserCoreHelper.parseString(jsonObject, key: "name"),
            ancestorId: ParserCoreHelper.parseString(jsonObject, key: "ancestor_id"),
            ancestorName: ParserCoreHelper.parseString(jsonObject, key: "ancestor_name")
        )
    }
}
