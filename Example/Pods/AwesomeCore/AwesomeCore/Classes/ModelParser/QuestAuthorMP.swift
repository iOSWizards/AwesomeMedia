//
//  QuestAuthor.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/3/17.
//

import Foundation

struct QuestAuthorMP {
    
    static func parseQuestAuthorsFrom(_ questAuthorsJSON: Data) -> [QuestAuthor] {
        
        var authors: [QuestAuthor] = []
        if let decoded = try? JSONDecoder().decode(QuestAuthors.self, from: questAuthorsJSON) {
            authors = decoded.authors
        }
        
        return authors
    }
    
}
