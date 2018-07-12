//
//  CompletionProgress.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 14/07/2017.
//

import Foundation

public struct CompletionProgress: Codable, Equatable {
    
    public let totalChapters: Int
    public let chaptersRead: Int
    public let completionPercentage: Double
    
    public init (totalChapters: Int, chaptersRead: Int, completionPercentage: Double) {
        self.totalChapters = totalChapters
        self.chaptersRead = chaptersRead
        self.completionPercentage = completionPercentage
    }
    
}

// MARK:- Equatable

extension CompletionProgress {
    
    public static func ==(lhs: CompletionProgress, rhs: CompletionProgress) -> Bool {
        if lhs.totalChapters != rhs.totalChapters {
            return false
        }
        if lhs.chaptersRead != rhs.chaptersRead {
            return false
        }
        if lhs.completionPercentage != rhs.completionPercentage {
            return false
        }
        return true
    }
    
}
