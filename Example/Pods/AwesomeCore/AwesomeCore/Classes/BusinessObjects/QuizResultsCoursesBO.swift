//
//  QuizResultsCoursesBO.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 06/03/18.
//

import Foundation

public struct QuizResultsCoursesBO {
    
    static var quizResultsCoursesNS = QuizResultsCoursesNS.shared
    public static var shared = QuizResultsCoursesBO()
    
    private init() {}
    
    public static func fetchQuizResultsCourses(withIds ids: String, forcingUpdate: Bool = false, response: @escaping ([QuizCourses], ErrorData?) -> Void) {
        quizResultsCoursesNS.fetchQuizResultsCourses(withIds: ids) { (courses, error) in
            DispatchQueue.main.async {
                response(courses, error)
            }
        }
    }
}

