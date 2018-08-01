//
//  SingleCourseBO.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 11/09/17.
//

import Foundation

public struct SingleCourseBO {
    
    static var singleCourseNS = SingleCourseNS.shared
    
    private init() {}
    
    public static func fetchSingleCourses(forcingUpdate: Bool = false, response: @escaping ([TrainingCard], ErrorData?) -> Void) {
        singleCourseNS.fetchSingleCourses(forcingUpdate: forcingUpdate) { (courses, error) in
            DispatchQueue.main.async {
                response(courses, error)
            }
        }
    }
}

