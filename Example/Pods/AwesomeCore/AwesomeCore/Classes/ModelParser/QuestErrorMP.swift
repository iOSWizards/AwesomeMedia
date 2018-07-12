//
//  QuestErrorMP.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 17/11/17.
//

import Foundation

struct QuestErrorMP {
    
    static func parseQuestErrorFrom(_ questErrorJSON: Data) -> [MainError] {
        
        var errors: [MainError] = []
        if let decoded = try? JSONDecoder().decode(QuestError.self, from: questErrorJSON) {
            errors = decoded.errors
        }
        
        return errors
    }
    
}
