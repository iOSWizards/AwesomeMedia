//
//  QuestError.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 17/11/17.
//

import Foundation

public struct QuestError: Codable {
    
    public let errors: [MainError]
    
}

// MARK: - JSON Key

public struct MainError: Codable {
    
    public let message: String
    public let locations: [ErrorLocation]?
    
    public struct ErrorLocation: Codable {
        
        public let line: Int?
        public let column: Int?
        
    }
    
}

// MARK: - Equatable

extension QuestError {
    public static func ==(lhs: QuestError, rhs: QuestError) -> Bool {
        if lhs.errors.first?.message != rhs.errors.first?.message {
            return false
        }
        return true
    }
}

