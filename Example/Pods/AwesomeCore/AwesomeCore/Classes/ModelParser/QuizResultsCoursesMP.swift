//
//  QuizResultsCoursesMP.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 06/03/18.
//

import Foundation

struct QuizResultsCoursesMP {
    
    static func parseQuizCoursesFrom(_ quizResultsJson: Data) -> QuizResultsCourses {
        
        if let decoded = try? JSONDecoder().decode(QuizResultsCourses.self, from: quizResultsJson) {
            return decoded
        } else {
            return QuizResultsCourses(courses: [])
        }
    }
    
}
