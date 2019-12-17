//
//  BubbleQuizSubmitAnswersMP.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 28/02/19.
//

import Foundation

struct BubbleQuizSubmitAnswersMP {
    
    static func parse(_ data: Data) -> BubbleQuizSubmitAnswersResponse? {
        do {
            let decoded = try JSONDecoder().decode(BubbleQuizSubmitAnswers.self, from: data)
            return decoded.data?.submitQuizResponse
        } catch {
            print("\(#function) error: \(error)")
        }
        return nil
    }
    
}
