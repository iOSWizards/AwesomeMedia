//
//  SingleCourseMP.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 11/09/17.
//

import Foundation

struct SingleCourseMP {
    
    static func parseSingleCoursesFrom(_ singleCoursesJSON: [String: AnyObject]) -> [TrainingCard] {
        
        var singleCourses: [TrainingCard] = []
        if let courses = singleCoursesJSON["single_courses"] as? [[String: AnyObject]] {
            for course in courses {
                if let parsedCourse = TrainingCardMP.parseTrainingCardFrom(course) {
                    singleCourses.append(parsedCourse)
                }
            }
        }
        
        return singleCourses
    }
    
}
