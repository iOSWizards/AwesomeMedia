//
//  CourseAcademyMP.swift
//  Pods
//
//  Created by Emmanuel on 28/06/2018.
//

import Foundation

public struct CourseAcademyMP {
    
    static func parseCourseAcademiesFrom(jsonObject: [String: AnyObject], key: String) -> [ACCourseAcademy] {
        var courseAcademies = [ACCourseAcademy]()
        guard let jsonCourseAcademies = jsonObject[key] as? [[String: AnyObject]] else {
            return courseAcademies
        }
        for json in jsonCourseAcademies {
            courseAcademies.append(parseCourseAcademyFrom(jsonObject: json) )
        }
        return courseAcademies
    }
    
    public static func parseCourseAcademyFrom(jsonObject: [String: AnyObject]) -> ACCourseAcademy {
        return ACCourseAcademy(
            id: AwesomeCoreParser.intValue(jsonObject, key: "id"),
            domain: ParserCoreHelper.parseString(jsonObject, key: "domain"),
            awcProductId: ParserCoreHelper.parseString(jsonObject, key: "awc_product_id")
        )
    }
    
}
