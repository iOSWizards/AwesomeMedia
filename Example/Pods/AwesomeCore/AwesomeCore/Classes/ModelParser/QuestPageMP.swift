//
//  QuestPageMP.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/3/17.
//

import Foundation

struct QuestPageMP {
    
    static func parseQuestPagesFrom(_ questPagesJSON: Data) -> [QuestPage] {
        
        var pages: [QuestPage] = []
        if let decoded = try? JSONDecoder().decode(QuestPages.self, from: questPagesJSON) {
            pages = decoded.pages
        }
        
        return pages
    }
    
    static func parseQuestPageFrom(_ QuestPageJSON: Data) -> QuestPage? {
        var page: QuestPage?
        do {
            let decoded = try JSONDecoder().decode(SingleQuestPageDataKey.self, from: QuestPageJSON)
            page = decoded.data.page
        } catch {
            print("\(#function) error: \(error)")
        }
        return page
    }
}
